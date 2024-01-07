
-- local variables

local STRING_TYPE = "string"
local NUMBER_TYPE = "number"

-- schemas

AccountSchema = {
  properties = {
    username = {
      type = 'string',
      min = 6,
      max = 48
    },
    password = {
      type = 'string',
      min = 6,
      max = 48,
    }
  }
}

LabelSchema = {
  properties = {
    title = {
      type = 'string',
      min = 4,
      max = 48
    },
    description = {
      type = 'string',
      min = 4,
      max = 128,
    }
  }
}

FeedSchema = {
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

FeedLabelSchema = {
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

-- validation

function KeyExists(json_object, top_key)
  local res = false
  for key, _ in pairs(json_object) do
    if key == top_key then
      res = true
    end
  end
  return res
end

function ValidType(value, datatype)
  if type(value) == datatype then
    return true
  else
    return false
  end
end

function Number_valid_length(value, min, max)
  if value >= min and value <= max then
    return true
  else
    return false
  end
end

function StringValidLength(value, min, max)
  local length = string.len(value)
  if length >= min and length <= max then
    return true
  else
    return false
  end
end

function StringIntervalError(prop, string_length, min, max)
  -- simple format
  local error_string = string.format(
    "field: '%s', string length is not valid with length '%d' but required interval >= '%d' and <= '%s'",
    prop,
    string_length,
    min,
    max
  )
  return error_string
end

function NumberIntervalError(prop, json_object_prop, min, max)
  -- simple format
  local error_string = string.format(
    "field: '%s', number is not valid with value '%s' but required interval >= '%d' and <= '%s'",
    prop,
    json_object_prop,
    min,
    max
  )
  return error_string
end

function UndefinedType(supported_datatypes, founded_datatype)
  print("Undefined type is not implemented")
end

function DatatypeError(prop, type_json_object_prop, subprops_type)
  -- simple format
  local error_string = string.format(
    "field: '%s', not correct data type '%s', but required type is a '%s'",
    prop,
    type_json_object_prop,
    subprops_type
  )
  return error_string
end

function KeyNotFoundError(json_object_prop, prop)
  -- simple format
  local error_string = string.format("field: '%s', key not found but it is required: '%s'", json_object_prop, prop)
  return error_string
end

function KeyExtraError(json_object_key, json_object_value)
  -- simple format
  local error_string = string.format("field: '%s', extra key found: '%s'", json_object_value, json_object_key)
  return error_string
end

function InArray(array, x)
  for _, v in ipairs(array) do
    if v == x then
      return true
    end
  end
  return false
end

function ValidateSchema(json_object, schema)
  local errstack = {}
  for prop, subprops in pairs(schema.properties) do
    local key_found = KeyExists(json_object, prop)
    -- default validation stack
    if key_found then
      local is_valid_type = ValidType(json_object[prop], subprops.type)
      if is_valid_type then
        if subprops.type == STRING_TYPE then
          local is_valid_string = StringValidLength(json_object[prop], subprops.min, subprops.max)
          if is_valid_string then
          else
            local string_length = string.len(json_object[prop])
            table.insert(errstack, StringIntervalError(prop, string_length, subprops.min, subprops.max))
          end
        elseif subprops.type == NUMBER_TYPE then
          local is_valid_number = Number_valid_length(json_object[prop], subprops.min, subprops.max)
          if is_valid_number then
          else
            table.insert(errstack, NumberIntervalError(prop, json_object[prop], subprops.min, subprops.max))
          end
        else
          print("Undefined type")
        end
      else
        table.insert(errstack, DatatypeError(prop, type(json_object[prop]), subprops.type))
      end
    else
      table.insert(errstack, KeyNotFoundError(json_object[prop], prop))
    end
  end

  -- extra key detector
  for json_key, _ in pairs(json_object) do
    local schema_keys = {}
    for schema_key, _ in pairs(schema.properties) do
      table.insert(schema_keys, schema_key)
    end
    if InArray(schema_keys, json_key) == false then
      table.insert(errstack, KeyExtraError(json_key, json_object[json_key]))
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

function ValidationTest()
  -- correct data type
  print_table("CORRECT", ValidateSchema({username="alexmalder", password="012345qwe"}, AccountSchema))

  -- incorrect username
  print_table("INCORRECT USERNAME MIN", ValidateSchema({username="alex", password="12345567"}, AccountSchema))
  print_table("INCORRECT USERNAME MAX", ValidateSchema({username="alexmalderalexmalderalexmalder", password="123456"}, AccountSchema))

  -- incorrect password
  print_table("INCORRECT PASSWORD MIN", ValidateSchema({username="alexmalder", password="123"}, AccountSchema))
  print_table("INCORRECT PASSWORD MAX", ValidateSchema({username="alexmalder", password="dkfjvoernvslhvnre;ovnbkusfvblsierufeoa;rnjfjlfdv"}, AccountSchema))

  -- incorrect age
  print_table("INCORRECT AGE MIN", ValidateSchema({username="alexmalder", password="12345689"}, AccountSchema))
  print_table("INCORRECT AGE MAX", ValidateSchema({username="alexmalder", password="12345689"}, AccountSchema))

  -- key error
  print_table("KEY NOT FOUND", ValidateSchema({username="alexmalder"}, AccountSchema))
  print_table("EXTRA KEY FOUND", ValidateSchema({username="alexmalder", password="1234568qwe", new_password="oeruifsuirdfv"}, AccountSchema))
end
