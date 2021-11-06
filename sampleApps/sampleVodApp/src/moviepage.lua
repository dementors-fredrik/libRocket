print("Page controller loaded")


local rawMovieData = {
    {
        ["title"] = "Star Wars: The Force Awakens",
        ["origin"] = "USA, 2015",
        ["duration"] = "136 Minutes",
        ["genre"] = "Action, Adventure, Fantasy",
        ["audience"] = "NR",
        ["languages"] = "English",
        ["availability"] = "December 18, 2015",

        ["synposis"] = [[A continuation of the saga created by George Lucas set thirty years after Star Wars: Episode VI - Return of the Jedi (1983).]],

        ["cover"] = "img/swcover.png",
        ["background"] = "img/swbg2.png",
        ["rating"] = "5",
        ["ratingText"] = "(4212) imdb"
    },
    {
        ["title"] = "Maze Runner: The Scorch Trials",
        ["origin"] = "USA, 2015",
        ["duration"] = "132 Minutes",
        ["genre"] = "Action, Sci-Fi, Thriller",
        ["audience"] = "PG-13",
        ["languages"] = "English",
        ["availability"] = "Available now",

        ["synposis"] = [[In this next chapter of the epic "Maze Runner" saga, Thomas (Dylan O'Brien) and his fellow Gladers face their greatest challenge yet: searching for clues about the mysterious and powerful organization known as WCKD. Their journey takes them to the Scorch, a desolate landscape filled with unimaginable obstacles. Teaming up with resistance fighters, the Gladers take on WCKD's vastly superior forces and uncover its shocking plans for them all.]],

        ["cover"] = "img/mazecover.png",
        ["background"] = "img/mazebg.png",
        ["rating"] = "1",
        ["ratingText"] = "(4) imdb"
    },
        {
        ["title"] = "Jurassic World",
        ["origin"] = "USA, 2015",
        ["duration"] = "124 Minutes",
        ["genre"] = "Action, Adventure, Sci-Fi",
        ["audience"] = "PG-13",
        ["languages"] = "English",
        ["availability"] = "Available now",

        ["synposis"] = [[Twenty-two years after the events at Jurassic Park, a new theme park, Jurassic World, now operates in Isla Nublar, off the Pacific coast of Central America. Brothers Zach and Gray Mitchell are sent there to visit their aunt, Claire Dearing, the park's operations manager. Claire's assistant Zara Young is their guide as Claire is too busy recruiting corporate sponsors with a new attraction, a genetically modified, synthetic dinosaur called Indominus rex. The dinosaur has the base genome of a Tyrannosaurus rex and the DNA of several predatory dinosaurs as well as modern-day animals; chief geneticist Dr. Henry Wu keeps the exact genetic makeup classified.

Owen Grady trains the park's Velociraptors that considers him the pack alpha. Vic Hoskins, head of park security, believes they are trainable for military use, but Owen disputes this. Park owner Simon Masrani has Owen evaluate the Indominus‍‍ '​ enclosure before the attraction opens. Owen warns Claire that the Indominus is particularly dangerous because it has not socialized with other animals.

Owen and Claire discover that the Indominus has seemingly escaped. Owen and two staff enter the enclosure, but the Indominus ambushes them, then disappears into the island's interior. Owen wants it killed, but Masrani sends the Asset Containment Unit to capture the dinosaur alive. When it kills most of the team, Claire orders the island's northern section be evacuated.

Zach and Gray, exploring in a gyrosphere ride, ignore the evacuation order and wander into a restricted area. The vehicle is attacked by the Indominus but they escape unharmed. They come upon the ruins of the original Jurassic Park Visitor Center, and, after repairing an old Jeep, drive back to the park's resort area. Owen and Claire trail them after barely escaping the Indominus themselves. The Indominus continues its rampage and breaks into the park's pterosaur aviary. Masrani and two troopers hunt the Indominus by helicopter, but a collision with the escaping pterosaurs causes them to crash, killing everyone aboard. Gray and Zach arrive at the resort as the pterosaurs begin attacking the visitors. They find Owen and Claire while armed troopers subdue the pterosaurs.

Hoskins assumes command and decides to use the raptors to track the Indominus; Owen reluctantly agrees to go along with the plan. The raptors follow the Indominus‍ '​ scent into the jungle. However, Owen figures out that the Indominus has raptor DNA, as it is seen communicating with the raptors and turns them against the humans. Hoskins, meanwhile, has Dr. Wu helicoptered off the island with the dinosaur embryos, protecting his research. Owen, Claire, and the boys find Hoskins in the lab packing up remaining embryos. As Hoskins unveils his intention to create more genetically modified dinosaurs as weapons, a raptor breaks into the lab and kills him.

Outside, the raptors corner Owen, Claire, and the boys. Owen reestablishes his alpha bond before the Indominus appears. The raptors attack the Indominus, which kills two raptors. Realizing they are outmatched, Claire lures the park's veteran T. rex into a battle with the Indominus. The T. rex is overpowered until the lone surviving raptor attacks. The raptor and T. rex force the overwhelmed Indominus towards the lagoon, where it is dragged underwater by the park's resident Mosasaurus.

The survivors are evacuated to the mainland, and the island is abandoned to the dinosaurs. Zach and Gray are reunited with their parents, while Owen and Claire decide to stay together "for survival".]],

        ["cover"] = "img/jwcover.png",
        ["background"] = "img/jwbg.png",
        ["rating"] = "3",
        ["ratingText"] = "(24) metacritic"
    }
}


-- Populates the default information page
Populate = function (forThisPage, navigationStack)
    Animator.reset()

    local populateThisData = navigationStack:GetActiveEntry()
    -- Set the title and origin
    forThisPage:ResolveElement("title").inner_rml = populateThisData["title"]
    forThisPage:ResolveElement("origin").inner_rml = populateThisData["origin"]

    -- Set movie meta data
    forThisPage:ResolveElement("duration").inner_rml = populateThisData["duration"]
    forThisPage:ResolveElement("genre").inner_rml = populateThisData["genre"]
    forThisPage:ResolveElement("audience").inner_rml = populateThisData["audience"]
    forThisPage:ResolveElement("languages").inner_rml = populateThisData["languages"]
    forThisPage:ResolveElement("availability").inner_rml = populateThisData["availability"]

    -- Set the synposis
--    forThisPage:ResolveElement("synposis").style["display"] = "none"

--    forThisPage:ResolveElement("synposis").inner_rml = "" 
    forThisPage:ResolveElement("synposis").inner_rml = populateThisData["synposis"]

--       <div id="synposis" style="font-size: 20px; font-weight: bold; width: 500px;height: 415px; top: 235px; left: 448px; overflow: hidden; color: rgba(255, 255, 255, 255); white-space: pre-wrap;border-color: rgb(255, 20, 150); border-width: 0px;"></div>

    -- Set the cover and background images
    forThisPage:ResolveElement("cover"):SetAttribute("src", populateThisData["cover"])
    forThisPage:ResolveElement("background"):SetAttribute("src", populateThisData["background"])
    DrawScroller(thisPage, thisPage:ResolveElement("synposis"))
    thisPage:ResolveElement("index").inner_rml = navigationStack:GetIndex() .. "/" .. navigationStack:Length()

    local stars = tonumber(populateThisData["rating"]) or 1

    -- make sure excess stars are gray
    for i=stars,5 do
        forThisPage:ResolveElement("rating" .. i):SetAttribute("src", "img/graystar.png")
    end

    -- make sure rating stars are golden
    for i=1,stars do
        forThisPage:ResolveElement("rating" .. i):SetAttribute("src", "img/star.png")
    end

    forThisPage:ResolveElement("ratingText").inner_rml = populateThisData["ratingText"]

-- Setup animations
    local dimmerAnimation = Animation.Create(thisPage:ResolveElement("dimmer"))
    dimmerAnimation:smoothstep("background-color"):from(255):to(150):withGenerator(function (alpha) return "rgba(0,0,0," .. alpha..")" end):compile()
    Animator.submit(dimmerAnimation)

    local coverAnimation = Animation.Create(thisPage:ResolveElement("cover"))

    coverAnimation:bounce("top"):pxattribute():from(300):to(127):overSeconds(1.5):compile()
    coverAnimation:bounce("height"):pxattribute():from(0):to(525):overSeconds(1.0):compile()


    local ratingAnimation = Animation.Create(thisPage:ResolveElement("rating"))
    ratingAnimation:smoothstep("top"):pxattribute():from(800):to(655):overSeconds(2):compile()

    for i=1,5 do
        local starAnimator = Animation.Create(thisPage:ResolveElement("rating" .. i))

        starAnimator:bounce("width"):pxattribute():from(150):to(25):startAfter((5-i)*1.1):compile()
        starAnimator:bounce("height"):pxattribute():from(150):to(25):startAfter((5-i)*1.1):compile()

        starAnimator:smoothstep("left"):pxattribute():from(-400):to(25*(i-1)):startAfter((5-i)*1.1):compile()
        starAnimator:smoothstep("top"):pxattribute():from(-300):to(0):startAfter((5-i)):compile()
        Animator.submit(starAnimator)
    end

    FadeIn("title", 0)
    FadeIn("origin", 1)
    FadeIn("durationTitle", 2) FadeIn("duration", 2)
    
    FadeIn("genreTitle", 3) FadeIn("genre", 3)
    
    FadeIn("audienceTitle", 4) FadeIn("audience", 4)
    
    FadeIn("languagesTitle", 5) FadeIn("languages", 5)

    FadeIn("synposis", 0)

    Animator.submit(coverAnimation)
    Animator.submit(ratingAnimation)
    Animator.start()
end

FadeIn = function (elementName, delay) 
    local fader = Animation.Create(thisPage:ResolveElement(elementName))
    fader:smoothstep("color"):from(0):to(255):startAfter(delay*0.5):withGenerator(function (alpha) return "rgba(255,255,255," .. alpha..")" end)
    fader:compile()
    Animator.submit(fader)
end

DrawScroller = function (page, element)
    local currentScroll = element.scroll_top;
    local maxScroll = element.scroll_height - element.client_height;

    -- Setup default state for the scroll arrows
    local up = page:ResolveElement("scrollUp")
    local down = page:ResolveElement("scrollDown")
    up.style["display"] = "block"
    down.style["display"] = "none"

    if currentScroll == 0 then
        -- hide the up arrow
        up.style["display"] = "none"
    end

    if currentScroll < maxScroll then
        -- show down arrow
        down.style["display"] = "block"
    end
end

SetupNavigation = function (thisPage)
    -- Setup callbacks for synposis
    local synposis = NavigableElement.Create(thisPage:ResolveElement("synposis"))

    synposis:SetOnFocus( function (self)
        local el = self._element
        el.style["border-width"] = "2px"
        el.style["margin"] = "0px"
        el.style["display"] = "block" -- Appears necessary to force rerender, librocket bug?
    end)

    synposis:SetOnLostFocus( function (self)
        local el = self._element
        el.style["border-width"] = "0px"
        el.style["margin"] = "2px"
        el.style["display"] = "block" -- Appears necessary to force rerender, librocket bug?
    end)

    synposis:SetKeyHandler( function (key)
        if key == "up" then
            local synposis = thisPage:ResolveElement("synposis")
            -- Scroll the synopsis field up 50 px
            synposis.scroll_top = synposis.scroll_top - 50
            DrawScroller(thisPage, synposis)
            return true
        elseif key == "down" or key == "repeat" then
            local synposis = thisPage:ResolveElement("synposis")
            -- Scroll the synposis field down 50 px
            synposis.scroll_top = synposis.scroll_top + 50
            DrawScroller(thisPage, synposis)
            return true
        end
        return false
    end)

    thisPage:ResolveElement("fpsbutton").style["display"] = "none"

    if false then 
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
            local entry = withPageStack:GetActiveEntry()
            if key == "ok" then
            end
        end)

    end

    -- Setup callback for play
    local playbutton = NavigableElement.Create(thisPage:ResolveElement("play"))

    playbutton:SetOnFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(255, 20, 150)"
    end)

    playbutton:SetOnLostFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(150, 150, 150)"
    end)

    playbutton:SetKeyHandler( function (key)
        local entry = withPageStack:GetActiveEntry()

        if key == "ok" then
            -- Get the active entry and start playback

            local details = thisPage:ResolveElement("movieDetails")
            local playContext = thisPage:ResolveElement("playcontainer")

            if entry._playing ~= true then

                Animator.reset()
                Animator.start()

                pageTransistion = Animation.Create(thisPage:ResolveElement("movieDetails"));
                playContext.style["display"] = "block"
                thisPage:ResolveElement("playbackInfo").inner_rml = "Fake playback of " .. entry.title

                pageTransistion:smoothstep("top"):from(0):to(-720):pxattribute()
                pageTransistion:withCompletion(function ()
                    details.style["display"] = "none"
                    print("Play " .. entry.title)
                end):compile();
                Animator.submit(pageTransistion:compile())

                entry._playing = true


                -- Start playback here
            else
                Animator.reset()
                Animator.start()
                print("stop")
                details.style["display"] = "block"

                pageTransistion = Animation.Create(thisPage:ResolveElement("movieDetails"));
                pageTransistion:bounce("top"):from(-720):to(0):pxattribute()
                pageTransistion:withCompletion(function ()
                    playContext.style["display"] = "none"
                    thisPage:ResolveElement("playbackInfo").inner_rml = "Fake playback of " .. entry.title
                    print("Stop playback ")
                end):compile();
                Animator.submit(pageTransistion:compile())

                entry._playing = false

                -- Stop playback here
            end
            return true
        elseif entry._playing then
            -- block all other keys but "ok"
            return true;
        end
        return false
    end)

    -- Setup callback for next button
    local nextbutton = NavigableElement.Create(thisPage:ResolveElement("next"))

    nextbutton:SetOnFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(255, 20, 150)"
    end)

    nextbutton:SetOnLostFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(150, 150, 150)"
    end)

    nextbutton:SetKeyHandler( function (key)
        if key == "ok" then
            withPageStack:MoveIndex(withPageStack.RIGHT)
--       <img id="cover" src="" style="width: 350px; height: 525px; top: 127px; left: 67px; display: block;"/>

   -- coverAnimation:interpolate("left"):from(67 + (350/2)):to(67):withGenerator(function (coord) return coord .. "px" end):compile()
   -- coverAnimation:interpolate("width"):from(0):to(350):withGenerator(function (coord) return coord .. "px" end):compile()
            local coverAnimation = Animation.Create(thisPage:ResolveElement("cover"))
            Animator.reset()
            coverAnimation:bounce("top"):from(127):to(300):overSeconds(1.0):pxattribute():compile()
            coverAnimation:bounce("height"):from(525):to(0):overSeconds(0.5):pxattribute()
            coverAnimation:withCompletion(function () Populate(thisPage, withPageStack) end):compile()
            Animator.submit(coverAnimation)
            
            local dimmerAnimation = Animation.Create(thisPage:ResolveElement("dimmer"))
            dimmerAnimation:smoothstep("background-color"):from(150):to(255):withGenerator(function (alpha) return "rgba(0,0,0," .. alpha..")" end):compile()
            Animator.submit(dimmerAnimation)

            Animator.start()
            return true
        end
        return false
    end)

    -- Setup callback for previous button
    local previousbutton = NavigableElement.Create(thisPage:ResolveElement("previous"))

    previousbutton:SetOnFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(255, 20, 150)"
    end)

    previousbutton:SetOnLostFocus( function (self)
        local el = self._element
        el.style["background-color"] = "rgb(150, 150, 150)"
    end)

    previousbutton:SetKeyHandler( function (key)
        if key == "ok" then
            withPageStack:MoveIndex(withPageStack.LEFT)

            local coverAnimation = Animation.Create(thisPage:ResolveElement("cover"))
            Animator.reset()
            coverAnimation:bounce("top"):from(127):to(300):overSeconds(1.0):pxattribute():compile()
            coverAnimation:bounce("height"):from(525):to(0):overSeconds(0.5):pxattribute()
            coverAnimation:withCompletion(function () Populate(thisPage, withPageStack) end):compile()
            Animator.submit(coverAnimation)

            local dimmerAnimation = Animation.Create(thisPage:ResolveElement("dimmer"))
            dimmerAnimation:smoothstep("background-color"):from(150):to(255):withGenerator(function (alpha) return "rgba(0,0,0," .. alpha..")" end):compile()
            Animator.submit(dimmerAnimation)
             
            Animator.start()
            return true
        end
        return false
    end)


    -- Setup navigation routing
    -- Only the most basic layout hints has to be setup as demonstrated in the diagram below
    -- Additional paths will automatically be generated when the user moves around
    -- Note basic layout is equivalent to the default path the user traverses the view
    --
    -- So in this example it means pressing right ends up on the "play button"
    -- But if the user navigates down to the previous button, then press left followed by right
    -- He will end up on the previous button again
    --
    --                 ->  <2 play>
    --                /       \/
    --  <1 synposis> <-<-- <3 next>
    --                 \      \/
    --                   - <4 previous>

    synposis:SetRight(playbutton)  -- The playbutton is right of the synposis (connect 1->2)

    if fpsbutton then
        playbutton:SetUp(fpsbutton)
    end

    playbutton:SetDown(nextbutton) -- The nextbutton is below the playbutton (connect 2->3)
    nextbutton:SetDown(previousbutton) -- The previousbutton is below the nextbutton (connect 3->4)

    nextbutton:SetLeft(synposis)  -- The synposis is to the left of the nextbutton (connect 3->1)
    previousbutton:SetLeft(synposis) -- As well as to the left of the previous button (connect 4->1)

    NavigableElement.SetDefaultElement(synposis) -- Place the user on the synposis field
end

PageLoadedCallback = function (document)
    -- Instance the document wrapper for the given document
    thisPage = Utils.Create(document)

    -- Setup page navigation using the NavigableElement stack
    SetupNavigation(thisPage)

    -- Instance the movie page stack
    withPageStack = Array.Create(rawMovieData)

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

    -- Populate initial entry
    Populate(thisPage, withPageStack)

    Animator.setFramerateUpdateCallback( function (fps, isCalibrating) 
        local i, f = math.modf(fps+.5)
        if isCalibrating then
            thisPage:ResolveElement("fpsText").inner_rml = "Please wait, figuring coarse fps... "
        else
            thisPage:ResolveElement("fpsText").inner_rml = "Framerate " .. i
        end
    end)

    Animator.init() -- Setup animator if necessary (binds to tick source)
end

-- Callback triggered when the index.rml been loaded (onload)

OnPageLoaded = function (document)
    local status, err = pcall(PageLoadedCallback,document)
    if status ~= true then
        print("Error: " .. err)
        print(debug.traceback())
    end
end

print("Page controller finished")
