local uuid = require('uuid')
local json = require('json')

require("validation")

-- tarantool part
local box=box

box.cfg {listen = 3301}

box.schema.user.create('tarantool', {
  password = 'tarantool',
  if_not_exists = true
})

box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {
  -- user grant if not exists
  if_not_exists = true
})

-- spaces and formats
local feed = box.schema.create_space("feed", {
  -- feed space if not exists
  if_not_exists = true
})

feed:format({
  {name = 'id', type = 'uuid'},
  {name = 'title', type = 'string'},
  {name = 'link', type = 'string'},
  {name = 'account_id', type = 'uuid'},
  if_not_exists = true
})

local labels = box.schema.create_space("labels", {
  -- schema labels
  if_not_exists = true
})

labels:format({
  {name = 'id', type = 'uuid'},
  {name = 'title', type = 'string'},
  {name = 'description', type = 'string'},
  if_not_exists = true
})

local feed_labels = box.schema.create_space("feed_labels", {
  -- feed labels space if not exists
  if_not_exists = true
})

feed_labels:format({
  {name = 'feed_id', type = 'uuid'},
  {name = 'label_id', type = 'uuid'},
  if_not_exists = true
})

-- setup indexes
feed:create_index('primary', {
  type = 'TREE',
  parts = {'id'},
  unique = true,
  if_not_exists = true
})

feed:create_index('title', {
  type = 'TREE',
  parts = {'title'},
  unique = true,
  if_not_exists = true
})

feed:create_index('account_id', {
  type = 'TREE',
  parts = {'account_id'},
  unique = false,
  if_not_exists = true
})

labels:create_index('primary', {
  type = 'TREE',
  parts = {'id'},
  unique = true,
  if_not_exists = true
})

labels:create_index('title', {
  type = 'TREE',
  parts = {'title'},
  unique = true,
  if_not_exists = true
})

feed_labels:create_index('primary', {
  type = 'TREE',
  parts = {
    {'feed_id'},
    {'label_id'}
  },
  unique = true,
  if_not_exists = true
})

feed_labels:create_index('feed_id', {
  type = 'TREE',
  parts = {'feed_id'},
  unique = false,
  if_not_exists = true
})

-- api
local function default_handler(req)
  -- default response
  return req:render{json = { ['data'] = 'Hello from tarantool' }}
end

local function keycloak_handler(req)
  local sub = req:stash('sub')
  local json_roles = req:stash('roles')
  local roles = json.decode(json_roles)
  return req:render{json = {
    ['sub'] = sub,
    ['roles'] = roles,
  }}
end

-- label api
local function get_labels(req)
  local a = {}
  local items = box.space.labels:select({}, {iterator='GT', limit = 100})
  for i, v in ipairs(items) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      description = v['description']
    }
  end
  return req:render{json = {['data'] = a}}
end

local function get_label(req)
  local a = {}
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local items = box.space.labels.index.primary:select{uuid_id}
  for i, v in ipairs(items) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      description = v['description']
    }
  end
  return req:render{json = {['data'] = a}}
end

local function post_label(req)
  local lua_table = req:json()
  local errstack = ValidateSchema(lua_table, LabelSchema)
  print(errstack)
  if next(errstack) == nil then
    local label = box.space.labels:insert{
      uuid.new(),
      lua_table['title'],
      lua_table['description']
    }
    return req:render{
      json = {
        ['data'] = {
          ['id'] = label[1],
          ['title'] = label[2],
          ['description'] = label[3]
        }
      }
    }
  else
    local resp = req:render{
      json = {
        ['data'] = errstack
      }
    }
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

