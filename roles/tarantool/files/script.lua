local smtp = require("socket.smtp")

local function write_log(reason, msg)
  local mesgt = {
    headers = {
      to = "vnmntn@mail.ru",
      --cc = '',
      subject = reason
    },
    body = msg
  }
  local r, e = smtp.send{
    from = "vnmntn@mail.ru",
    rcpt = {"vnmntn@mail.ru"},
    user = "vnmntn@mail.ru",
    password = "XPFrgKvZwDPCk4TyLsc6",
    host = "smtp.mail.ru",
    port = 465,
    headers = {
      subject = "[%level] logging.email test",
    },
    source = smtp.message(mesgt)
  }
end

write_log("Test", "test")
