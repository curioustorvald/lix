---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Torvald.
--- DateTime: 2020-03-09 05:58
---

if not _G.doc then _G.doc = {} end

doc.tabulate = function(list)
    local longest = 0
    for _, v in pairs(list) do
        l = #v
        if l > longest then
            longest = l
        end
    end
    -- TODO print in pretty way
    -- this placeholder will just print them naively
    for _, v in pairs(list) do
    	print(v)
    end
end
    