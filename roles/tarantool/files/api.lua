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
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, label_schema)
  if next(errstack) == nil then
    local label = box.space.labels:insert{
      uuid.new(), lua_table['title'], lua_table['description']
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

-- delete label by id
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
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, feed_schema)
  if next(errstack) == nil then
    local items = box.space.feed:insert{
      uuid.new(),
      lua_table['title'],
      lua_table['link'],
      lua_table['account_id'],
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

-- delete feed by id
function delete_feed(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local items = box.space.feed.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = items}}
end
