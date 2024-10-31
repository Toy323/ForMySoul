BASE_MODULE = {}
BASE_MODULE.Time = 0
BASE_MODULE.Version = "0.2.3.3"
BASE_MODULE.WaveNow = 0
BASE_MODULE["TimeR"] = 0
SUBMODULE_INPUT = {}
SUBMODULE_DRAW = {}
PHANTOMS = {}
BUTTON = {}
function print_t(...)
    for k,v in pairs(...) do
        print(k, v)
    end
end
function Color(r,g,b,a)
    
    return {['r'] = math.min(255,r),['g'] = math.min(255,g),['b'] = math.min(255,b),['a'] = a}
end
require('lua/table_enc')
require('lua/middleclass')
require('lua/tilemap')
require('lua/enemy')
require('lua/projectiles')
require('lua/waves')
require('lua/weapons')
require('lua/fusions')
local addSound = love.audio.newSource
BASE_MODULE.Sounds = {}
local smgpause = love.graphics.newImage('images/pause.png')
local resume = love.graphics.newImage('images/start.png')
local resume2 = love.graphics.newImage('images/256_ready.png')

BASE_MODULE.Sounds["energySound"] = {
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),
    addSound("sound/power1.ogg","static"),
    addSound("sound/power4.wav", "static"),--1 звук...

}
function PlaySound(variant, number)
    BASE_MODULE.Sounds[variant][(number or 1)]:play()
end
local mouse = love.mouse
-- success, valueOrErrormsg = runFile( name )
local function runFile(name)
	local ok, chunk, err = pcall(love.filesystem.load, name) -- load the chunk safely
	if not ok    then  return false, "Failed loading code: "..chunk  end
	if not chunk then  return false, "Failed reading file: "..err    end

	local ok, value = pcall(chunk) -- execute the chunk safely
	if not ok then  return false, "Failed calling chunk: "..tostring(value)  end

	return true, value -- success!
