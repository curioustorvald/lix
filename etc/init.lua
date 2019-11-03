---
--- Initial Process
--- The filename is standardised and bootloader will seek this exact file (/etc/init) so it must not be altered
---
--- Created by torvald.
--- DateTime: 2019-11-03 02:32
---

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

--- define paths for require(); we'll re-define everything for the VM's sake
--- if this line does not work, it must be set by the Lua VM (LuaJ)
package.path = "?.lua;usr/include/?.lua;"

--- launch system shell in single user mode
dofile("bin/sh.lua")