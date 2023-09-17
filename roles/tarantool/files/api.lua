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

-- sin api
function get_sins(req)
  a = {}
  sins = box.space.sins:select({}, {iterator='GT', limit = 100})
  for i, v in ipairs(sins) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      description = v['description']
    }
  end
  return req:render{json = {['data'] = a}}
end

function get_sin(req)
  local a = {}
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

function post_sin(req)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, sin_schema)
  if next(errstack) == nil then
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

function put_sin(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, sin_schema)
  if next(errstack) == nil then
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

function delete_sin(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local sin = box.space.sins.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = sin}}
end

-- proof api
function get_proofs(req)
  a = {}
  proofs = box.space.proofs:select({}, {iterator='GT', limit = 100})
  for i, v in ipairs(proofs) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      link = v['link'],
      account_id = v['account_id'],
      sin_id = v['sin_id']
    }
  end
  return req:render{json = {['data'] = a}}
end

function get_proof(req)
  local a = {}
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  proofs = box.space.proofs.index.primary:select{uuid_id}
  for i, v in ipairs(proofs) do
    a[i] = {
      id = v['id'],
      title = v['title'],
      link = v['link'],
      account_id = v['account_id'],
      sin_id = v['sin_id']
    }
  end
  return req:render{json = {['data'] = a}}
end

function post_proof(req)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, proof_schema)
  if next(errstack) == nil then
    local proof = box.space.proofs:insert{
      uuid.new(),
      lua_table['title'],
      lua_table['link'],
      lua_table['account_id'],
      lua_table['sin_id']
    }
    return req:render{
      json = {
        ['data'] = {
          ['id'] = proof[1],
          ['title'] = proof[2],
          ['link'] = proof[3],
          ['account_id'] = proof[4],
          ['sin_id'] = proof[5]
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

function put_proof(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local lua_table = req:json()
  local errstack = validate_schema(lua_table, proof_schema)
  if next(errstack) == nil then
    local proof = box.space.proofs.index.primary:update({uuid_id}, {
      {
        '=', 
        uuid_id,
        lua_table['title'],
        lua_table['link'],
        lua_table['account_id'],
        lua_table['sin_id']
      }
    })
    return req:render{
      json = {
        ['data'] = {
          ['id'] = proof[1],
          ['title'] = proof[2],
          ['link'] = proof[3],
          ['account_id'] = proof[4],
          ['sin_id'] = proof[5]
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

function delete_proof(req)
  local id = req:stash('id')
  local uuid_id = uuid.fromstr(id)
  local proof = box.space.proofs.index.primary:delete{uuid_id}
  return req:render{json = {['data'] = proof}}
end

