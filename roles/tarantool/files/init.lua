local uuid = require('uuid')
-- dev
local http_client = require('http.client').new()
local json = require('json')

box.cfg { listen = 3301 }

box.schema.user.create('tarantool', {password = 'tarantool', if_not_exists = true})
box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {if_not_exists=true})

accounts = box.schema.create_space('accounts', { if_not_exists = true })
proofs = box.schema.create_space("proofs", { if_not_exists = true })
sins = box.schema.create_space("sins", { if_not_exists = true })

accounts:format({
    { name = 'id', type = 'uuid', },
    { name = 'username', type = 'string' },
    { name = 'password', type = 'string' },
    { name = 'is_active', type = 'boolean' }
})

sins:format({
    { name = 'id', type = 'uuid', },
    { name = 'title', type = 'string' },
    { name = 'description', type = 'string' },
    if_not_exists=true
})

proofs:format({
    { name = 'id', type = 'uuid' },
    { name = 'title', type = 'string' },
    { name = 'link', type = 'string' },
    { name = 'account_id', type = 'string' },
    { name = 'sin_id', type = 'string' },
    if_not_exists=true
})

accounts:create_index('primary', {
    parts = {'id'},
    unique = true,
    type = 'TREE',
    if_not_exists=true
})

accounts:create_index('username', {
    parts = {'username'},
    unique = true,
    type = 'TREE',
    if_not_exists=true
})

accounts:create_index('is_active', {
    parts = {'is_active'},
    unique = false,
    type = 'TREE',
    if_not_exists=true
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

local function get_keys(json_object, top_key)
  local keys={}
  for key,_ in pairs(json_object) do
    if key == top_key then
      return true
    else
      return false
    end
    --table.insert(keys, key)
  end
  --return keys
end

local function handler(req)
  local lua_table = req:json()
  local resp = req:render{json = {['data'] = get_keys(lua_table, "id") }}
  return resp
end

local function get_sins(req)
    a = {}
    sins = box.space.sins:select()
    for i, v in ipairs(sins) do
      a[i] = {id=v['id'], title=v['title'], description=v['description']}
    end
    return req:render{ json = { ['data'] = a } }
end

local function post_sin(req)
  local lua_table = req:json()
  sin = box.space.sins:insert{uuid.new(), lua_table['title'], lua_table['description']}
  return req:render{ json = { ['data'] = {['id'] = sin[1], ['title']=sin[2],['description']=sin[3]} } }
end

local function put_sin(req)
  local id = req:stash('id')
  uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  sin = box.space.sins.index.primary:update({uuid_id}, {{'=', uuid_id, lua_table['title'], lua_table['description']}})
  return req:render{ json = { ['data'] = {['id'] = sin[1], ['title']=sin[2],['description']=sin[3]} } }
end

local function delete_sin(req)
  local id = req:stash('id')    -- here is :id value
  uuid_id=uuid.fromstr(id)
  sin = box.space.sins.index.primary:delete{uuid_id}
  return req:render{ json = { ['data'] = sin } }
end

local function get_accounts(req)
    a = {}
    accounts = box.space.accounts:select()
    for i, v in ipairs(accounts) do
      a[i] = {id=v['id'], username=v['username']}
    end
    return req:render{ json = { ['data'] = a } }
end

local function post_account(req)
  local lua_table = req:json()
  account = box.space.accounts:insert{uuid.new(), lua_table['username'], lua_table['password'], true}
  return req:render{ json = { ['data'] = {['id']=account[1],['username']=account[2],is_active=account[4]} } }
end

local function delete_account(req)
  local id = req:stash('id')    -- here is :id value
  uuid_id=uuid.fromstr(id)
  account = box.space.accounts.index.primary:delete{uuid_id}
  return req:render{ json = { ['data'] = account } }
end

local function post_seed(req)
  first_user = box.space.accounts:insert{uuid.new(), "alexmalder", "denied", true}
  print(first_user)
  box.space.accounts:insert{uuid.new(), "darya", "12345", true}
  box.space.accounts:insert{uuid.new(), "pavel", "123456", true}
  -- create sins
  first_sin = box.space.sins:insert{uuid.new(), "watch videos", "watch some videos on internet"}
  print(first_sin)
  box.space.sins:insert{uuid.new(), "send messages", "send messages with messengers"}
  box.space.sins:insert{uuid.new(), "procrastination", "no comments))"}
  return req:render{ 
    json = { ['user'] = {
      ['id'] = first_user[1],
      ['username'] = first_user[2],
      ['password'] = first_user[3],
    }, ['sin'] = {
      ['id'] = first_sin[1],
      ['title'] = first_sin[2],
      ['description'] = first_sin[3]
    } }
  }
end

local function post_test(req)
  local response = http_client:request('POST', 'http://127.0.0.1:8080/seed')
  print(response.body)
end

local server = require('http.server').new(nil, 8080, {charset = "utf8"}) -- listen *:8080
server:route({ path = '/', method = 'POST' }, handler)
server:route({ path = '/accounts', method = 'GET' }, get_accounts)
server:route({ path = '/accounts', method = 'POST' }, post_account)
server:route({ path = '/accounts/:id', method = 'POST' }, delete_account)
server:route({ path = '/sins', method = 'GET' }, get_sins)
server:route({ path = '/sins', method = 'POST' }, post_sin)
server:route({ path = '/sins/:id', method = 'PUT' }, put_sin)
server:route({ path = '/sins/:id', method = 'DELETE' }, delete_sin)
server:route({ path = '/seed', method = 'POST' }, post_seed)
server:route({ path = '/test', method = 'POST' }, post_test)
server:start()
