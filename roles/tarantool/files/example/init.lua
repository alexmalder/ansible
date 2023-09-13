-- identifiers generator
local uuid = require('uuid')

-- listen 3301 tcp port
box.cfg {listen = 3301}

-- create user
box.schema.user.create('tarantool', {password = 'tarantool', if_not_exists = true})
box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {if_not_exists = true})

-- create space
local accounts = box.schema.create_space('accounts', {if_not_exists = true})

-- apply schema
accounts:format({
    {name = 'id', type = 'uuid'}, 
    {name = 'username', type = 'string'},
    {name = 'password', type = 'string'}, 
    {name = 'is_active', type = 'boolean'}
})

-- primary index by id
accounts:create_index('primary', {
    parts = {'id'},
    unique = true,
    type = 'TREE',
    if_not_exists = true
})

-- username index by username
accounts:create_index('username', {
    parts = {'username'},
    unique = true,
    type = 'TREE',
    if_not_exists = true
})

-- is_active index by is_active
accounts:create_index('is_active', {
    parts = {'is_active'},
    unique = false,
    type = 'TREE',
    if_not_exists = true
})

-- http api

-- helper function
local function get_keys(json_object, top_key)
    local keys = {}
    for key, _ in pairs(json_object) do
        if key == top_key then
            return true
        else
            return false
        end
        -- table.insert(keys, key)
    end
    -- return keys
end

-- get all accounts
local function get_accounts(req)
    local a = {}
    local accounts = box.space.accounts:select({}, {iterator='GT', limit = 100})
    for i, v in ipairs(accounts) do
        a[i] = {id = v['id'], username = v['username']}
    end
    return req:render{json = {['data'] = a}}
end

-- get account by id
local function get_account(req)
    local a = {}
    local id = req:stash('id')
    local uuid_id = uuid.fromstr(id)
    local accounts = box.space.accounts.index.primary:select{uuid_id}
    for i, v in ipairs(accounts) do
        a[i] = {id = v['id'], username = v['username']}
    end
    return req:render{json = {['data'] = a}}
end

-- post account
local function post_account(req)
    local lua_table = req:json()
    local account = box.space.accounts:insert{
        uuid.new(), lua_table['username'], lua_table['password'], true
    }
    return req:render{
        json = {
            ['data'] = {
                ['id'] = account[1],
                ['username'] = account[2],
                -- password ignored
                is_active = account[4]
            }
        }
    }
end

-- put account, update only password allowed
local function put_account(req)
    local id = req:stash('id')
    local uuid_id = uuid.fromstr(id)
    local lua_table = req:json()
    local account = box.space.accounts:update(uuid_id, {{ '=', 3, lua_table['password']}})
    return req:render{
        json = {
            ['data'] = {
                ['id'] = account[1],
                ['title'] = account[2],
                ['description'] = account[3]
            }
        }
    }
end

-- delete account
local function delete_account(req)
    local id = req:stash('id') -- here is :id value
    local uuid_id = uuid.fromstr(id)
    local account = box.space.accounts.index.primary:delete{uuid_id}
    return req:render{json = {['data'] = account}}
end

-- listen 8080 http port
local server = require('http.server').new(nil, 8080, {charset = "utf8"})

-- accounts crud
server:route({path = '/accounts', method = 'GET'}, get_accounts)
server:route({path = '/accounts/:id', method = 'GET'}, get_account)
server:route({path = '/accounts', method = 'POST'}, post_account)
server:route({path = '/accounts/:id', method = 'PUT'}, put_account)
server:route({path = '/accounts/:id', method = 'POST'}, delete_account)

-- start http server
server:start()
