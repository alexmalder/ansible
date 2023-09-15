local uuid = require('uuid')
-- dev
local http_client = require('http.client').new()
local json = require('json')

require('validation')

box.cfg {listen = 3301}

box.schema.user.create('tarantool', {
  password = 'tarantool', 
  if_not_exists = true
})
box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {
  if_not_exists = true
})

local accounts = box.schema.create_space('accounts', {
  if_not_exists = true
})
local proofs = box.schema.create_space("proofs", {
  if_not_exists = true
})
local sins = box.schema.create_space("sins", {
  if_not_exists = true
})

accounts:format({
  {name = 'id', type = 'uuid'},
  {name = 'username', type = 'string'},
  {name = 'password', type = 'string'},
  {name = 'age', type = 'number'},
  {name = 'is_active', type = 'boolean'}
})

sins:format({
  {name = 'id', type = 'uuid'},
  {name = 'title', type = 'string'},
  {name = 'description', type = 'string'},
  if_not_exists = true
})

proofs:format({
  {name = 'id', type = 'uuid'},
  {name = 'title', type = 'string'},
  {name = 'link', type = 'string'},
  {name = 'account_id', type = 'string'},
  {name = 'sin_id', type = 'string'},
  if_not_exists = true
})

accounts:create_index('primary', {
  parts = {'id'},
  unique = true,
  type = 'TREE',
  if_not_exists = true
})

accounts:create_index('username', {
  parts = {'username'},
  unique = true,
  type = 'TREE',
  if_not_exists = true
})

accounts:create_index('is_active', {
  parts = {'is_active'},
  unique = false,
  type = 'TREE',
  if_not_exists = true
})

sins:create_index('primary', {
  type = 'TREE',
  parts = {'id'},
  unique = true,
  if_not_exists = true
})

sins:create_index('title', {
  type = 'TREE',
  parts = {'title'},
  unique = true,
  if_not_exists = true
})

proofs:create_index('primary', {
  type = 'TREE',
  parts = {'id'},
  unique = true,
  if_not_exists = true
})

proofs:create_index('title', {
  type = 'TREE',
  parts = {'title'},
  unique = true,
  if_not_exists = true
})

proofs:create_index('account_id', {
  type = 'TREE',
  parts = {'account_id'},
  unique = false,
  if_not_exists = true
})

proofs:create_index('sin_id', {
  type = 'TREE',
  parts = {'sin_id'},
  unique = false,
  if_not_exists = true
})

-- http api
--
local function default_handler(req)
  return req:render{json = { ['data'] = 'ok' }}
end

local function keycloak_handler(req)
  --local response = http_client:request('GET', 'http://keycloak:8080/auth/')
  --resp.headers['Content-Type'] = 'application/json';
  --local uuid_id = uuid.fromstr(id)
  local id = req:stash('id')
  return req:render{json = {
    ['sub'] = id,
    ['headers'] = req.headers
  }}
end

local function get_sins(req)
  a = {}
  sins = box.space.sins:select({}, {iterator='GT', limit = 100})
  for i, v in ipairs(sins) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      description = v['description']
    }
  end
  return req:render{json = {['data'] = a, ['headers'] = req.headers}}
end

local function get_sin(req)
  a = {}
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  sins = box.space.sins.index.primary:select{uuid_id}
  for i, v in ipairs(sins) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      description = v['description']
    }
  end
  return req:render{json = {['data'] = a}}
end

local function post_sin(req)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, sin_schema)
  if errstack then
    local resp req:render({
      json = {
        ['data'] = errstack
      }
    })
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  else
    local sin = box.space.sins:insert{
      uuid.new(), lua_table['title'], lua_table['description']
    }
    return req:render{
      json = {
        ['data'] = {
          ['id'] = sin[1],
          ['title'] = sin[2],
          ['description'] = sin[3]
        }
      }
    }
  end
end

local function put_sin(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()

  local errstack = validate_schema(lua_table, sin_schema)
  if errstack then
    local resp req:render({
      json = {
        ['data'] = errstack
      }
    })
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  else
    local sin = box.space.sins.index.primary:update({uuid_id}, {
      {'=', uuid_id, lua_table['title'], lua_table['description']}
    })
    return req:render{
      json = {
        ['data'] = {
          ['id'] = sin[1],
          ['title'] = sin[2],
          ['description'] = sin[3]
        }
      }
    }
  end
end

local function delete_sin(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local sin = box.space.sins.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = sin}}
end

