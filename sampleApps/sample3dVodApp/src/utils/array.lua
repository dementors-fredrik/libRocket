-- Array helper
-- Simple class that wraps a table and creates a stack with a wrappable peek index

Array = {}
Array.__index = Array

Array.Create = function (table)
    local arr = {}
    arr.localTable = {}
    arr.localIndex = 1
    setmetatable(arr, Array)

    for k,v in pairs(table) do
        arr.Push(arr, v)
    end
    return arr;
end

Array.Push = function (self, item)
    table.insert(self.localTable, item)
    self:ClampIndex()
end

Array.Pop = function (self)
    table.remove(self.localTable)
    self:ClampIndex()
end

Array.SetIndex = function (self, idx)
    if #self.localTable <= idx and idx >= 0 then
        self.localIndex = idx
    end
end

Array.ClampIndex = function (self)
    if self.localIndex < 1 then
        self.localIndex = #self.localTable
    elseif self.localIndex > #self.localTable then
        self.localIndex = 1
    end
end

Array.DOWN = 1
Array.UP = -1
Array.LEFT = -1
Array.RIGHT = 1

Array.MoveIndex = function (self, direction)
    self.localIndex = self.localIndex + direction
    self:ClampIndex()
    return self:GetActiveEntry()
end

Array.GetIndex = function (self)
    return self.localIndex
end

Array.GetActiveEntry = function (self)
    return self.localTable[self.localIndex]
end

Array.Length = function (self)
    return #self.localTable
end
