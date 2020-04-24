function ask(str, cb1, cb2)
  local a
  repeat
    io.write(str .. " [Y/n] ")
    io.flush()
    a = io.read()
  until a == "y" or a == "n"
  if a =="y" then
    if cb1 ~= nil then
      return cb1()
    end
  else
    if cb2 ~= nil then
      return cb2()
    end
  end
end
return ask