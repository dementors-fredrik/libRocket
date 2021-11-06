--[[
    That generates RCSS transformations
    
    This class uses a chaining object approach, 

    thus most calls returns the calling instance itself, allowing to chain operations in a liguistical pleasing way.

    ex. 
        local animation = Animation.Create(<a RML node>) 
        animation:smoothstep("<attribute>"):from(40):to(50):overSeconds(5):pxattribute():compile() 
        
        Will create a animation that translates the specified attribute from 40px to 50px over 5 seconds. 

        The animation is only compiled and prepared for execution, the animation itself is not selfcontained and needs to be submit to a 
        governer to actually execute. 

    Todo: Investigate if it's feasible to automatically recognize and parse CSS transformations 

]]--
Animation = {}
Animation.__index = Animation

-- Commented code that been disabled (but may be reintroduced after certain quirks in librocket are ironed out)
-- The main issue is that librocket don't regenerate the RCSS based on accessor set values, this makes it difficult 
-- to stack animations or coexist with external routines that changes the CSS.
-- 
-- Therefor the animators currently set the explicit attribute they animate, even though it could past a certain treshould 
-- be more effecient to set several at once this way.

--Animation._extractHash = function (styleString)
--    local hash = {}
--    local strings = Utils.SplitString(styleString, ";")
--    for i=0,#strings do
--        local rcssEntry = strings[i]
--        local keyValue = Utils.SplitString(rcssEntry, ":", true)
--        hash[keyValue[0]] = keyValue[1]
--    end
--    return hash
--end

--[[

Animation.generateStyle = function (self)
    local styleString = "";
    if not self._baseHash then
      self._baseHash = Animation._extractHash(self._targetNode:GetAttribute("style"))
    end
    for target,baseValue in pairs(self._baseHash) do
        local value = baseValue
        local transformator = self._transformations[target]

        if transformator then
            value = transformator.generator(transformator.start + (transformator.delta * (self._progress/100)))
        end 

        styleString = styleString .. target .. ":" .. value .. ";"
    end
    self._targetNode:SetAttribute("style", styleString) 
end 
]]--

Animation.updateStyle = function (self, transformator, percent) 
    local update = transformator.generator(transformator:interpolator(percent), percent)
    self._targetNode.style[transformator.target] = update
--    for target, transformator in pairs(self._transformations) do
--        local update = transformator.generator(transformator.start + (transformator.delta * (self._progress / 100)), self._progress)
--        self._targetNode.style[target] = update 
--    end
end

Animation.finish = function (self) 

    print("finishing")
    print(debug.traceback())


    for target, transformator in pairs(self._transformations) do
        transformator.progress = transformator.transisitonTime
        transformator.delay = 0;
        if transformator.completion then
            transformator:completion()
        end
    end
    self:update(0)
end

-- Called from the governer to process the animation with the specified frametime
-- Returns true if the animation is still active otherwise false
Animation.update = function (self, frametime)    
    local anyActive = false
    --print("Frametime " .. frametime)
    for target, transformator in pairs(self._transformations) do
        local delay = transformator.delay 
        local saturatedProgress = 0.0;

        if delay <= 0 then 
            local progress = (transformator.progress + frametime);
            
            if  progress > transformator.transisitonTime then
                progress = transformator.transisitonTime
            end

            transformator.progress = progress;

            saturatedProgress = progress / transformator.transisitonTime
           -- print("Clamped " .. clampProgress)
            saturatedProgress = math.max(0, saturatedProgress)
            saturatedProgress = math.min(1, saturatedProgress)
        else
            anyActive = true
            transformator.delay = transformator.delay - frametime 
        --    print("Delay " .. transformator.delay .. " frame " .. frametime)
            saturatedProgress = 0.0;
        end

        if saturatedProgress >= 0 then
            self:updateStyle(transformator, saturatedProgress)
            if saturatedProgress ~= 1.0 then
                anyActive = true
            elseif transformator.completion then
                transformator.completion();
                transformator.completion = nil
            end
        end
    end

    return not anyActive
end

-- Init default values
Animation.init = function (self, target)
    self._target = target
    self._completion = nil
    self._timedelay = 0
    return self
end

-- Smoothstep the specified attribute (smoothstep has an sort of S shaped acceleration, thus it accelerates slowly; speeds up and slows down slowly)
-- This particular implementation is actually a smootherstep but they're very similar, smootherstep is a bit more pronounced thus looks better with low framerate
Animation.smoothstep = function (self, target)
    self:init(target)
    self._interpolator = function (self, step) 
                            function smooth(x) return x * x * (3 - 2 * x) end
                            local x = smooth(step)
                            return self.start + (self.delta * smooth(smooth(x)))
                         end
    return self
end

-- Bounce 
-- Will interpolate with a bounce, thus it will over and undershoot at the end of the interpolation
Animation.bounce = function (self, target)
    self:init(target)
    self._interpolator = function (self, step) 
                            function bounce(x) return x * x * (4 - 3 * x) end
                            local x = bounce(step)
                            return self.start + (self.delta * (bounce(x)))
                         end
    return self
end

-- Linear interpolation
-- Transistions from A to B with no acceleration or deacceleration
Animation.lerp = function (self, target) 
    self:init(target)
    self._interpolator = function (self, step) return self.start + (self.delta *  step) end
    return self
end

-- Transistion start point
Animation.from = function (self, from)
    self._begin = from
    return self
end

-- Transistion end point
Animation.to = function (self, to) 
    self._end = to
    return self
end

-- For debug reasons, do not use
Animation.setTimebase = function (self, timebase)
    return self
end

-- Specify the transistion time in seconds, if not specified it defaults to one second.
Animation.overSeconds = function (self, time) 
    self._totalTime = (time*1000)
    return self
end

-- Delay the animation by X seconds, ie the animation will not start until this time passed after it's been started
Animation.startAfter = function (self, delay) 
    self._timedelay = (delay * 1000)
    return self
end

-- used for all attributes that has a pixel value
Animation.pxattribute = function (self) 
    self._generator = function (coord) return coord .. "px" end 
    return self
end

-- Specify a custom generator
Animation.withGenerator = function (self, generator) 
    self._generator = generator
    return self
end

-- Calls the specified method when the animation completed
Animation.withCompletion = function (self, callback) 
    self._completion = callback
    return self
end

-- Compile the animation, after this call been made no further adjustments can be made on the actual animation.
-- This method also initializes the element and attribute of the specified node to the start value specified
Animation.compile = function (self) 
    self._transformations[self._target] = {
        ["delay"] = self._timedelay,
        ["target"] = self._target,
        ["start"] = self._begin,
        ["progress"] = 0,
        ["transisitonTime"] = self._totalTime,
        ["delta"] = (self._end - self._begin),
        ["interpolator"] = self._interpolator,
        ["generator"] = self._generator,
        ["completion"] = self._completion 
    }
    self:update(0)
    return self
end

Animation.Create = function (node)
    local i = {}
    setmetatable(i, Animation)
    if node then
        if node:GetAttribute("style") == nil then
            node:SetAttribute("style", "")
        end
        i._targetNode = node
        i._timedelay = 0
        i._totalTime = 1000
        i._transformations = {}
    end

    return i;
end
