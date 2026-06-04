#!/usr/bin/env lua
-- Converts hex fonts to psf1 fonts
-- checks for size, but still could
-- be errnonous. Whatever...

local glyphs = {}
local font_height = 16

for line in io.lines(arg[1]) do
   local code, hex = line:match("^(%x+)%s*:%s*(.+)$")
   if code then
      local bitmap = {}
      hex = hex:gsub("%s+", "")
      for i = 1, #hex, 2 do
         bitmap[#bitmap+1] = tonumber(hex:sub(i, i+1), 16) or 0
      end
      glyphs[tonumber(code, 16)] = bitmap
   end
end

local out = io.open(arg[2], "wb")
if not out then
   print("Cannot open " .. arg[2])
   os.exit(1)
end

out:write(string.char(0x36, 0x04, 0, font_height))

for i = 0, 255 do
   local g = glyphs[i]
   for j = 1, font_height do
      out:write(string.char(g and g[j] or 0))
   end
end

out:close()

local f = io.open(arg[2])
local size = f:seek("end")

f:close()

print(size == 4100 and "OK " .. size or "WRONG " .. size)