local function put_label(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  local errstack = ValidateSchema(lua_table, LabelSchema)
  if next(errstack) == nil then
    local label = box.space.labels.index.primary:update({uuid_id}, {
      {'=', 1, uuid_id},
      {'=', 2, lua_table['title']},
      {'=', 3, lua_table['description']}
    })
    return req:render{
      json = {
        ['data'] = {
          ['id'] = label[1],
          ['title'] = label[2],
          ['description'] = label[3]
        }
      }
    }
  else
    local resp req:render({
      json = {
        ['data'] = errstack
      }
    })
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

local function delete_label(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local label = box.space.labels.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = label}}
end

-- feed api

-- @description
-- 1. get all feeds with limit (and offset)
-- 2. get feed_labels by feed_id in `for`
-- 3. get label by founded feed_id in `for`
local function get_feeds(req)
  local a = {}
  local local_feeds = box.space.feed:select({}, {iterator='GT', limit = 100})
  for i, local_feed in ipairs(local_feeds) do
    local table_labels = {}
    local local_feed_labels = box.space.feed_labels.index.feed_id:select{local_feed['id']}
    for idx, local_feed_label in ipairs(local_feed_labels) do
      local local_labels = box.space.labels.index.primary:select{local_feed_label['label_id']}
      for lidx, local_label in ipairs(local_labels) do
        table_labels[idx] = {
          id = local_label['id'],
          title = local_label['title'],
          description = local_label['description']
        }
      end
    end
    a[i] = {
      id = local_feed['id'],
      title = local_feed['title'],
      link = local_feed['link'],
      account_id = local_feed['account_id'],
      labels = table_labels
    }
  end
  return req:render{json = {['data'] = a}}
end

