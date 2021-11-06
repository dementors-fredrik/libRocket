
local pathPrefix = "/mnt/nfs/rocket/"; -- "/tmp/lua/RocketLua/"

if sys and sys.zenterio_debug ~= nil then
    -- Overwrite lua's print with sys.zenterio_debug so we see any logs
    print = sys.zenterio_debug
end

-- RocketApp on zenterios platform currently requires full path for LoadDocument
if sys and sys._emulator then  -- but the emulator don't, so strip the prefix
    pathPrefix = ""
end

print("Zenterio glue, loading target application")

if rocket:LoadFontFace(pathPrefix .. "src/Fonts/OpenSans-Regular.ttf") == true and
   rocket:LoadFontFace(pathPrefix .. "src/Fonts/OpenSans-Bold.ttf") == true and
   rocket:LoadFontFace(pathPrefix .. "src/Fonts/OpenSans-BoldItalic.ttf") == true then

    print("Fonts successfully loaded")

    maincontext = rocket.contexts["main"]
    mainDocument = maincontext:LoadDocument(pathPrefix .. "src/rotor3dq.rml")
    mainDocument:Show()

    print("Application loaded")
else
    print("Fonts failed loading, aborting")
end

