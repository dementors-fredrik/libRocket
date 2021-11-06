imgs = { "img/jwcover.png", "img/swcover.png", "img/mazecover.png" }
-- "width: 350px; height: 525px; top: 127px; left: 67px; 

local coords = {
    ["0"] = { ["xstart"] = 500, ["xstop"] = 900,  -- Mid -> Right
              ["ystart"] = 150, ["ystop"] = 100,
              ["hstart"] = 525, ["hstop"] = 262,
              ["wstart"] = 350, ["wstop"] = 175},

    ["1"] = { ["xstart"] = 900, ["xstop"] = 250, -- Right -> Left
              ["ystart"] = 100, ["ystop"] = 100,
              ["hstart"] = 262, ["hstop"] = 262,
              ["wstart"] = 175, ["wstop"] = 175},

    ["2"] = { ["xstart"] = 250, ["xstop"] = 500, -- Left -> Mid
              ["ystart"] = 100, ["ystop"] = 150,
              ["hstart"] = 262, ["hstop"] = 525,
              ["wstart"] = 175, ["wstop"] = 350}
}

SetupNavigation = function (thisPage) 
    local fpsbutton = NavigableElement.Create(thisPage:ResolveElement("fpsbutton"))

    fpsbutton:SetOnFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(255, 20, 150)"
    end)

    fpsbutton:SetOnLostFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(150, 150, 150)"
    end)

    fpsbutton:SetKeyHandler( function (key)
     
    end)

    NavigableElement.SetDefaultElement(fpsbutton) -- Place the user on the synposis field
end

local ang = 0.0

RotateStack = function () 
  for i=1, #imgs do
    ang = ang + 0.01
        local currentCover = thisPage:ResolveElement("cover" .. i)

        local oriz = tonumber(currentCover.style["z-index"])
        local newz = (oriz + 1) % #imgs
        local coverAnimation = Animation.Create(currentCover)
        local transistionCoords = coords[tostring(math.floor(newz))]
  
        coverAnimation:smoothstep("left"):from(transistionCoords.xstart):to(transistionCoords.xstop):overSeconds(0.9):withGenerator(function (coord) return 500 + (math.sin(ang + (coord/200))*300) .. "px" end):compile()
        coverAnimation:smoothstep("top"):from(transistionCoords.xstart):to(transistionCoords.xstop):overSeconds(0.9):withGenerator(function (coord) return 150 + (math.sin(ang + (coord/200))*50) .. "px" end):compile()

        coverAnimation:bounce("width"):from(transistionCoords.wstart):to(transistionCoords.wstop):overSeconds(0.9):pxattribute():compile()
        coverAnimation:bounce("height"):from(transistionCoords.hstart):to(transistionCoords.hstop):overSeconds(0.9):pxattribute():compile()

        coverAnimation:lerp("z-index"):from(oriz):to(newz):overSeconds(0.9):withGenerator(function (x) return tostring(math.floor(x))   end):compile()
        Animator.submit(coverAnimation)
    end
    local currentCover = thisPage:ResolveElement("cover" .. 3)
    local coverAnimation = Animation.Create(currentCover)

    coverAnimation:lerp("nada"):from(0):to(0):overSeconds(1.0):withGenerator(function () return 0 end):withCompletion(function ()  RotateStack() end):compile();
    Animator.submit(coverAnimation);

    Animator.start()

end
PageLoadedCallback = function (document)
    local matrix = Matrix.Create()
    
    -- Instance the document wrapper for the given document
    thisPage = Utils.Create(document)

    for i=1, #imgs do
        local currentCover = thisPage:ResolveElement("cover" .. i)
        currentCover:SetAttribute("src", imgs[i])
    end
    -- Setup page navigation using the NavigableElement stack
    SetupNavigation(thisPage)

    -- Install the document specific keyhandler
    thisPage:SetKeyHandler(function (key, state)
        -- Only evaluate if the key is pressed down
        if state == "down" or state == "repeat" then
            -- Process the key event using the NavigableElement stack
            NavigableElement.ProcessKey(key)
        end
    end)

    -- Active document keyhandler
    thisPage:ActivateKeyHandler()

    RotateStack()
    Animator.init()

end

OnPageLoaded = function (document)
    local status, err = pcall(PageLoadedCallback,document)
    if status ~= true then
        print("Error: " .. err)
        print(debug.traceback())
    end
end