end
local bim = love.graphics.newImage('ritual.png')
SELECTED_TOOL = 0
function beginContact(a, b, coll)
--	if a:getGroupIndex() ~= b:getGroupIndex() then
        local enemy = string.sub(b:getUserData(), #b:getUserData()) == "G" and ENEMIES[tonumber(string.sub(b:getUserData(), 0, #b:getUserData()-1))] or string.sub(a:getUserData(), #a:getUserData()) == "G" and ENEMIES[tonumber(string.sub(a:getUserData(), 0, #a:getUserData()-1))] or tilesblock[tonumber(a:getUserData())] or tilesblock[tonumber(b:getUserData())]
        local proj = string.sub(b:getUserData(), #b:getUserData()) ~= "G" and projectiles[tonumber(b:getUserData())] or projectiles[tonumber(a:getUserData())] or tilesblock[tonumber(a:getUserData())] or tilesblock[tonumber(b:getUserData())]
        if proj and proj.OnContact and enemy and enemy.IsEnemy then
            proj:OnContact(enemy)
        end
        if enemy and enemy.OnContact and proj and not proj.IsTile then
            enemy:OnContact(proj)
        elseif  enemy and enemy.OnContact and proj and proj.IsTile then
            enemy:OnContact(proj)
        end
        local contact = proj and proj.OnContact2 or enemy and enemy.OnContact2
        if contact then
            contact(enemy, proj)
        end
   -- end
end

function endContact(a, b, coll)
	
end

function preSolve(a, b, coll)
	
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end
function CurTime()
    return BASE_MODULE["Time"]
end
function RealTime()
    return BASE_MODULE["TimeR"]
end
local nextframes = {}
local nextframes2 = {}
function DoNextFrame(func)
    nextframes[#nextframes + 1] = func
end
function DoNextFramePlus(func, frames)
    nextframes2[#nextframes2 + 1] = {func, frames or 1}
end

local ready = love.graphics.newImage('images/ready.png')
local del = love.graphics.newImage('images/del.png')

local imgx1 = love.graphics.newImage('images/double_by_1.png')
local imgx2 = love.graphics.newImage('images/double_by_2.png')
local imgx4 = love.graphics.newImage('images/double_by_4.png')

BASE_MODULE["SpeedMul"] = 1
local baseMoney = 1000
BASE_MODULE["MoneyNow"] = baseMoney
BASE_MODULE.HealthNow = 10000
function GetM()
    return BASE_MODULE.MoneyNow
end
function ClearAll()
    for k,v in pairs(cache) do
        if v then
            BUTTON.RemoveButton(v)
        end
    end
    cache = {}
    for k,v in pairs(tilesblock) do
        if v and v.Remove then
            v:Remove()
        end
    end
    tilesblock = {}
    for k,v in pairs(ENEMIES) do
        if v and v.Remove then
            v:Remove()
        end
    end
    ENEMIES = {}
    for k,v in pairs(projectiles) do
        if v and v.Remove then
            v:Remove()
        end
    end
    projectiles = {}--НАХУЙ МУСОРОСОБИРАТEЛЬ!!Я ХОЧУ ЧТОБЫ НАХУЙ КРАШИЛО ПРИ ОЧИСТКE КАРТЫ!!!
end
rng = love.math.newRandomGenerator()
rng:setSeed(os.time())
BASE_MODULE.rng = rng
function rand(min,max)
    return rng:random(min, max)
end
gameloaded = false
function loadGame()
	rng = love.math.newRandomGenerator()
	rng:setSeed(os.time())
    BASE_MODULE.rng = rng
    cache = {}
    
    local button = BUTTON.AddButton(1,1430,66,Color(255,255,255),1,1, imgx1)
    button.OnClickDo = function() 
        BASE_MODULE["SpeedMul"] = BASE_MODULE["SpeedMul"] * 2
        if  BASE_MODULE["SpeedMul"] > 4 then
            BASE_MODULE["SpeedMul"] = 1
        end
        button.img = BASE_MODULE["SpeedMul"] == 2 and imgx2 or BASE_MODULE["SpeedMul"] == 4  and imgx4 or imgx1
    end
    cache[#cache + 1] = button.ID
    local button = BUTTON.AddButton(1,1500,66,Color(5,130,28),1,1, ready)
    button.OnClickDo = function() 
        if not BASE_MODULE.ActiveMode then
            tiles:CreateMapFull(0,320,5,125, FORMULA_PARALEP_R, 12, Color(156,215,96))
        end
        WAVE:Start()
    end
    cache[#cache + 1] = button.ID
    local button = BUTTON.AddButton(1,1570,66,Color(209,185,29),1,1, smgpause)
    button.OnClickDo = function() 
       BASE_MODULE.OnPause = not BASE_MODULE.OnPause
       button.img = BASE_MODULE.OnPause and resume or smgpause
       button.Color = BASE_MODULE.OnPause and Color(155,220,141) or Color(209,185,29)
    end
    BASE_MODULE["ButtonOnspace"] = button
    cache[#cache + 1] = button.ID

    local oldy,oldx = 66, 1222
    local button = BUTTON.AddButton(1,oldx,oldy,Color(220,128,79),1,1, bim)
    local oldid = button.ID

        
    
    button.OnClickDo = function(x,y)
        BASE_MODULE["MoneyNow"] = baseMoney
        BASE_MODULE.HealthNow = 10000
        BASE_MODULE.ActiveMode = false
        WAVE.NextWave = 0
        BASE_MODULE["WaveNow"] = 0

        ClearAll()
        loadGame()
        BUTTON.RemoveButton(oldid)
    end
    
    button.Think = function()
        if SELECTED_TOOL == button then
            button.Position.x = love.mouse.getX() - 32
            button.Position.y =  love.mouse.getY() - 32
        else
            button.Position.x = oldx
            button.Position.y =  oldy
        end
    end

    local oldy,oldx = 66, 1110
    local button = BUTTON.AddButton(1,oldx,oldy,Color(181,0,0),1,1, del)
    local oldid = button.ID
    BASE_MODULE.ButtonOnMinus = button
    
    button.OnClickDo = function(x,y)
        if SELECTED_TOOL ~= button then
            SELECTED_TOOL = button
        else
            SELECTED_TOOL = 0
            for k,v in pairs(tilesblock) do
                if x < v.Position.x + (v.Size or 2)*1.5  and x > v.Position.x and y < v.Position.y + (v.Size or 2)*1.5 and y > v.Position.y then
                    if v.HasCollision then
                        v:Remove()
                        break 
                    end
                end
            end
        end
    end
    
    button.Think = function()
        if SELECTED_TOOL == button then
            button.Position.x = love.mouse.getX() - 32
            button.Position.y =  love.mouse.getY() - 32
        else
            button.Position.x = oldx
            button.Position.y =  oldy
        end
    end
    cache[#cache + 1] = button.ID
    --table.insert(cache,button.ID)
    local was = {}
    local frremove = {}
    for i=1,#WEAPONS.NamesByID do
        local img = WEAPONS.IconsByID[i] and WEAPONS.IconsByID[i][1] or nil
        local button = BUTTON.AddButton(48,64*2 + 64 * ((i%9)-1),120 + 56 * math.ceil(i/9), img and WEAPONS.IconsByID[i][2] or Color(51,167,169), img and 1, img and 1, img, {WEAPONS.CostByName[WEAPONS.NamesByID[i]], 0, -15})
        frremove[#frremove + 1] = button.ID
        button.OnClickDo = function(x,y)
            if SELECTED_TOOL ~= button and not button.NOPICK then
                --SELECTED_TOOL = button
                table.insert(was, button.ID)
                local g = #was
                local img = WEAPONS.IconsByID[i] and WEAPONS.IconsByID[i][1] or nil
                button.NOPICK = true
                button.Position = {x = 222222,y =222222}
                local gal = BUTTON.AddButton(48, 64*2 + 64 * g, 66, img and WEAPONS.IconsByID[i][2] or Color(51,167,169), img and 1, img and 1, img, {WEAPONS.CostByName[WEAPONS.NamesByID[i]], 0, -15})
                BASE_MODULE["ButtonOn"..g] = gal
                table.insert(cache, gal.ID)
                if #was > 8 then
                    for k,v in pairs(frremove) do
                        if v then
                            BUTTON.RemoveButton(v)
                        end
                    end
                end
                gal.WeaponOnMe = WEAPONS.NamesByID[i]
                gal.IDOfWeapon = i
                cache[#cache + 1] = gal.ID
                gal.OnClickDo = function(x,y)
                    if SELECTED_TOOL ~= gal then
                        SELECTED_TOOL = gal
                    else
                        SELECTED_TOOL = 0 
                        local finded = false
                        for k,v in pairs(tilesblock) do
                            if x < v.Position.x + (v.Size or 2)*1.5  and x > v.Position.x and y < v.Position.y + (v.Size or 2)*1.5 and y > v.Position.y then
                                if v.HasCollision then
                                    if BASE_MODULE["MoneyNow"] < WEAPONS.CostByName[WEAPONS.NamesByID[i]] or BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] and BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] > CurTime() then
                                        break
                                    end
                                    if WEAPONS.IDFusion[v.WeaponOnMe.."plus"..gal.WeaponOnMe] or WEAPONS.IDFusion[gal.WeaponOnMe.."plus"..v.WeaponOnMe] then
                                        local id = WEAPONS.IDFusion[v.WeaponOnMe.."plus"..gal.WeaponOnMe] or WEAPONS.IDFusion[gal.WeaponOnMe.."plus"..v.WeaponOnMe]
                                        local synergy = v.WeaponOnMe.."plus"..gal.WeaponOnMe
                                        local g = tile:Create(v.Position.x,v.Position.y,125/2,Color(156,215,96))
                                        DoNextFrame(function() g:SetColor(WEAPONS.ColorOfFus[id]) end)

                                        if BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] then
                                            BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] = CurTime() + (WEAPONS.BaseCD[WEAPONS.NamesByID[i]] or 5)
                                        end

                                        finded = true
                                        g.NextShoot = CurTime() + 0.7
                                        g.Init = function() 
                                        end
                                        g.InitB = function()
                                        end
                                        BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] - WEAPONS.CostByName[WEAPONS.NamesByID[i]]

                                        local funcw = WEAPONS.Fusions[id]
                                        g.IDOfWeapon = id
                                        g.WeaponOnMe = synergy

                                        if type(funcw) == "table" then
                                            for k2,v2 in pairs(funcw) do
                                                g[k2] = v2
                                            end
                                        else
                                            g.Think = funcw or function()
                                                if g.NextShoot < CurTime() then
                                                    g.NextShoot = CurTime() + 1.6
                                                    BASE_PROJ:BasePROJ(nil, x,y):SetPos(x,y)
                                                end
                                            end
                                        end
                                        g:AddCollision()
                                        
                                        g.OnRemove = function(self,x,y)
                                            tile:Create(x,y,125/2,Color(156,215,96))
                                        end
                                        v.OnRemove = function(self,x,y) end
                                        v:Remove()
                                    end
                                    break 
                                else
                                    if BASE_MODULE["MoneyNow"] < WEAPONS.CostByName[WEAPONS.NamesByID[i]] or BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] and BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] > CurTime() then
                                        break
                                    end
                                    if BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] then
                                        BASE_MODULE[WEAPONS.NamesByID[i].."_cd"] = CurTime() + (WEAPONS.BaseCD[WEAPONS.NamesByID[i]] or 5)
                                    end
                                    v:SetColor(Color(5 + 10*i,74,20 + i*30))
                                    BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] - WEAPONS.CostByName[WEAPONS.NamesByID[i]]
                                    finded = true
                                    v.NextShoot = CurTime() + 0.7
                                    v.Init = function() 
                                    end
                                    v.InitB = function()
                                    end
                                    local funcw = WEAPONS.FuncByID[i]
                                    v.IDOfWeapon = i
                                    v.WeaponOnMe = WEAPONS.NamesByID[i]
                                    if type(funcw) == "table" then
                                        for k2,v2 in pairs(funcw) do
                                            v[k2] = v2
                                        end
                                    else
                                        v.Think = funcw or function()
                                            if v.NextShoot < CurTime() then
                                                v.NextShoot = CurTime() + 1.6
                                                BASE_PROJ:BasePROJ(nil, x,y):SetPos(x,y)
                                            end
                                        end
                                    end
                                    v:AddCollision()
                                    v.OnRemove = function(self,x,y)
                                        tile:Create(x,y,125/2,Color(156,215,96))
                                    end
                                    break 
                                end
                            end
                        end
                    end
                end
                gal.Think = function()
                    if SELECTED_TOOL == gal then
                        gal.Position.x = love.mouse.getX() - 32
                        gal.Position.y =  love.mouse.getY() - 32
                    else
                        gal.Position.x = 64*2 + 64 * g
                        gal.Position.y = 66
                    end
                end
                gal.OnSeen = function(x,y)
                    if  WEAPONS.DescByID[i] and SELECTED_TOOL ~= gal then
                        love.graphics.setColor(0.1,.1,.1)
                        love.graphics.print( WEAPONS.DescByID[i],x+1,y+33)
                        love.graphics.setColor(1,1,1)
                        love.graphics.print( WEAPONS.DescByID[i],x,y+32)
                    end
                end
            end
        end
        button.Think = function()
            if button.NOPICK then return end
            if SELECTED_TOOL == button then
                button.Position.x = love.mouse.getX() - 32
                button.Position.y =  love.mouse.getY() - 32
            else
                button.Position.x = 120 + 64 * ((i-1)%9)
                button.Position.y = 120 + 86 * math.ceil(i/9)
            end
        end
        button.OnSeen = function(x,y)
            if WEAPONS.DescByID[i] then
                love.graphics.setColor(0.1,.1,.1)
                love.graphics.print( WEAPONS.DescByID[i],x+1,y+33)
                love.graphics.setColor(1,1,1)
                love.graphics.print( WEAPONS.DescByID[i],x,y+32)
            end
        end
        table.insert(cache,button.ID)
    end
    

    BASE_MODULE.world = love.physics.newWorld(0, 0, true) 

    BASE_MODULE.world:setContactFilter(filtercol)
    BASE_MODULE.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    gameloaded = true
end
function love.load()
    print(love.window.getFullscreen())
    love.window.setFullscreen(true)
    love.window.setTitle("Doset Vs Dosei v"..BASE_MODULE.Version)
    local x2,y2 = love.graphics.getDimensions()
    local button = BUTTON.AddButton(1,x2/2- 256/2,y2/2 - 256/2,Color(0,90,15),1,1, resume2)
    button.OnClickDo = function()
        loadGame()
        DoNextFrame(function() BUTTON.RemoveButton(button.ID) end)
    end
   --[[ 

    ball = {}
    ball.b = love.physics.newBody(world, 400,200, "dynamic")  -- set x,y position (400,200) and let it move and hit other objects ("dynamic")
    ball.b:setMass(-0.05)                                        -- make it pretty light
    ball.s = love.physics.newCircleShape(50)                  -- give it a radius of 50
    ball.f = love.physics.newFixture(ball.b, ball.s)          -- connect body to shape
    ball.f:setRestitution(1)                                -- make it bouncy
    ball.f:setUserData("Ball")                                -- give it a name, which we'll access later


    static = {}
    static.b = love.physics.newBody(world, 400,400, "static") -- "static" makes it not move
    static.s = love.physics.newRectangleShape(200,50)         -- set size to 200,50 (x,y)
    static.f = love.physics.newFixture(static.b, static.s)
    static.f:setUserData("Block")]] -- Для будущего
    --tiles
    --tiles:CreateMapLineDown(1,1,30,2)

end
BASE_MODULE.OnPause = false
function love.update(time)
    BASE_MODULE["TimeR"] = (BASE_MODULE["TimeR"] or 0) + time
    time = time * BASE_MODULE["SpeedMul"]
    if not BASE_MODULE.OnPause then
        BASE_MODULE["Time"] = (BASE_MODULE["Time"] or 0) + time
        if BASE_MODULE.world then
            BASE_MODULE.world:update(time)
        end
    end
end
function love.keypressed(button, code, isrepeat)
    if button then
        BASE_MODULE["LastTextInput"] = button
        BASE_MODULE["LastCodeInput"] = code
        if button == "f11" then
            love.window.setFullscreen(not love.window.getFullscreen())
        elseif button == "escape" then
            love.window.close()
        end
        SUBMODULE_INPUT.CreatePhantomText(BASE_MODULE["LastTextInput"] or 1)
        if button == "-" then
            BASE_MODULE.ButtonOnMinus.OnClickDo(-323,-323)
        end
        if BASE_MODULE["ButtonOn"..button] then
            BASE_MODULE["ButtonOn"..button].OnClickDo(-323,-323)
        end
    end
end
function love.mousepressed( x, y, button, istouch, presses )
    SUBMODULE_INPUT.CreatePhantomText(BASE_MODULE["LastTextInput"] or 1,x,y)
   -- print(x,y)
   local x2,y2 = 0,0
    for k,button in pairs(BUTTONS_SUB) do
        local size = button.Size
        local img = button.img 
        x2,y2 = size['x'], size['y']
        if img then
            x2 = x2 + img:getWidth()
            y2 = y2 + img:getHeight()
        end
       if x < button.Position.x + x2 and x > button.Position.x and y < button.Position.y + y2 and y > button.Position.y then
            if button.OnClickDo then
                button.OnClickDo(love.mouse.getX(),love.mouse.getY())
            end
       end
    end
end
function love.draw()
    love.graphics.setBackgroundColor(0.02,0.25,0)

    if gameloaded then
        love.graphics.print("Wave "..WAVE:GetWave(),128,128)

        love.graphics.print("Minerals Now "..GetM(),32,32)

        love.graphics.print("HP: "..BASE_MODULE.HealthNow,32,64)
    end

    SUBMODULE_DRAW.Think()

    --[[love.graphics.circle("line", ball.b:getX(),ball.b:getY(), ball.s:getRadius(), 20)
    love.graphics.polygon("line", static.b:getWorldPoints(static.s:getPoints()))]]
end

function SUBMODULE_DRAW.Think()
    local lastinput = BASE_MODULE["LastTextInput"] 
    local time = BASE_MODULE["Time"]
    local x,y = mouse.getPosition()
--    love.graphics.circle("fill",(x or 32),(y or 32),41*math.abs(math.cos(time/math.pi*0.5)))
    if (SUBMODULE_INPUT.NextUse or 0) < time and lastinput and love.keyboard.isDown(lastinput) then
        SUBMODULE_INPUT.CreatePhantomText(lastinput or 1)
        SUBMODULE_INPUT.NextUse = time + 0.3
    end
    if love.mouse.isDown(1) then
        SUBMODULE_INPUT.CreatePhantomText(lastinput or 1,x,y)
    end
    if BASE_MODULE.ActiveMode then
        WAVE:Start()
    end
    tiles:Think()
    SUBMODULE_INPUT.ThinkPhantoms()
    BASE_ENEMY:Think()
    BASE_PROJ:Think()
    BUTTON.ThinkButtons()
    for k,v in pairs(nextframes) do
        v()
    end
    nextframes = {}


    for k,v in pairs(nextframes2) do
        if v[2] > 1 then
            v[2] = v[2] - 1
        else
            v[1]()
        end
    end
    nextframes2 = {}
    local x2,y2 = 0,0
    for k,button in pairs(BUTTONS_SUB) do
        local size = button.Size
        local img = button.img 
        x2,y2 = size['x'], size['y']
        if img then
            x2 = x2 + img:getWidth()
            y2 = y2 + img:getHeight()
        end
       if x < button.Position.x + x2 and x > button.Position.x and y < button.Position.y + y2 and y > button.Position.y then
            if button.OnSeen then
                button.OnSeen(love.mouse.getX(),love.mouse.getY())
            end
       end
    end
end

function SUBMODULE_INPUT.CreatePhantomText(text,x,y)
    local x2,y2 = love.graphics.getDimensions()
    local x,y = x or math.random(0,x2),y or math.random(0,y2)
    love.graphics.print(text,x,y)
    PHANTOMS[#PHANTOMS + 1] = {text,x,y,BASE_MODULE["Time"]+3}
end

function SUBMODULE_INPUT.ThinkPhantoms()
    local time = BASE_MODULE["Time"] 
    love.graphics.setFont(FONTS_MODULES["opensansc32"])
    for k,v in pairs(PHANTOMS) do
        if v[4] < time then
            PHANTOMS[k] = nil
        end
        local optimise = math.min(1,(v[4]-time)/3)
        love.graphics.setColor(1, 1, 1,optimise*1)
        love.graphics.print(v[1],v[2],v[3])
        love.graphics.setColor(1,1,1,1)
    end
    love.graphics.setFont(FONTS_MODULES["opensansc12"])
end
--FONTS
FONTS_MODULES = {}
function FONTS_MODULES.CreateFont(name, size, hinting, dpiscale)
    FONTS_MODULES[name..size] = love.graphics.newFont(name..".ttf",size)
end
FONTS_MODULES.CreateFont("opensansc",32)
FONTS_MODULES.CreateFont("opensansc",12)
FONTS_MODULES.CreateFont("opensansc",15)
fonts = FONTS_MODULES
--BUTTON
BUTTONS_SUB = {}
function BUTTON.AddButton(size,x,y,color,sizex,sizey,image, txt)
    local button = {}
    button["Position"] = {['x'] = x,['y'] = y}
    button["Size"] = {['x'] = sizex or size,['y'] = sizex or size}
    button["Color"] = color
    button["img"] = image
    if txt then
        button["txt"] = txt[1]
        button["xt"] = txt[2]
        button["yt"] = txt[3]
        button["colt"] = txt[4] or Color(255,255,255)
    end
    button.ID = #BUTTONS_SUB+1
    BUTTONS_SUB[button.ID] = button
    return button
end
function BUTTON.RemoveButton(id)
    BUTTONS_SUB[id] = nil
end
local fuse = WEAPONS.IDFusion
function BUTTON.ThinkButtons()
    size = {1,1}
    color = Color(2,2,2)

    for k,v in pairs(BUTTONS_SUB) do
  --      print_t(v)
        if v and v.Position then
            size = v.Size
            color = Copy(v.Color)
            local x,y = v.Position['x'], v.Position['y']
            love.graphics.setColor(color.r/255,color.g/255,color.b/255)
            if v.img then
                love.graphics.draw( v.img, x, y, 0, size.x, size.y)
            else
                love.graphics.rectangle( "fill", x, y, size['x'], size['y'] )
            end
            local mv = v.WeaponOnMe
            if mv and BASE_MODULE[mv.."_cd"] and BASE_MODULE[mv.."_cd"] > CurTime() then
                local cd = BASE_MODULE[mv.."_cd"]
                love.graphics.setColor(0.04,0.04,0.04,0.35)
                love.graphics.rectangle( "fill", x, y+64-64* (cd-CurTime())/(WEAPONS.BaseCD[mv] or 1), 64, 64 * (cd-CurTime())/(WEAPONS.BaseCD[mv] or 1))
            end
            if v.txt then
                love.graphics.setFont(FONTS_MODULES["opensansc15"])
                color = Copy(v.colt)
                love.graphics.setColor(color.r/255,color.g/255,color.b/255)
                love.graphics.print(v.txt,x + v.xt ,y + v.yt)
                love.graphics.setFont(FONTS_MODULES["opensansc12"])
            end
            love.graphics.setColor(1, 1, 1,1)
            if v.Think then
                v.Think()
            end
        end
    end
end