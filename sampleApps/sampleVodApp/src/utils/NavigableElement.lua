--[[ 
    NavigableElement class

    This class handles and maintains element focus within a view,
    the setup requires you to register callbacks and manually bind the element locations relative to eachother 

    Only the most basic layout hints has to be setup as demonstrated in the diagram below
    Additional paths will automatically be generated when the user moves around
    Note basic layout is equivalent to the default path the user traverses the view 
     
    So in this example it means pressing right ends up on the "play button" 
    But if the user navigates down to the previous button, then press left followed by right
    He will end up on the previous button again 
     
                     ->  <2 play>
                    /       \/
      <1 synposis> <-<-- <3 next>
                     \      \/
                       - <4 previous>

    Supported per instance callbacks are 

        onFocus = When the element gains focus 
        onLostFocus = When the element loses focus
        keyHandler = When the element is focused and the user presses a key

    Supported per instance navigation aspects are 

        SetUp = Defines the element above
        SetDown = Defines the element below
        SetLeft = Defines the element to the left
        SetRight = Defines the element to the right

    Class methods 
        Create = Defines and creates a NavigableElement for the supplied element 
        SetDefaultElement = Sets the default focus for the view
        ProcessKey = Handles key input and invokes the focused elements keyhandler and performs navigational logic
]]--

NavigableElement = {}
NavigableElement.__index = NavigableElement
NavigableElement._currentElement = nil
NavigableElement._defaultElement = nil

-- Sets the default element if you need to reset focus to a known state
NavigableElement.SetDefaultElement = function (el) 
    NavigableElement._defaultElement = el
    NavigableElement._currentElement = el   
    if el._onFocus ~= nil then
        el._onFocus(el)
    end
end

-- Focus a NavigableElement
NavigableElement.Focus = function (el) 
    if el._onFocus ~= nil then
        el._onFocus(el)
    end
    if NavigableElement._currentElement ~= nil and 
       NavigableElement._currentElement._onLostFocus ~= nil then
        NavigableElement._currentElement._onLostFocus(NavigableElement._currentElement)
    end

    NavigableElement._currentElement = el
end

-- Returns true if the navigation stack intercepted the event 
-- If false the event is unhandled and can freely be handled by some global means
NavigableElement.ProcessKey = function (code) 
    local res = false
    local curr = NavigableElement._currentElement

    if curr._keyHandler ~= nil then
        res = curr._keyHandler(code)
    end

    if res ~= true then
        -- Navigate to the target element and write the navigation tags 
        if code == "left" then
            if curr._left ~= nil then
                curr._left._right = curr; 
                return NavigableElement.Focus(curr._left)
            end
        elseif code == "right" then
            if curr._right ~= nil then
                curr._right._left = curr;
                return NavigableElement.Focus(curr._right)
            end
        elseif code == "up" then
            if curr._up ~= nil then
                curr._up._down = curr;
                return NavigableElement.Focus(curr._up)
            end
        elseif code == "down" then
            if curr._down ~= nil then
                curr._down._up = curr;
                return NavigableElement.Focus(curr._down)
            end
        end
    end
    return false;
end

NavigableElement.Create = function (element) 
    local nel = {}
    setmetatable(nel, NavigableElement)
    nel._element = element
    nel._right = nil -- NavigableElement to the right
    nel._left = nil -- NavigableElement to the left
    nel._up = nil -- NavigableElement above
    nel._down = nil -- NavigableElement below
    nel._onFocus = nil -- Called when the element gains focus
    nel._onLostFocus = nil -- Called when the element loses focus
    nel._keyHandler = nil -- Called when the element recieves keyinput
    return nel
end

-- Setters for various properties

NavigableElement.SetLeft = function (self, navigableElement)
    self._left = navigableElement
end

NavigableElement.SetRight = function (self, navigableElement)
    self._right = navigableElement
end

NavigableElement.SetUp = function (self, navigableElement)
    self._up = navigableElement
end

NavigableElement.SetDown = function (self, navigableElement)
    self._down = navigableElement
end

NavigableElement.SetOnFocus = function (self, callback)
    self._onFocus = callback
end

NavigableElement.SetOnLostFocus = function (self, callback)
    self._onLostFocus = callback
end

-- Return true if you handled the key in the callback
-- If you return false the event will be evaluated for navigation purposes
-- This allows you to intercept directional events and you can optional blocking them by returning true 
NavigableElement.SetKeyHandler = function (self, callback)
    self._keyHandler = callback
end