local uuid = require('uuid')

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

accounts:create_index('primary_index', {
    parts = {'id'},
    unique = true,
    type = 'TREE',
    if_not_exists=true
})

accounts:create_index('username_index', {
    parts = {'username'},
    unique = true,
    type = 'TREE',
    if_not_exists=true
})

accounts:create_index('is_active_index', {
    parts = {'is_active'},
    unique = false,
    type = 'TREE',
    if_not_exists=true
})

sins:create_index('primary_index', {
    type = 'TREE',
    parts = {'id'},
    unique = true,
    if_not_exists = true
})

sins:create_index('title_index', {
    type = 'TREE',
    parts = {'title'},
    unique = true,
    if_not_exists = true
})

proofs:create_index('primary_index', {
    type = 'TREE',
    parts = {'id'},
    unique = true,
    if_not_exists = true
})

proofs:create_index('title_index', {
    type = 'TREE',
    parts = {'title'},
    unique = true,
    if_not_exists = true
})

proofs:create_index('account_index', {
    type = 'TREE',
    parts = {'account_id'},
    unique = false,
    if_not_exists = true
})

proofs:create_index('sin_index', {
    type = 'TREE',
    parts = {'sin_id'},
    unique = false,
    if_not_exists = true
})

function select_accounts()
  return box.space.accounts:select{}
end

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

local function get_accounts(req)
    return req:render{ json = { ['data'] = box.space.accounts:select() } }
end

local function post_account(req)
  local lua_table = req:json()
  account = box.space.accounts:insert{uuid.new(), lua_table['username'], lua_table['password'], true}
  return req:render{ json = { ['account'] = account } }
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

local server = require('http.server').new(nil, 8080, {charset = "utf8"}) -- listen *:8080
server:route({ path = '/', method = 'POST' }, handler)
server:route({ path = '/accounts', method = 'GET' }, get_accounts)
server:route({ path = '/accounts', method = 'POST' }, post_account)
server:route({ path = '/seed', method = 'POST' }, post_seed)
server:start()

