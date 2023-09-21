local uuid = require('uuid')
local json = require('json')

require('validation')

function default_handler(req)
  return req:render{json = { ['data'] = 'Hello from tarantool' }}
end

function keycloak_handler(req)
  local sub = req:stash('sub')
  local json_roles = req:stash('roles')
  local roles = json.decode(json_roles)
  return req:render{json = {
    ['sub'] = sub,
    ['roles'] = roles,
  }}
end

-- label api
function get_labels(req)
  a = {}
  items = box.space.labels:select({}, {iterator='GT', limit = 100})
  for i, v in ipairs(items) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      description = v['description']
    }
  end
  return req:render{json = {['data'] = a}}
end

function get_label(req)
  local a = {}
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  items = box.space.labels.index.primary:select{uuid_id}
  for i, v in ipairs(items) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      description = v['description']
    }
  end
  return req:render{json = {['data'] = a}}
end

function post_label(req)
  local title = req:post_param(title)
  local description = req:post_param(description)
  print(title, description)
  local lua_table = {
    ['title'] = title,
    ['description'] = description
  }
  local errstack = validate_schema(lua_table, label_schema)
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
    print_table("ERROR STACK", errstack)
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

function put_label(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, label_schema)
  if next(errstack) == nil then
    local label = box.space.labels.index.primary:update({uuid_id}, {
      {'=', uuid_id, lua_table['title'], lua_table['description']}
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

function delete_label(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local label = box.space.labels.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = label}}
end

-- feed api
function get_feeds(req)
  a = {}
  local items = box.space.feed:select({}, {iterator='GT', limit = 100})
  for i, v in ipairs(items) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      link = v['link'],
      account_id = v['account_id']
    }
  end
  return req:render{json = {['data'] = a}}
end

function get_feed(req)
  local a = {}
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  items = box.space.feed.index.primary:select{uuid_id}
  for i, v in ipairs(items) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      link = v['link'],
      account_id = v['account_id']
    }
  end
  return req:render{json = {['data'] = a}}
end

function post_feed(req)
  print("REQ QUERY", req.query)
  local lua_table = req:json()
  local sub = req:stash('sub')
  print(lua_table, sub)
  local errstack = validate_schema(lua_table, feed_schema)
  if next(errstack) == nil then
    local items = box.space.feed:insert{
      uuid.new(),
      lua_table['title'],
      lua_table['link'],
      uuid.fromstr(sub),
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
    print_table("ERROR STACK", errstack)
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

function put_feed(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, feed_schema)
  if next(errstack) == nil then
    local items = box.space.feed.index.primary:update({uuid_id}, {
      {
        '=',
        uuid_id,
        lua_table['title'],
        lua_table['link'],
        lua_table['account_id'],
      }
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

function delete_feed(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local items = box.space.feed.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = items}}
end

-- fl api
function post_feed_label(req)
  local feed_id = req:post_param(feed_id)
  local label_id = req:post_param(label_id)
  print(feed_id, label_id)
  local lua_table = {
    ['feed_id'] = feed_id,
    ['label_id'] = label_id
  }
  local errstack = validate_schema(lua_table, feed_label_schema)
  if next(errstack) == nil then
    local items = box.space.feed:insert{
      lua_table['feed_id'],
      lua_table['label_id'],
    }
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
    print_table("ERROR STACK", errstack)
    resp.headers['X-Tarantool-Error'] = 'Validation';
    resp.status = 400
    return resp
  end
end

function put_feed_label(req)
  local feed_id = req:stash('feed_id')
  local label_id = req:stash('label_id')
  local uuid_feed_id = uuid.fromstr(feed_id)
  local uuid_label_id = uuid.fromstr(label_id)
  local label = box.space.feed_labels.index.primary:update({uuid_feed_id, uuid_label_id}, {
    {
      '=',
      lua_table['feed_id'],
      lua_table['label_id']
    }
  })
  return req:render{
    json = {
      ['data'] = {
        ['feed_id'] = label[1],
        ['label_id'] = label[2],
      }
    }
  }
end

function delete_feed_label(req)
  local feed_id = req:stash('feed_id')
  local uuid_feed_id = uuid.fromstr(feed_id)
  local label_id = req:stash('label_id')
  local uuid_feed_id = uuid.fromstr(feed_id)
  local fl = box.space.feed_labels.index.primary:delete({
    feed_id,
    label_id
  })
  return req:render{json = {['data'] = fl}}
end

box.cfg {listen = 3301}

box.schema.user.create('tarantool', {
  password = 'tarantool',
  if_not_exists = true
})

box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {
  if_not_exists = true
})

-- spaces and formats
local feed = box.schema.create_space("feed", {
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
  if_not_exists = true
})

labels:format({
  {name = 'id', type = 'uuid'},
  {name = 'title', type = 'string'},
  {name = 'description', type = 'string'},
  if_not_exists = true
})

local feed_labels = box.schema.create_space("feed_labels", {
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

feed_labels:create_index('ids', {
  type = 'TREE',
  parts = {'feed_id', 'label_id'},
  unique = true,
  if_not_exists = true
})

local server = require('http.server').new(nil, 8090, {charset = "utf8"})
server:route({path = '/', method = 'GET'}, default_handler)
server:route({path = '/keycloak/:sub/:roles', method = 'GET'}, keycloak_handler)
-- labels crud
server:route({path = '/keycloak/:sub/:roles/labels', method = 'GET'}, get_labels)
server:route({path = '/keycloak/:sub/:roles/labels/:id', method = 'GET'}, get_label)
server:route({path = '/keycloak/:sub/:roles/labels', method = 'POST'}, post_label)
--server:route({path = '/keycloak/:sub/:roles/labels/:id', method = 'PUT'}, put_label)
server:route({path = '/keycloak/:sub/:roles/labels', method = 'PUT'}, put_label)
server:route({path = '/keycloak/:sub/:roles/labels/:id', method = 'DELETE'}, delete_label)
-- feed crud
server:route({path = '/keycloak/:sub/:roles/feed', method = 'GET'}, get_feeds)
server:route({path = '/keycloak/:sub/:roles/feed/:id', method = 'GET'}, get_feed)
server:route({path = '/keycloak/:sub/:roles/feed', method = 'POST'}, post_feed)
server:route({path = '/keycloak/:sub/:roles/feed/:id', method = 'PUT'}, put_feed)
server:route({path = '/keycloak/:sub/:roles/feed/:id', method = 'DELETE'}, delete_feed)
-- feed label modifications
server:route({path = '/keycloak/:sub/:roles/fl', method = 'POST'}, post_feed_label)
server:route({path = '/keycloak/:sub/:roles/fl/:feed_id/:label_id', method = 'PUT'}, put_feed_label)
server:route({path = '/keycloak/:sub/:roles/fl/:feed_id/:label_id', method = 'DELETE'}, delete_feed_label)
-- server starting
server:start()
