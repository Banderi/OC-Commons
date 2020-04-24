local component = require("component")
function d(o)
  if o == nil or o == "all" then
    o = component.list()
    -- print("Doing as: list")
  elseif type(o) == "string" then
    found = false
    for k,v in pairs(component.list()) do
      if v == o then
        o = k
        found = true
        -- print("Doing as: component name")
        break
      end
    end
    -- print("Doing as: component address")
    g = component.get(o)
    if g == nil then
      error("Unable to find component from address \"" .. o .. "\"")
    else
      o = component.proxy(g)
    end
  end
  for k,v in pairs(o) do
    print(k,v)
  end
end
-- for i=0,10 do
    -- print(debug.getinfo(i), debug.getinfo(i) ~= nil)
-- end

if debug.getinfo(7) == nil then -- when ran from bash directly
  a = {...}
  if #a == 0 then
    d()
  elseif a[1] == "cdump" then -- because Lua is stupid
    if #a > 1 then
      d(a[2])
    else
      d()
    end
  else
    d(a[1])
  end
else
  return d
end