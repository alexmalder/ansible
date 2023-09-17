--
local STRING_TYPE = "string"
local NUMBER_TYPE = "number"

account_schema = {
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

label_schema = {
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

feed_schema = {
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

feed_labels_schema = {
  properties = {
    feed_id = {
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
  local error_string = string.format("field: '%s', string length is not valid with length '%d' but required interval >= '%d' and <= '%s'", prop, string_length, min, max)
  return error_string
end

local function number_interval_error(prop, json_object_prop, min, max)
  local error_string = string.format("field: '%s', number is not valid with value '%s' but required interval >= '%d' and <= '%s'", prop, json_object_prop, min, max)
  return error_string
end

local function undefined_type(supported_datatypes, founded_datatype)
end

local function datatype_error(prop, type_json_object_prop, subprops_type)
  local error_string = string.format("field: '%s', not correct data type '%s', but required type is a '%s'", prop, type_json_object_prop, subprops_type)
  return error_string
end

local function key_found_error(json_object_prop, prop)
  local error_string = string.format("field: '%s', key not found but it is required: '%s'", json_object_prop, prop)
  return error_string
end

local function key_extra_error(json_object_key, json_object_value)
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

function validate_schema(json_object, schema)
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

function print_table(target, t)
  print(target)
  for k,v in pairs(t) do
    print(v)
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

--validation_test()
