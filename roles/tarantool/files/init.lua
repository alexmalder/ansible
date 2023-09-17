require('api')

box.cfg {listen = 3301}

box.schema.user.create('tarantool', {
  password = 'tarantool',
  if_not_exists = true
})
box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {
  if_not_exists = true
})

local feed = box.schema.create_space("feed", {
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

feed:format({
  {name = 'id', type = 'uuid'},
  {name = 'title', type = 'string'},
  {name = 'link', type = 'string'},
  {name = 'account_id', type = 'uuid'},
  {name = 'label_id', type = 'uuid'},
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

feed:create_index('label_id', {
  type = 'TREE',
  parts = {'label_id'},
  unique = false,
  if_not_exists = true
})

local server = require('http.server').new(nil, 8090, {charset = "utf8"})
server:route({path = '/', method = 'GET'}, default_handler)
server:route({path = '/keycloak/:sub/:roles', method = 'GET'}, keycloak_handler)
-- labels crud
server:route({path = '/labels', method = 'GET'}, get_labels)
server:route({path = '/labels/:id', method = 'GET'}, get_label)
server:route({path = '/labels', method = 'POST'}, post_label)
server:route({path = '/labels/:id', method = 'PUT'}, put_label)
server:route({path = '/labels/:id', method = 'DELETE'}, delete_label)
-- feed crud
server:route({path = '/feed', method = 'GET'}, get_feeds)
server:route({path = '/feed/:id', method = 'GET'}, get_feed)
server:route({path = '/feed', method = 'POST'}, post_feed)
server:route({path = '/feed/:id', method = 'PUT'}, put_feed)
server:route({path = '/feed/:id', method = 'DELETE'}, delete_feed)
-- server starting
server:start()
