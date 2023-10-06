local uuid = require('uuid')
local json = require('json')

local box=box

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

-- validation

local STRING_TYPE = "string"
local NUMBER_TYPE = "number"

local account_schema = {
  properties = {
    username = {
      type = 'string',
      min = 6,
      max = 22
    },
    password = {
      type = 'string',
      min = 6,
      max = 22,
    }
  }
}

local label_schema = {
  properties = {
    title = {
      type = 'string',
      min = 4,
      max = 14
    },
    description = {
      type = 'string',
      min = 4,
      max = 128,
    }
  }
}

local feed_schema = {
  properties = {
    title = {
      type = 'string',
      min = 4,
      max = 128,
    },
    link = {
      type = 'string',
      min = 4,
      max = 128,
    }
  }
}

local feed_label_schema = {
  properties = {
    feed_id = {
      type = 'string',
      min = 4,
      max = 128,
    },
    label_id = {
      type = 'string',
      min = 4,
      max = 128,
    }
  }
}

local function key_exists(json_object, top_key)
  local res = false
  for key, _ in pairs(json_object) do
    if key == top_key then
      res = true
    end
  end
  return res
end

local function valid_type(value, datatype)
  if type(value) == datatype then
    return true
  else
    return false
  end
end

local function number_valid_length(value, min, max)
  if value >= min and value <= max then
    return true
  else
    return false
  end
end

local function string_valid_length(value, min, max)
  local length = string.len(value)
  if length >= min and length <= max then
    return true
  else
    return false
  end
end

local function string_interval_error(prop, string_length, min, max)
  -- simple format
  local error_string = string.format("field: '%s', string length is not valid with length '%d' but required interval >= '%d' and <= '%s'", prop, string_length, min, max)
  return error_string
end

local function number_interval_error(prop, json_object_prop, min, max)
  -- simple format
  local error_string = string.format("field: '%s', number is not valid with value '%s' but required interval >= '%d' and <= '%s'", prop, json_object_prop, min, max)
  return error_string
end

local function undefined_type(supported_datatypes, founded_datatype)
  print("Undefined type is not implemented")
end

local function datatype_error(prop, type_json_object_prop, subprops_type)
  -- simple format
  local error_string = string.format("field: '%s', not correct data type '%s', but required type is a '%s'", prop, type_json_object_prop, subprops_type)
  return error_string
end

local function key_found_error(json_object_prop, prop)
  -- simple format
  local error_string = string.format("field: '%s', key not found but it is required: '%s'", json_object_prop, prop)
  return error_string
end

local function key_extra_error(json_object_key, json_object_value)
  -- simple format
  local error_string = string.format("field: '%s', extra key found: '%s'", json_object_value, json_object_key)
  return error_string
end

local function inArray(array, x)
  for _, v in ipairs(array) do
    if v == x then
      return true
    end
  end
  return false
end

local function validate_schema(json_object, schema)
  local errstack = {}
  for prop, subprops in pairs(schema.properties) do
    local key_found = key_exists(json_object, prop)
    -- default validation stack
    if key_found then
      local is_valid_type = valid_type(json_object[prop], subprops.type)
      if is_valid_type then
        if subprops.type == STRING_TYPE then
          local is_valid_string = string_valid_length(json_object[prop], subprops.min, subprops.max)
          if is_valid_string then
          else
            local string_length = string.len(json_object[prop])
            table.insert(errstack, string_interval_error(prop, string_length, subprops.min, subprops.max))
          end
        elseif subprops.type == NUMBER_TYPE then
          local is_valid_number = number_valid_length(json_object[prop], subprops.min, subprops.max)
          if is_valid_number then
          else
            table.insert(errstack, number_interval_error(prop, json_object[prop], subprops.min, subprops.max))
          end
        else
          print("Undefined type")
        end
      else
        table.insert(errstack, datatype_error(prop, type(json_object[prop]), subprops.type))
      end
    else
      table.insert(errstack, key_found_error(json_object[prop], prop))
    end
  end

  -- extra key detector
  for json_key, _ in pairs(json_object) do
    local schema_keys = {}
    for schema_key, _ in pairs(schema.properties) do
      table.insert(schema_keys, schema_key)
    end
    if inArray(schema_keys, json_key) == false then
      table.insert(errstack, key_extra_error(json_key, json_object[json_key]))
    end
  end

  return errstack
end

local function print_table(target, t)
  print(target)
  for k,v in pairs(t) do
    print(k, v)
  end
  print('\n')
end

local function validation_test()
  -- correct data type
  print_table("CORRECT", validate_schema({username="alexmalder", password="012345qwe"}, account_schema))

  -- incorrect username
  print_table("INCORRECT USERNAME MIN", validate_schema({username="alex", password="12345567"}, account_schema))
  print_table("INCORRECT USERNAME MAX", validate_schema({username="alexmalderalexmalderalexmalder", password="123456"}, account_schema))

  -- incorrect password
  print_table("INCORRECT PASSWORD MIN", validate_schema({username="alexmalder", password="123"}, account_schema))
  print_table("INCORRECT PASSWORD MAX", validate_schema({username="alexmalder", password="dkfjvoernvslhvnre;ovnbkusfvblsierufeoa;rnjfjlfdv"}, account_schema))

  -- incorrect age
  print_table("INCORRECT AGE MIN", validate_schema({username="alexmalder", password="12345689"}, account_schema))
  print_table("INCORRECT AGE MAX", validate_schema({username="alexmalder", password="12345689"}, account_schema))

  -- key error
  print_table("KEY NOT FOUND", validate_schema({username="alexmalder"}, account_schema))
  print_table("EXTRA KEY FOUND", validate_schema({username="alexmalder", password="1234568qwe", new_password="oeruifsuirdfv"}, account_schema))
end


-- api
local function default_handler(req)
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

local function check_login(req)
  local lua_table = req:json()
  print("HEADERS of the check_login:", req.headers)
  return req:render{
    json = {
      ['data'] = {
        ['login'] = lua_table['login'],
        ['password'] = lua_table['password'],
      }
    }
  }
end

local function post_label(req)
  local lua_table = req:json()
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

local function put_label(req)
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

local function delete_label(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local label = box.space.labels.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = label}}
end

-- feed api
local function get_feeds(req)
  local a = {}
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

local function get_feed(req)
  local a = {}
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local items = box.space.feed.index.primary:select{uuid_id}
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

local function post_feed(req)
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

local function put_feed(req)
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

local function delete_feed(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local items = box.space.feed.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = items}}
end

-- fl api
local function post_feed_label(req)
  local lua_table = req:json()
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

local function put_feed_label(req)
  local lua_table = req:json()
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
  server:route({path = '/', method = 'POST'}, check_login)
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
end

undefined_type(nil, nil)
validation_test()
listen_http_api()
