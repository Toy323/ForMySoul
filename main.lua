BASE_MODULE = {}
BASE_MODULE.Time = 0
BASE_MODULE.Version = "0.0.1.6"
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
    return {['r'] = r,['g'] = g,['b'] = b,['a'] = a}
end
require('lua/table_enc')
require('lua/middleclass')
require('lua/tilemap')
require('lua/enemy')
require('lua/projectiles')



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
        local enemy = string.sub(b:getUserData(), #b:getUserData()) == "G" and ENEMIES[tonumber(string.sub(b:getUserData(), 0, #b:getUserData()-1))] or string.sub(a:getUserData(), #a:getUserData()) == "G" and ENEMIES[tonumber(string.sub(a:getUserData(), 0, #a:getUserData()-1))]
        local proj = string.sub(b:getUserData(), #b:getUserData()) ~= "G" and projectiles[tonumber(b:getUserData())] or projectiles[tonumber(a:getUserData())] or tilesblock[tonumber(a:getUserData())] or tilesblock[tonumber(b:getUserData())]
        if proj and proj.OnContact and enemy then
            proj:OnContact(enemy)
        end
        if enemy and enemy.OnContact and not proj.IsTile then
            enemy:OnContact(proj)
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
local innerF = {
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 1.9
            for i=1,3 do
                local x,y = self.Position["x"],self.Position['y']
                local proj = BASE_PROJ:BasePROJ(nil,x,y)
                proj.YSpeed = i == 1 and -60 or i == 2 and 60 or 0
                proj:SetPos(x,y)
            end
            
        end
    end,

    function(self)
        if self.NextShoot < CurTime() -((self.NoShoot or 0)%3 == 0 and 3 or 0) then
            self.NextShoot = CurTime() + 0.12
            local x,y = self.Position["x"] ,self.Position['y'] 
            local proj = BASE_PROJ:BasePROJ("Frizer",x,y)
            proj:SetPos(x,y)
            self.NoShoot = (self.NoShoot or 0) + 1
        end
    end,

    function(self)
        if self.NextShoot < CurTime()  then
            self.NextShoot = CurTime() + 25
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Shield",x,y)
            proj:SetPos(x,y)
        end
    end,

    function(self)
        if self.NextShoot < CurTime()  then
            self.NextShoot = CurTime() + 0.9
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ(nil,x,y)
            proj:SetPos(x,y)
            proj:SetSpeed(240)
            proj.Damage = 15
            proj.Think = function()
                proj.YSpeed = 60 * math.sin(CurTime() + proj.ID*4)
                proj:Walk()
            end
        end
    end,

    function(self)
        if self.NextShoot < CurTime() -((self.NoShoot or 0)%12 == 0 and 6 or 0) then
            self.NextShoot = CurTime() + 0.04
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Normal",x,y)
            proj:SetPos(x,y)
            proj.Damage = 4
            self.NoShoot = (self.NoShoot or 0) + 1
        end
    end,

    function(self)
        self.LifeTime = (self.LifeTime or 0) + 0.001
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 1.9
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Normal",x,y)
            proj:SetPos(x,y)
            proj.Damage = math.floor(self.LifeTime*50)/50
            proj:SetSpeed(300 - math.min(150, self.LifeTime))
        end
    end,

    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 12
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("LBall",x,y)
            proj:SetPos(x,y)
        end
    end,
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 0.2
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ(nil,x,y)
            proj:SetPos(x,y)
            proj.DieTime = CurTime() + 0.4
        end
    end,
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 2.5
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("FireNormal",x,y)
            proj:SetPos(x,y)
            proj.DieTime = CurTime() + 12
        end
    end,
}
local colBullet = Color(133,16,88)
local images = {
    {love.graphics.newImage('images/tripla.png'), colBullet},
    {love.graphics.newImage('images/friza.png'), Color(41,241,221)},
    {love.graphics.newImage('images/shield.png'), Color(255,255,255)},
    {love.graphics.newImage('images/sinusoid.png'), colBullet},
    {love.graphics.newImage('images/charger.png'), colBullet},
    {love.graphics.newImage('images/powerer.png'), colBullet},
    {love.graphics.newImage('images/lballer.png'), Color(0,56,141)},
}
function love.load()
    print(love.window.getFullscreen())
    love.window.setFullscreen(true)
    love.window.setTitle("Doset Vs Dosei v"..BASE_MODULE.Version)

    local cache = {}
    
    local oldy,oldx = 66, 1222
    local button = BUTTON.AddButton(1,oldx,oldy,Color(220,128,79),1,1, bim)
    local oldid = button.ID
    button.OnClickDo = function(x,y)
        if SELECTED_TOOL ~= button then
            SELECTED_TOOL = button
        else
            if #cache == 0 then
                love.load()
                BUTTON.RemoveButton(oldid)
            else
                for k,v in pairs(cache) do
                    BUTTON.RemoveButton(v)
                end
                cache = {}
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
    --table.insert(cache,button.ID)

    for i=1,9 do
        local img = images[i] and images[i][1] or nil
        local button = BUTTON.AddButton(48,64 + 64 * i,66, img and images[i][2] or Color(51,167,169), img and 1, img and 1, img)
        BASE_MODULE["ButtonOn"..i] = button
        button.OnClickDo = function(x,y)
            if SELECTED_TOOL ~= button then
                SELECTED_TOOL = button
            else
                SELECTED_TOOL = 0 
                local finded = false
                for k,v in pairs(tilesblock) do
                    if x < v.Position.x + (v.Size or 2)*1.5  and x > v.Position.x and y < v.Position.y + (v.Size or 2)*1.5 and y > v.Position.y then
                        v:SetColor(Color(5 + 10*i,74,20 + i*30))
                        finded = true
                        v.NextShoot = CurTime() + 1.1
                        v:AddCollision()
                        v.Think = innerF[i] or function()
                            if v.NextShoot < CurTime() then
                                v.NextShoot = CurTime() + 1.6
                                BASE_PROJ:BasePROJ(nil, x,y):SetPos(x,y)
                            end
                        end
                        v.OnRemove = function(self,x,y)
                            tile:Create(x,y,125/2,Color(156,215,96))
                        end
                        break 
                    end
                end
                if not finded then
                    if i == 2 or i == 3 then
                        BASE_PROJ:BasePROJ(i == 3 and "LBall", x,y):SetPos(x,y)
                    else
                        BASE_ENEMY:BaseEnemy(i == 1 and "Tank" or i == 4 and "Runner" or i == 5 and "Fireman", x,y):SetPos(x,y)
                    end
                end
            end
        end
        button.Think = function()
            if SELECTED_TOOL == button then
                button.Position.x = love.mouse.getX() - 32
                button.Position.y =  love.mouse.getY() - 32
            else
                button.Position.x = 64 + 64 * i
                button.Position.y =  66
            end
        end
        table.insert(cache,button.ID)
    end
    
    BASE_MODULE.ButtonOnMinus = button

    BASE_MODULE.world = love.physics.newWorld(0, 0, true) 

    BASE_MODULE.world:setContactFilter(filtercol)
    BASE_MODULE.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
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

    tiles:CreateMapFull(0,320,5,125, FORMULA_PARALEP_R, 12, Color(156,215,96))
end
function love.update(time)
    BASE_MODULE["Time"] = (BASE_MODULE["Time"] or 0) + time
    BASE_MODULE.world:update(time)
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
    love.graphics.setBackgroundColor(0.02,0.3,0)
    love.graphics.print("huh",32,32)
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
    tiles:Think()
    SUBMODULE_INPUT.ThinkPhantoms()
    BUTTON.ThinkButtons()
    BASE_ENEMY:Think()
    BASE_PROJ:Think()
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
fonts = FONTS_MODULES
--BUTTON
BUTTONS_SUB = {}
function BUTTON.AddButton(size,x,y,color,sizex,sizey,image)
    local button = {}
    button["Position"] = {['x'] = x,['y'] = y}
    button["Size"] = {['x'] = sizex or size,['y'] = sizex or size}
    button["Color"] = color
    button["img"] = image
    button.ID = #BUTTONS_SUB+1
    BUTTONS_SUB[button.ID] = button
    return button
end
function BUTTON.RemoveButton(id)
    BUTTONS_SUB[id] = nil
end
function BUTTON.ThinkButtons()
    size = {1,1}
    color = Color(2,2,2)

    for k,v in pairs(BUTTONS_SUB) do
  --      print_t(v)
        if v and v.Position then
            size = v.Size
            color = v.Color
            love.graphics.setColor(color.r/255,color.g/255,color.b/255)
            if v.img then
                love.graphics.draw( v.img, v.Position['x'], v.Position['y'], 0, size.x, size.y)
            else
                love.graphics.rectangle( "fill", v.Position.x, v.Position.y, size['x'], size['y'] )
            end
            love.graphics.setColor(1, 1, 1,1)
            if v.Think then
                v.Think()
            end
        end
    end
end