local function get_feed(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local item = box.space.feed.index.primary:get{uuid_id}
  local response_data = {
    id = item['id'],
    title = item['title'],
    link = item['link'],
    account_id = item['account_id']
  }
  return req:render{json = {['data'] = response_data}}
end

local function post_feed(req)
  local lua_table = req:json()
  local sub = req:stash('sub')
  local account_id = uuid.fromstr(sub)
  local errstack = ValidateSchema(lua_table, FeedSchema)
  if next(errstack) == nil then
    local items = box.space.feed:insert{
      uuid.new(),
      lua_table['title'],
      lua_table['link'],
      account_id,
    }
    return req:render{
      json = {
        ['data'] = {
          ['id'] = items[1],
          ['title'] = items[2],
          ['link'] = items[3],
          ['account_id'] = items[4],
        }
      }
    }
  else
    local resp = req:render{
      json = {
        ['data'] = errstack
      }
    }
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

local function put_feed(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  local errstack = ValidateSchema(lua_table, FeedSchema)
  local sub = req:stash('sub')
  local account_id = uuid.fromstr(sub)
  if next(errstack) == nil then
    local items = box.space.feed.index.primary:update({uuid_id}, {
      { '=', 1, uuid_id },
      { '=', 2, lua_table['title']},
      { '=', 3, lua_table['link']},
      { '=', 4, account_id},
    })
    return req:render{
      json = {
        ['data'] = {
          ['id'] = items[1],
          ['title'] = items[2],
          ['link'] = items[3],
          ['account_id'] = items[4],
        }
      }
    }
  else
    local resp req:render({
      json = {
        ['data'] = errstack
      }
    })
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

local function delete_feed(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local items = box.space.feed.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = items}}
end

-- fl api
--
local function get_feed_labels(req)
  local a = {}
  local items = box.space.feed_labels:select({}, {iterator='GT', limit = 100})
  if next(items) ~= nil then
    for i, item in ipairs(items) do
      a[i] = {
        feed_id = item['feed_id'],
        label_id = item['label_id'],
      }
    end
    return req:render{
      json = {
        ['data'] = a
      }
    }
  else
    local resp = req:render{
      json = {
        ['data'] = 'No Content'
      }
    }
    resp.status = 204
    return resp
  end
end

local function get_feed_labels_by_feed_id(req)
  local a = {}
  local feed_id = req:stash('feed_id')
  local uuid_feed_id = uuid.fromstr(feed_id)
  local items = box.space.feed_labels.index.feed_id:select{uuid_feed_id}
  for i, v in ipairs(items) do
    a[i] = {
      feed_id = v['feed_id'],
      label_id = v['label_id'],
    }
  end
  return req:render{json = {
      ['data'] = a
  }}
end

local function post_feed_label(req)
  local lua_table = req:json()
  local errstack = ValidateSchema(lua_table, FeedLabelSchema)
  if next(errstack) == nil then
    local uuid_feed_id = uuid.fromstr(lua_table['feed_id'])
    local uuid_label_id = uuid.fromstr(lua_table['label_id'])
    local items = box.space.feed_labels:insert{ uuid_feed_id, uuid_label_id }
    return req:render{
      json = {
        ['data'] = {
          ['feed_id'] = items[1],
          ['label_id'] = items[2],
        }
      }
    }
  else
    local resp = req:render{
      json = {
        ['data'] = errstack
      }
    }
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

local function put_feed_label(req)
  local lua_table = req:json()
  local current_feed_id = uuid.fromstr(lua_table['old_feed_id'])
  local current_label_id = uuid.fromstr(lua_table['old_label_id'])
  local new_feed_id = uuid.fromstr(lua_table['new_feed_id'])
  local new_label_id = uuid.fromstr(lua_table['new_label_id'])
  local feed_label = box.space.feed_labels:replace({current_feed_id, current_label_id}, {
    { '=', 1, new_feed_id },
    { '=', 2, new_label_id },
  })
  return req:render{
    json = {
      ['data'] = feed_label
    }
  }
end

local function delete_feed_label(req)
  local feed_id = req:stash('feed_id')
  local uuid_feed_id = uuid.fromstr(feed_id)
  local label_id = req:stash('label_id')
  local uuid_label_id = uuid.fromstr(label_id)
  local fl = box.space.feed_labels.index.primary:delete({
    uuid_feed_id,
    uuid_label_id
  })
  return req:render{json = {['data'] = fl}}
end

local function listen_http_api()
  local server = require('http.server').new(nil, 8090, {charset = "utf8"})
  server:route({path = '/', method = 'GET'}, default_handler)
  server:route({path = '/keycloak/:sub/:roles', method = 'GET'}, keycloak_handler)
  -- labels crud
  server:route({path = '/keycloak/:sub/labels', method = 'GET'}, get_labels)
  server:route({path = '/keycloak/:sub/labels/:id', method = 'GET'}, get_label)
  server:route({path = '/keycloak/:sub/labels', method = 'POST'}, post_label)
  server:route({path = '/keycloak/:sub/labels/:id', method = 'PUT'}, put_label)
  server:route({path = '/keycloak/:sub/labels/:id', method = 'DELETE'}, delete_label)
  -- feed crud
  server:route({path = '/keycloak/:sub/feed', method = 'GET'}, get_feeds)
  server:route({path = '/keycloak/:sub/feed/:id', method = 'GET'}, get_feed)
  server:route({path = '/keycloak/:sub/feed', method = 'POST'}, post_feed)
  server:route({path = '/keycloak/:sub/feed/:id', method = 'PUT'}, put_feed)
  server:route({path = '/keycloak/:sub/feed/:id', method = 'DELETE'}, delete_feed)
  -- feed label modifications
  server:route({path = '/keycloak/:sub/fl', method = 'GET'}, get_feed_labels)
  server:route({path = '/keycloak/:sub/fl/:feed_id', method = 'GET'}, get_feed_labels_by_feed_id)
  server:route({path = '/keycloak/:sub/fl', method = 'POST'}, post_feed_label)
  server:route({path = '/keycloak/:sub/fl', method = 'PUT'}, put_feed_label)
  server:route({path = '/keycloak/:sub/fl/:feed_id/:label_id', method = 'DELETE'}, delete_feed_label)

  -- server starting
  server:start()
end

-- Undefined_type(nil, nil)
ValidationTest()
listen_http_api()
