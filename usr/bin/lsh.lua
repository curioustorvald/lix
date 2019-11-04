---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by torvald.
--- DateTime: 2019-11-03 02:02
---

require("etc/motd")
require("shellparser")

local args = {...}

local is_superuser = true -- single user mode!
local current_user = "root"

local prompt = is_superuser and "#" or "$"
local shell_currentDir = {}

local function printPrompt()
    io.write("root:"..env.PWD..prompt.." ")
end

local function recalc_PWD()
    return "/" .. table.concat(shell_currentDir, "/")
end

local internal_commands = {}
internal_commands.cd = function(args)
    local dirs = args[1]
    local sb = ""
    local c = 1

    if dirs == nil then return end

    -- does the cd dir begins with '/'?
    if dirs:byte(1) == 0x2F then
        shell_currentDir = {}
        c = 2
    end

    while c <= dirs:len() do
        local b = dirs:byte(c)

        if b == 0x2F or c == dirs:len() then
            if c == dirs:len() then sb = sb .. string.char(b) end

            if sb == "." or sb == "" then
                -- do nothing
            elseif sb == ".." then
                -- ignore "stack empty error"
                table.remove(shell_currentDir)
            else
                -- TODO: check if the dir is actually there
                table.insert(shell_currentDir, sb)
            end

            sb = ""
        else
            sb = sb .. string.char(b)
        end

        c = c + 1
    end

    env.PWD = recalc_PWD()
end

--- environmental varaibles
env = {}
env.PWD = "/" .. table.concat(shell_currentDir, "/")
--- end of environmental variables


--- example input: lsh path/to/script.lua args1 args2
------ t[1] = lsh'
------ t[2] = path/to/script.lua'
------ t[3] = args1'
------ t[4] = args2'            (' indicates string end)invoke = function(args)
_lix_invoke = function(args)
    local bin_name = args[1] -- call name with .lua extension attached
    local _t_args = {} -- call arguments
    for i = 2, #args do _t_args[i - 1] = args[i] end
    local call_args = unpack(_t_args)

    if (bin_name:lower():sub(-4) ~= ".lua") then bin_name = bin_name .. ".lua" end

    -- iterate thru LIX_PATH
    local internal_f = internal_commands[args[1]]
    local invoke_status
    local invoke_f
    if type(internal_f) == "function" then
        invoke_status, invoke_f = pcall(function() internal_f(_t_args) end)
    else
        for i = 1, #LIX_PATH do
            local p = LIX_PATH[i]
            invoke_status, invoke_f = pcall(function()
                local t = loadfile(p .. bin_name)
                if t then
                    t(call_args)
                else
                    error(bin_name..": command not found")
                end
            end)

            if invoke_status then break end
        end
    end

    -- print "no such file or whatever" message
    if not invoke_status then print("error: "..invoke_f) end
end
--- end of Application Stub

print(motd[1])

while true do
    printPrompt()
    local user_input = shell.parse(io.read())
    if user_input then
        --print("debug print;") for i, v in ipairs(user_input) do print(i, v) end
        _lix_invoke(user_input)
    end

end
