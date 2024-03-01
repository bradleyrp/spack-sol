-- Custom Sol SitePackage.lua
-- reading:
--   https://lmod.readthedocs.io/en/latest/170_hooks.html#hooks
--   https://lmod.readthedocs.io/en/latest/200_avail_custom.html

require("strict")
local hook = require("Hook")
local Dbg   = require("Dbg")
local dbg   = Dbg:dbg()

-- better titles
local mapT =
{
   en_grouped = {
      -- beware use "%" to escape "-"
      ['/Core$']   = "core",
      ['/gcc/12.3.0$'] = "gcc (12.3)",
      ['/z/gcc%-12.3.0/openmpi/4.1.6$'] = "gcc (12.3) + openmpi (4.1)",
      ['/oneapi%-2023.2.0/intel%-oneapi%-mpi/2021.10.0$'] = "Intel (2023) + Intel MPI (2021)",
      ['/oneapi/2023.2.0$'] = "Intel (2023)",
      ['toolchain$'] = "toolchain",
      ['ext$'] = "external",
   },
}

function avail_hook(t)
   dbg.print{"avail hook called\n"}
   local availStyle = masterTbl().availStyle
   local styleT     = mapT[availStyle]
   if (not availStyle or availStyle == "system" or styleT == nil) then
      dbg.print{"no custom titles\n"}
      return
   end

   for k,v in pairs(t) do
      for pat,label in pairs(styleT) do
         if (k:find(pat)) then
            t[k] = label
            break
         end
      end
   end
end

hook.register("avail",avail_hook)

function myMsgHook(kind,a)
   if (kind == "avail") then
      -- example via https://lmod.readthedocs.io/en/latest/170_hooks.html
      table.insert(a,1,"\n*** Sol Software ***\n")
      table.insert(a,2,"Use \"module spider <name>\" to search all software.\n")
      table.insert(a,3,"The available software depends on the compiler, MPI,\n")
      table.insert(a,4,"https://lmod.readthedocs.io/en/latest/010_user.html\n")
   end
   return a
end

hook.register("msgHook", myMsgHook)