local function get_accounts(req)
  local a = {}
  local accounts = box.space.accounts:select({}, {iterator='GT', limit = 100})
  for i, v in ipairs(accounts) do
    a[i] = {id = v['id'], username = v['username'], age = v['age']}
  end
  return req:render{json = {['data'] = a}}
end

local function get_account(req)
  local a = {}
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local accounts = box.space.accounts.index.primary:select{uuid_id}
  for i, v in ipairs(accounts) do
    a[i] = {id = v['id'], username = v['username'], age = v['age']}
  end
  return req:render{json = {['data'] = a}}
end

local function put_account(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, account_schema)
  if errstack then
    local resp req:render({
      json = {
        ['data'] = errstack
      }
    })
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  else
    local account = box.space.sins.index.primary:update({uuid_id}, {
      {
        '=',
        uuid_id,
        lua_table['username'],
        lua_table['password'],
        lua_table['age']}
    })
    return req:render{
      json = {
        ['data'] = {
          ['id'] = account[1],
          ['username'] = account[2],
          ['password'] = account[3],
          ['age'] = account[4]
        }
      }
    }
  end
end

local function post_account(req)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, account_schema)
  if errstack then
    local resp = req:render({
      json = {
        ['data'] = errstack
      }
    })
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  else
    local account = box.space.accounts:insert{
      uuid.new(),
      lua_table['username'],
      lua_table['password'],
      lua_table['age'],
      true
    }
    return req:render{
      json = {
        ['data'] = {
          ['id'] = account[1],
          ['username'] = account[2],
          ['age'] = account[4],
          is_active = account[5]
        }
      }
    }
  end
end

local function delete_account(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local account = box.space.accounts.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = account}}
end

local function post_seed(req)
  local first_user = box.space.accounts:insert{uuid.new(), "alexmalder", "denied", 28, true}
  print(first_user)
  box.space.accounts:insert{uuid.new(), "darya", "12345", 36, true}
  box.space.accounts:insert{uuid.new(), "pavel", "123456", 26, true}
  -- create sins
  local first_sin = box.space.sins:insert{
    uuid.new(), "watch videos", "watch some videos on internet"
  }
  print(first_sin)
  box.space.sins:insert{
    uuid.new(), "send messages", "send messages with messengers"
  }
  box.space.sins:insert{uuid.new(), "procrastination", "no comments))"}
  return req:render{
    json = {
      ['user'] = {
        ['id'] = first_user[1],
        ['username'] = first_user[2],
        ['password'] = first_user[3],
        ['age'] = first_user[4]
      },
      ['sin'] = {
        ['id'] = first_sin[1],
        ['title'] = first_sin[2],
        ['description'] = first_sin[3]
      }
    }
  }
end

local server = require('http.server').new(nil, 8090, {charset = "utf8"})
server:route({path = '/', method = 'GET'}, default_handler)
server:route({path = '/keycloak/:id', method = 'GET'}, keycloak_handler)
-- accounts crud
server:route({path = '/accounts', method = 'GET'}, get_accounts)
server:route({path = '/accounts/:id', method = 'GET'}, get_account)
server:route({path = '/accounts', method = 'POST'}, post_account)
server:route({path = '/accounts/:id', method = 'PUT'}, put_account)
server:route({path = '/accounts/:id', method = 'POST'}, delete_account)
-- sins crud
server:route({path = '/sins', method = 'GET'}, get_sins)
server:route({path = '/sins/:id', method = 'GET'}, get_sin)
server:route({path = '/sins', method = 'POST'}, post_sin)
server:route({path = '/sins/:id', method = 'PUT'}, put_sin)
server:route({path = '/sins/:id', method = 'DELETE'}, delete_sin)
-- proofs crud
server:route({path = '/proofs', method = 'GET'}, get_proofs)
server:route({path = '/proofs/:id', method = 'GET'}, get_proof)
server:route({path = '/proofs', method = 'POST'}, post_proof)
server:route({path = '/proofs/:id', method = 'PUT'}, put_proof)
server:route({path = '/proofs/:id', method = 'DELETE'}, delete_proof)
-- tech endpoint
server:route({path = '/seed', method = 'POST'}, post_seed)
server:start()
