require('api')

box.cfg {listen = 3301}

box.schema.user.create('tarantool', {
  password = 'tarantool',
  if_not_exists = true
})
box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {
  if_not_exists = true
})

local proofs = box.schema.create_space("proofs", {
  if_not_exists = true
})
local sins = box.schema.create_space("sins", {
  if_not_exists = true
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
  {name = 'account_id', type = 'uuid'},
  {name = 'sin_id', type = 'uuid'},
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

local server = require('http.server').new(nil, 8090, {charset = "utf8"})
server:route({path = '/', method = 'GET'}, default_handler)
server:route({path = '/keycloak/:sub/:roles', method = 'GET'}, keycloak_handler)
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
-- server starting
server:start()
