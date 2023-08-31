box.cfg {
    listen = 3301
}

box.schema.user.create('tarantool', {password = 'tarantool', if_not_exists = true})
box.schema.user.grant('tarantool', 'read,write,execute', 'universe', nil, {if_not_exists=true})

accounts = box.schema.create_space('accounts', { if_not_exists = true })
accounts:format({
    {
        name = 'id',
        type = 'string',
    },
    {
        name = 'username',
        type = 'string'
    },
    {
        name = 'password',
        type = 'string'
    },
    {
        name = 'is_active',
        type = 'boolean'
    }
})

sins = box.schema.create_space("sins", { if_not_exists = true })
sins:format({
    {
        name = 'id',
        type = 'string',
    },
    {
        name = 'title',
        type = 'string'
    },
    {
        name = 'description',
        type = 'string'
    },
    if_not_exists=true
})

proofs = box.schema.create_space("proofs", { if_not_exists = true })
proofs:format({
    {
        name = 'id',
        type = 'string'
    },
    {
        name = 'title',
        type = 'string'
    },
    {
        name = 'link',
        type = 'string'
    },
    {
        name = 'account_id',
        type = 'string'
    },
    {
        name = 'sin_id',
        type = 'string'
    },
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
