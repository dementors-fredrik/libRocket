--[[
    Utils class

    To unify stb and pc development
--]]

Utils = {}
Utils.__index = Utils

-- KeyTranslation table from librocket definition to zenterio values
Utils.keyTranslation = {
    ["0"]="back",
    ["2"]="0",
    ["3"]="1",
    ["4"]="2",
    ["5"]="3",
    ["6"]="4",
    ["7"]="5",
    ["8"]="6",
    ["9"]="7",
    ["10"]="8",
    ["11"]="9",
    ["72"]="ok",
    ["90"]="left",
    ["91"]="up",
    ["92"]="right",
    ["93"]="down"
}

Utils.Create = function (document)
    local i = {}
    setmetatable(i, Utils)
    i.document = document
    i.title = document.title
    return i;
end

Utils.SplitString = function (string, delimiter, strip)
    local res = {}
    if string then
        local entry = 0
        local index = 0
        local prev = 0
        local strlen = string:len()
        while index ~= nil do
            index = string:find(delimiter, prev)
            if index ~= nil then
                res[entry] = string:sub(prev, index-1)
                if strip then
                    res[entry] = res[entry]:gsub(" " , "")
                end

                entry = entry + 1
                prev = index + 1
            end
        end
        if prev <= strlen then
            res[entry] = string:sub(prev, strlen)
            if strip then
                res[entry] = res[entry]:gsub(" " , "")
            end
            entry = entry + 1
        end
    end
    return res
end


-- Traverse the known element compliant class for a child with the
-- requested id.
Utils.TraverseElementForId = function (self, element, id)
    if element.id == id then
        return element
    elseif element.child_nodes then
        local res = nil
        for nr, el in pairs(element.child_nodes) do
            res = self:TraverseElementForId(el, id)
            if res ~= nil then
                break
            end
        end
        return res
    end
end

Utils.ResolveElement = function (self, id)
    local res = self.document:GetElementById(id)

    if res == nil then
        print("Current document is " .. self.title)
        print("GetElementById failed, using workaround for id [" .. id .. "]")
        print("Are you certain you access the member as expected? eg. <object>:<method> instead of <object.method>?")

        -- By accessing the context root_element pointer we gain access to
        -- all documents loaded by the context (although we're generally just interested
        -- in the last loaded this approach makes sure we don't misany)
        res = self:TraverseElementForId(self.document.context.root_element, id)
    end

    return res
end

-- Zenterio keyhandling (currently not possible to bind to a specific context)
-- So only the last registered page wrapper will recieve key events
onKey = function (keyCode, keyState)
    if Utils.keyHandler ~= nil then
        Utils.keyHandler(keyCode, keyState)
    else
        print("No registered key handler")
    end
end

-- librocket keyhandling
Utils._InternalKeyHandler = function (self, evt)
    print("libRocket keyhandler for [" .. self.title .. "] ")

    local type = "down"
    if evt then 
        if evt.type == "keyup" then
            type = "up"
        end
    end

    local key = evt.parameters["key_identifier"] .. ""
    local translatedKey = Utils.keyTranslation[key]

    if translatedKey ~= nil then
        self.keyHandler(translatedKey, type)
    else
        print("Unmapped key code " .. key)
    end
end

Utils.ActivateKeyHandler = function (self)
    Utils.keyHandler = self.keyHandler
    print("Keyhandler activated for [" .. self.title .."]")
end

-- Unify keyhandling
Utils.SetKeyHandler = function (self, handler)
    if self.keyHandler == nil then

        local documentName = self.title

        self.keyHandler = function (key, state) print("Sending input " .. key .. "/" .. state .. " to [" .. documentName .. "]") handler(key, state) end

        -- Notice RocketLua can't remove eventlisteners
        self:ResolveElement("base"):AddEventListener("keydown", function (evt) self:_InternalKeyHandler(evt) end , true)
        self:ResolveElement("base"):AddEventListener("keyup", function (evt) self:_InternalKeyHandler(evt) end , true)

        -- Zenterio key handling can only send to the last registered key handler because it's not context bound
        -- while the librocket keyhandling is bound to the recieving document.
        -- Therefore it's recommended to call <utils>:ActivateKeyHandler() for the registered document handler
        Utils.keyHandler = handler

        print("Installed keyhandler on [" .. documentName .. "]")
    else
        print("Warning attempting to register multiple keyhandlers on the same document")
        self:ActivateKeyHandler()
    end
end

print("Utils loaded and running on Lua version: " .. _VERSION)
