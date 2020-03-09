---
--- Initial Process
--- The filename is standardised and bootloader will seek this exact file (/etc/init) so it must not be altered
---
--- Created by torvald.
--- DateTime: 2019-11-03 02:32
---

--- load some compatibility hacks
dofile("etc/lua5152compat.lua")


--- basic OS info
_G.LIX_VERSION = "0.1"
_G.LIX_LOGO =     [[
              ..
        ...  ;##;               ..
      ,m###m, ""    "##"       ;##;
    ,W####MM#W,      ##         ""
   ,W#####  ##W.     ##        "##  "##;, 'WM"
   ;######WW###;     ##         ##   ";##;W;'
   'M#########M'     ##         ##     ;##;
    'M#######M'      ##      ,  ##    ,M;##;.
      'M###M'       .########; ,##. ,WM. ';##;
        """
                     J u s t   f o r   F u n
]]

_G.LIX_PATH = { -- used by lsh
    "",
    "usr/bin/",
    "bin/"
}


if _CC_DEFAULT_SETTINGS then
    _G.WHOAMI = "CC" -- ComputerCraft
elseif _OSVERSION and _OSVERSION:sub(1,6) == "OpenOS" then
    _G.WHOAMI = "OC" -- OpenComputers
elseif package.config and package.config:sub(1,1) == "\\" then -- determine POSIX/Windows using path separator (hah!)
    _G.WHOAMI = "WINDOWS"
elseif package.config and package.config:sub(1,1) == "/" then
    _G.WHOAMI = "POSIX"
else
    _G.WHOAMI = "LUA" -- have no idea
end

--- define paths for require(); we'll re-define everything for the VM's sake
--- if this line does not work, it must be set by the Lua VM (LuaJ)
package.path = "?.lua;usr/include/?.lua;"

_G.LIX_MSG_INSTALL_PACKAGE = function(packname)
    print("Required package not found, please install it by running:")
    print("    luarocks install "..packname)
    os.exit(1)
end



--- continue to load necessary constants


if WHOAMI == "CC" then
    error("ComputerCraft not supported, sorry :(")
elseif WHOAMI == "OC" then
    dofile("etc/filesystem_opencomputers.lua")
elseif WHOAMI == "WINDOWS" then 
    dofile("etc/filesystem_windows.lua")
elseif WHOAMI == "POSIX" then
    dofile("etc/filesystem_posix.lua")
else
    dofile("etc/filesystem_pure.lua")
end


--- launch system shell in single user mode
dofile("bin/sh.lua")