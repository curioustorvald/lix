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
        ___  ;##;               ..
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


if _TERRARUM_VERSION then
    _G.WHOAMI = "TERRARUM" -- future proofing for my own game
elseif _CC_DEFAULT_SETTINGS then
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


_G.LIX_MSG_INSTALL_PACKAGE = function(packname)
    print("Required package not found, please install it by running:")
    print("    luarocks install "..packname)
    os.exit(1)
end

local path = "?.lua;usr/include/?.lua;"

--- continue to load necessary constants

if WHOAMI == "TERRARUM" then
    dofile("etc/filesystem_opencomputers.lua")
elseif WHOAMI == "CC" then
    error("ComputerCraft not supported, sorry :(")
elseif WHOAMI == "OC" then
    --- define paths for require(); we'll re-define everything for the VM's sake
    --- if this line does not work, it must be set by the Lua VM (LuaJ)
    package.path = package.path .. path

    dofile("etc/filesystem_opencomputers.lua")
    dofile("etc/tty_opencomputers.lua")
elseif WHOAMI == "WINDOWS" then
    --- define paths for require(); we'll re-define everything for the VM's sake
    --- if this line does not work, it must be set by the Lua VM (LuaJ)
    package.path = path

    dofile("etc/filesystem_windows.lua")
    print("Terminal function is not implemented in Windows.")
    print("Please run Lix using WSL.")
    os.exit(1)
elseif WHOAMI == "POSIX" then
    --- define paths for require(); we'll re-define everything for the VM's sake
    --- if this line does not work, it must be set by the Lua VM (LuaJ)
    package.path = path

    dofile("etc/filesystem_posix.lua")
    dofile("etc/plterm.lua")
else
    dofile("etc/filesystem_pure.lua")
end

--- launch system shell in single user mode
xpcall(function()

dofile("bin/sh.lua")

end, function(error)

tty.setsanemode()
print("")
print(error.."\n")

end)

tty.setsanemode()
print("k bye")
