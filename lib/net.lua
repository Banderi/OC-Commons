local component = require("component")
local event = require("event")
local ser = require("serialization")
mod = component.modem
N = {}
function open(p)
  if _G.netlistener ~= nil then
    print("Already listening!")
    os.exit()
  end
  print("Opening...")
  mod.open(p)
  _G.netport = p
  _G.netlistener = event.listen("modem_message",hnd)
  if _G.netname == nil then
    _G.netname = mod.address
  end
  print("Listening on port " .. p)
end
function close()
  mod.close(_G.netport)
  event.cancel(_G.netlistener)
  _G.netlistener = nil
  _G.netport = nil
  print("Connection closed.")
end
function hnd(h,a_s,a_l,p,dist,name,body)
  body = ser.unserialize(body)
  line = os.date("%X") .. " <" .. name .. "> - " .. body
  print(line)
  io.open("/home/netlog", "a"):write(line)
  -- if type(body) == "string" then
    -- print("Message from <" .. s.name .. ">: " .. body)
  -- else
    -- print(body)
  -- end
end
function send(a,body)
  name = _G.netname
  if a == "all" then
    mod.broadcast(_G.netport,name,ser.serialize(body))
  else
    mod.send(a,_G.netport,name,ser.serialize(body))
  end
  line = os.date("%X") .. " <" .. _G.netname .. "> [ME] - " .. body
  print(line)
  io.open("/home/netlog", "a"):write(line)
end
function setname(n)
  _G.netname = n
  print("Client name set to <" .. n .. ">")
end



N.open = open
N.close = close
N.hnd = hnd
N.send = send

if debug.getinfo(7) == nil then -- when ran from bash directly
  a = {...}
  if #a == 0 then
    if _G.netlistener ~= nil then
      print(">>> Open connection on port: " .. _G.netport)
      print(">>> Name: <" .. _G.netname .. ">")
    end
    print("Usage: net <flag>")
    print("  -o       open connection (port 111)")
    print("  -p <xxx> open on custom port")
    print("  -c       close connection")
    print("  -m <msg> broadcast message")
    print("  -n <nam> set name")
  elseif a[1] == "cdump" then -- because Lua is stupid
    return
  elseif a[1] == "-o" then
    open(111)
  elseif a[1] == "-p" then
    open(a[2])
  elseif a[1] == "-c" then
    close()
  elseif a[1] == "-m" then
    send("all",a[2])
  elseif a[1] == "-n" then
    setname(a[2])
  end
else
  return N
end