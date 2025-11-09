--====================================================
-- OilLua Compiler v0.1
-- Author: CoolyDucks
-- Description: Extended Lua syntax with TAG, COLOR, CLASS, and Z features
--====================================================

local currentClass = nil

--============================
-- Compiler
--============================
local function compile_oillua(source)
    local out = {}
    table.insert(out, "-- Compiled from OilLua v0.1 by CoolyDucks")
    table.insert(out, "TAGS = TAGS or {}")
    table.insert(out, "Z = Z or {}")

    for line in source:gmatch("[^\r\n]+") do
        local original = line
        line = line:gsub("^%s+", ""):gsub("%s+$", "")

        -- TAG definition
        local tagName = line:match("^TAG=(%w+)")
        if tagName then
            table.insert(out, string.format('TAGS["%s"] = {}', tagName))
            goto continue
        end

        -- COLOR definition
        local varName, r, g, b = line:match("^(%w+)%s*=%s*<COLOR#([%d%.]+)%.([%d%.]+)%.([%d%.]+)>")
        if varName then
            table.insert(out, string.format('%s = {r=%s, g=%s, b=%s}', varName, r, g, b))
            goto continue
        end

        -- CLASS definition: class Name {
        local className = line:match("^class%s+(%w+)%s*{")
        if className then
            table.insert(out, string.format("%s = {} %s.__index = %s", className, className, className))
            table.insert(out, string.format("function %s:new(o) o = o or {} setmetatable(o, %s) return o end", className, className))
            currentClass = className
            goto continue
        end

        -- CLASS method
        local methodName = line:match("^function%s+(%w+)%s*%(")
        if currentClass and methodName then
            local args = line:match("^function%s+%w+%((.*)%)") or ""
            table.insert(out, string.format("function %s:%s(%s)", currentClass, methodName, args))
            goto continue
        end

        -- end of class
        if line == "}" then
            currentClass = nil
            goto continue
        end

        -- comments / empty lines / separators
        if line:match("^%-%-") or line:match("^%s*$") or line:match("^%-+$") then
            table.insert(out, line)
            goto continue
        end

        -- normal Lua code
        table.insert(out, original)
        ::continue::
    end

    return table.concat(out, "\n")
end

--============================
-- Runtime Library
--============================
local function oilua_runtime()
    local rt = {}

    -- z library
    rt.z = {}
    function rt.z.compress(str)
        return string.gsub(str, "%s+", "")
    end
    function rt.z.decompress(str)
        return str
    end

    return rt
end

-- initialize runtime
local runtime = oilua_runtime()
z = runtime.z

--============================
-- Compiler Execution
--============================
local inputFile = arg[1]
if not inputFile then
    print("Usage: lua oillua.lua <file.oil>")
    os.exit()
end

local file = io.open(inputFile, "r")
if not file then
    error("Cannot open file: " .. inputFile)
end

local source = file:read("*a")
file:close()

local luaCode = compile_oillua(source)

local tempOut = os.tmpname() .. ".lua"
local outFile = io.open(tempOut, "w")
outFile:write(luaCode)
outFile:close()

print("[OilLua v0.1] Compiling " .. inputFile .. " ...")
print("[OilLua] Running generated Lua code...\n")

dofile(tempOut)
os.remove(tempOut)
