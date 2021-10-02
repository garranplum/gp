-- MODULE UTILITY.LUA
-- by Garran Plum
--
-- General Lua utility functions for all GP mods.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("utility.lua", GP:version())

-- GP UTILITY FUNCTION Map
-- Maps each item in incomingTable to mapFunction, passing the remaining arguments.
-- HIGHER ORDER, RECURSIVE, FUNCTIONAL, UNKNOWN EFFECTS (1ST CLASS FUNCTION CALL)
function GP:map(incomingTable, mapFunction, ...)

    -- Collect multiple arguments.
    local arguments = {...}

    -- Get the next item from the table.
    local item = GP:next(incomingTable)

    -- If there's an item to process...
    if (item) then

        -- Apply the function to the item with all its arguments.
        mapFunction(item, unpack(arguments))

        -- Remove the item from the list.
        incomingTable[item] = nil

        -- Call this function recursively to process the rest of the list.
        GP:map(incomingTable, mapFunction, unpack(arguments))
    end
end

-- GP UTILITY FUNCTION Next
-- Returns the next item in a table or nil.
-- PURE FUNCTIONAL
function GP:next(incomingTable)
    local nextItem = nil
    if (incomingTable and next(incomingTable)) then
        nextItem = next(incomingTable)
    end
    return nextItem
end

-- GP UTILITY FUNCTION Copy Table
-- Deep copies a table by value and returns the new copy.
-- RECURSIVE, PURE FUNCTIONAL
function GP:copyTable(incomingTable)
    local newTable = {}
    for key, value in pairs(incomingTable) do
        if type(value) == "table" then
            value = GP:copyTable(value)
        end
        newTable[key] = value
    end
    return newTable
end

-- GP UTILITY FUNCTION Ternary
-- Returns ifTrue if test is true. Returns ifFalse if test is false.
-- PURE FUNCTIONAL
function GP:ternary(test, ifTrue, ifFalse)
    local returnValue
    if (test) then
        returnValue = ifTrue
    else
        returnValue = ifFalse
    end
    return returnValue
end

-- GP UTILITY FUNCTION Split
-- Splits string into an array (resultTable) on delimiter. Default `,`.
-- PURE FUNCTIONAL
function GP:split(delimitedString, delimiter)
    if (not delimiter) then
        delimiter = ","
    end
    local resultTable = {};
    for match in (delimitedString .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(resultTable, match);
    end
    return resultTable;
end

-- GP UTILITY FUNCTION Table Length
-- Returns the length of a table or array (incomingTable).
-- PURE FUNCTIONAL
function GP:tableLength(incomingTable)
    local count = 0
    for key, value in pairs(incomingTable) do
        count = count + 1
    end
    return count
end

-- GP UTILITY FUNCTION Array Keys
-- Returns a table with one key for each value in array. Key values are empty.
-- Turns array into table.
-- PURE FUNCTIONAL
function GP:getKeys(array)
    local keysObject = {}
    for index, key in pairs(array) do
        keysObject[key] = {}
    end
    return keysObject
end

-- GP UTILITY FUNCTION Table Keys
-- Returns a delimited string of all keys in a table. Default delimiter is `,`.
-- PURE FUNCTIONAL
function GP:tableKeys(incomingTable, delimiter)
    local keyListString = ""
    if (not delimiter) then
        delimiter = ", "
    end
    for key, value in pairs(incomingTable) do
        keyListString = key .. delimiter .. keyListString
    end
    return GP:trim(keyListString, string.len(delimiter))
end

-- GP UTILITY FUNCTION Serialize Table
-- Returns a string serialization of a table in Lua form.
-- TAIL RECURSIVE, PURE FUNCTIONAL
function GP:serializeTable(incomingTable, tableString, indent)

    -- Intent each level
    indent = indent or 1

    -- If first call (no tableString), make a copy of incomingTable first.
    if (not tableString) then
        return GP:serializeTable(GP:copyTable(incomingTable), "", indent)
    end

    -- Setup for indent
    local indentChar = "\t"
    local stringIndent = string.rep(indentChar, indent)
    local stringBackIndent = string.rep(indentChar, indent - 1)

    -- Setup for detecting array-style tables
    local isArray = true

    -- If there is an item in the table to work on...
    if (incomingTable and next(incomingTable)) then

        -- Get the next item's key and value from the table.
        local itemKey, itemValue = next(incomingTable)


        GP:log("serializing", itemKey)

        -- Create a string version of the key and value.
        local stringKey, stringValue = "", ""

        -- If the itemValue is a string, surround the stringValue with quotes.
        if GP:isString(itemValue) then
            stringValue = [["]] .. itemValue .. [["]]
        end
 
       -- If the itemValue is a number, write it without quotes.
        if GP:isNumber(itemValue) then
            stringValue = itemValue
        end

        -- If the itemValue is a boolean, stringify it without quotes.
        if GP:isBoolean(itemValue) then
            stringValue = tostring(itemValue)
        end

        -- If the itemKey is a string, add a return and indent before it and an = sign after it.
        if GP:isString(itemKey) then
            isArray = false
            stringKey = "\n" .. stringIndent .. itemKey .. " = "
        end

        -- If the itemKey is a number, don't write it (array style).
        if GP:isNumber(itemKey) then
            stringKey = ""
        end

        -- If the itemValue is a table, serialize it.
        if GP:isTable(itemValue) then
            stringValue, isArray = GP:serializeTable(itemValue, nil, indent + 1)
            indent = indent - 1
        end

        -- Format the string key and value in Lua form: [Category = "PLUM",]
        local itemString = stringKey .. stringValue .. [[, ]]

        -- Remove the item from the table.
        incomingTable[itemKey] = nil

        -- Call this function recursively, concatenating the new itemString to the tableString.
        return GP:serializeTable(incomingTable, tableString .. itemString, indent + 1)
    end

    -- No more work items? Prepare the final tableString.
    
    -- Remove the final ", " and return the completed table string wrapped in {}.
    local backReturn = ""
    if true then
        backReturn = "\n" .. stringBackIndent
    end
    return "{" .. GP:trim(tableString, 2) .. backReturn .. "}"
end

-- GP UTILITY FUNCTION Trim
-- Trims amount number of characters from end of incomingString. Default is 1.
-- PURE FUNCTIONAL
function GP:trim(incomingString, amount)
    if not amount then
        amount = 1
    end
    return string.sub(incomingString, 1, string.len(incomingString) - amount)
end

-- GP UTILITY FUNCTION isString
-- Returns true if passed a string.
-- PURE FUNCTIONAL
function GP:isString(object)
    return type(object) == "string"
end

-- GP UTILITY FUNCTION isNumber
-- Returns true if passed a number.
-- PURE FUNCTIONAL
function GP:isNumber(object)
    return tonumber(object) and true
end

-- GP UTILITY FUNCTION isBoolean
-- Returns true if passed a boolean.
-- PURE FUNCTIONAL
function GP:isBoolean(object)
    return type(object) == "boolean"
end

-- GP UTILITY FUNCTION isTable
-- Returns true if passed a table.
-- PURE FUNCTIONAL
function GP:isTable(object)
    return type(object) == "table"
end
