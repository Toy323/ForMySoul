BASE_PROJ = {}
projectiles = {}
PROJECTILE = {}
PROJECTILE.Size = {x = 48,y = 48}
require("lua/table_enc")
BASE_PROJ.projectilesList = {
    ["Normal"] = {
        Damage = 12,
        FlySpeed = 500,
        Color = Color(161,0,176),
        Size = 12,
        SndOnHit = true
    },
    ["Silenced"] = {
        Damage = 12,
        FlySpeed = 700,
        Color = Color(67,67,67),
        Size = 25,
        SndOnHit = true,
        OnContact = function(self, enemy)
            if enemy and enemy.TakeDamage then
                enemy:TakeDamage(self.Damage or 5, "Normal")
                if self:GetTypeTable().SndOnHit then
                    local snd = PlaySound("damageSilencer",math.random(1,#BASE_MODULE.Sounds["damageSilencer"]))
                    if snd then
                        snd:setPitch(rand(1.2,1.4))
                    end
                end
                enemy.NextDig = (enemy.NextDig or CurTime()) + 7
            end
            self:Remove()
        end
    },
    ["S_Silencer"] = {
        Damage = 12,
        FlySpeed = 700,
        Color = Color(42,42,42),
        Size = 44,
        SndOnHit = true,
        OnContact = function(self, enemy)
            if enemy and enemy.TakeDamage then
                enemy:TakeDamage(self.Damage or 5, "Normal")
                if self:GetTypeTable().SndOnHit then
                    local snd = PlaySound("damageSilencer",math.random(1,#BASE_MODULE.Sounds["damageSilencer"]))
                    if snd then
                        snd:setPitch(rand(1.2,1.4))
                    end
                end
                enemy.NextDig = (enemy.NextDig or CurTime()) + 1
                enemy:GiveStatus('silence')
            end
            self:Remove()
        end
    },
    ["LBall"] = {
        Damage = 50,
        FlySpeed = 70,
        Color = Color(0,138,176),
        Size = 60,
        DMGType = "Energy",
        OnContact = function(self, enemy)
            enemy:TakeDamage(self.Damage or 30, self.DMGType)
            self.Damage = self.Damage - 15
            self.Size = {x= self.Size.x - 12,y = self.Size.y - 12}
            self.Pierces  = self.Pierces  + 1
            if  self.Pierces > 2 then
                self:Remove()
            end
            PlaySound("energySound",math.random(1,#BASE_MODULE.Sounds["energySound"]))
        end
    },
    ["MassDamage"] = {
        Damage = 7500,
        FlySpeed = 500,
        Color = Color(9,4,46),
        Size = 360,
        DMGType = "Destroying",
        OnContact = function(self, enemy)
            self.Phys.f:setCategory(4)
            enemy.Phys.f:setMask(4)
            enemy:TakeDamage(self.Damage or 30, self.DMGType)
        end
    },
    ["Explosive"] = {
        Damage = 300,
        FlySpeed = 0,
        Color = Color(69,14,8),
        Size = 12,
        DMGType = "Explosive",
        OnContact = function(self, enemy)
            self.Phys.f:setCategory(6)
            enemy.Phys.f:setMask(6)
            enemy:TakeDamage(self.Damage or 30, self.DMGType)
        end,
        Think = function(self)
            if BASE_MODULE.OnPause then return end
            self.Size.x = self.Size.x * 1.11
            self.Size.y = self.Size.y * 1.11
            local static = self.Phys
            static.s = love.physics.newRectangleShape(self.Size.x,self.Size.y)       
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-48)
            static.f:setUserData(tostring(self.ID))
            static.f:setRestitution(0.1) 
            self.Phys = static
            if self.Size.y > (self.MaxY or 560) then
                self:Remove()
            end
        end
    },
    ["Laser"] = {
        Damage = 150,
        FlySpeed = 0,
        Color = Color(39,203,192, 33),
        Size = 155,
        DMGType = "Laser",
        OnContact = function(self, enemy)
            enemy:TakeDamage(self.Damage or 30, self.DMGType)
        end,
        Init = function(self)
            self.Size.x = 5000
            DoNextFrame(function()
                self.DieTime = CurTime()  + 0.45
            end)
        end,
    },
    ["ExploBullet"] = {
        Damage = 25,
        FlySpeed = 550,
        Color = Color(176,0,0),
        Size = 25,
        OnContact = function(self, enemy)
            enemy:TakeDamage(self.Damage or 30, "Explosive")
            if self.Phys.b then
                local x,y = self.Phys.b:getX(), self.Phys.b:getY()
                DoNextFrame(function()
                    local proj = BASE_PROJ:BasePROJ("Explosive",x,y)
                    proj:SetPos(x,y)
                    proj.MaxY = 150
                    proj.Damage = 25
                    proj.DieTime = CurTime() + 3
                end)
            end
            self:Remove()
        end,
        SndOnHit = true
    },




    ["ExplosiveFire"] = {
        Damage = 300,
        FlySpeed = 0,
        Color = Color(138,97,46),
        Size = 12,
        DMGType = "ExplosiveFire",
        OnContact = function(self, enemy)
            self.Phys.f:setCategory(6)
            enemy.Phys.f:setMask(6)
            local burn = enemy:GiveStatus('burn')
            burn.Stacks = (burn.Stacks or 0) + 1
            enemy:TakeDamage(self.Damage or 30, self.DMGType)
        end,
        Think = function(self)
            if BASE_MODULE.OnPause then return end
            self.Size.x = self.Size.x * 1.13
            self.Size.y = self.Size.y * 1.13
            local static = self.Phys
            static.s = love.physics.newRectangleShape(self.Size.x,self.Size.y)       
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-48)
            static.f:setUserData(tostring(self.ID))
            static.f:setRestitution(0.1) 
            self.Phys = static
            if self.Size.y > (self.MaxY or 560) then
                self:Remove()
            end
        end
    },
    ["ExploBulletF"] = {
        Damage = 25,
        FlySpeed = 550,
        Color = Color(176,73,0),
        Size = 44,
        OnContact = function(self, enemy)
            enemy:TakeDamage(self.Damage or 30, "Fire")
            if self.Phys.b then
                local x,y = self.Phys.b:getX(), self.Phys.b:getY()
                DoNextFrame(function()
                    local proj = BASE_PROJ:BasePROJ("ExplosiveFire",x,y)
                    proj:SetPos(x,y)
                    proj.MaxY = 140
                    proj.Damage = 33
                    proj.DieTime = CurTime() + 3
                end)
            end
            self:Remove()
        end,
        SndOnHit = true
    },
    
    ["Frizer"] = {
        Damage = 10,
        FlySpeed = 350,
        Color = Color(0,138,176),
        Size = 12,
        DMGType = "Ice",
        OnContact = function(self, enemy)
            local desert = BASE_MODULE.Location == "Desert"
            enemy:TakeDamage(self.Damage or 30, desert and "Water" or "Ice")
            if not desert then
                enemy.MaxFreezes = (enemy.MaxFreezes or 0) + 1
                if enemy.MaxFreezes < 5 then
                    enemy:SetSpeed(enemy:GetSpeed()*0.85)
                end
            else
                enemy:GiveStatus("sap")
            end
            self:Remove()
        end
    },
    ["FireNormal"] = {
        Damage = 0,
        FlySpeed = 600,
        Color = Color(212,63,26),
        Size = 12,
        OnContact = function(self, enemy)
            local burn = enemy:GiveStatus('burn')
            burn.Stacks = (burn.Stacks or 0) + 1
            self:Remove()
        end,
        Think = function(self)
            if self.Phys.b:isDestroyed() or (self.NextP or 0) > RealTime() then return end
            self.NextP = RealTime() + 0.02
            local b = self.Phys.b
            local lf = 0.4/BASE_MODULE["SpeedMul"]
            local ctime = lf + RealTime()
            local size = rand(3,6)
            local g = PARCB:New(Color(199,102,18), lf, size, {x = b:getX(), y = b:getY()})
            if g then
                g.Think = function()
                    g.Size.x = size*((ctime-RealTime())/lf)*2
                    g.Position.y = g.Position.y + rand(-6, 6) 
                    g.Position.x = g.Position.x - rand(-10,10) 
                end
            end
        end,
    },
    ["Gas"] = {
        Damage = 25,
        FlySpeed = 800,
        Color = Color(35,26,212),
        Size = 44,
        OnContact = function(self, enemy)
            enemy:TakeDamage(self.Damage, "Gas")
            if enemy.NoWalk > CurTime() then
                return
            end
            
            enemy.NoWalk = CurTime() + 0.5
            self:Remove()
            if enemy.Phys.b and not enemy.Phys.b:isDestroyed() then
                enemy.Phys.b:setLinearVelocity(0, 0)
            end
            
        end
    },
    ["Shield"] = {
        Damage = 500,
        FlySpeed = 40,
        Color = Color(0,138,176),
        Size = 200,
        DMGType = "Energy",
        OnContact = function(self, enemy)
            local olddmg = self.Damage
            self.Damage = math.max(-0.01,olddmg - math.abs(enemy:GetHealth()))
            enemy:TakeDamage(olddmg or 30, self.DMGType)
            if self.Damage < 0 then
                self:Remove()
            end
        end,
        Init = function(self)
            self.Size.x = 50
        end
    },
    ["Bumrang"] = {
        Damage = 650,
        FlySpeed = 640,
        Color = Color(0,138,176),
        Size = 20,
        DMGType = "Normal",
        Init = function(self)
            self.Size.x = 70
        end,
        InitB = function(self)
            self.Phys.b:setFixedRotation(false)
            self.DieTime = CurTime()  + 530
            self.Phys.b:applyTorque(666120)
        end,
        SndOnHit = true
    },
    ["RagingBullet"] = {
        Damage = 5,
        FlySpeed = 120,
        Color = Color(176,0,0),
        Size = 95,
        DMGType = "Psy",
        OnContact = function(self, enemy)
            local olddmg = self.Damage
            self.Damage = math.max(-0.01,olddmg - math.abs(enemy:GetHealth()))
            enemy:TakeDamage(olddmg or 30, self.DMGType)
            if self.Damage < 0 then
                self:Remove()
            end
        end,
        Init = function(self)
            self.Size.x = 20
        end
    },
    ["Chains"] = {
        Damage = 30,
        FlySpeed = 240,
        Color = Color(108,108,108),
        Size = 95,
        DMGType = "Physics",
        OnContact = function(self, enemy)
            local olddmg = self.Damage
            if not enemy:GetTypeTable().Boss then
                enemy.NoWalkingFull = CurTime() + 3
            end
            enemy:TakeDamage(olddmg or 30, self.DMGType)
            self:Remove()
        end,
        Init = function(self)
            self.Size.x = 20
        end, 
        SndOnHit = true
    },
    ["DoomBall"] = {
        Damage = 0,
        FlySpeed = 20,
        Color = Color(0,0,0),
        Size = 1500,
        OnContact = function(self, enemy)
            self.Phys.f:setCategory(5)
            enemy.Phys.f:setMask(5)
            local burn = enemy:GiveStatus('doomed')
        end,
        predraw = function()
            love.graphics.setShader(myShader)
        end,
        Think = function()
            love.graphics.setShader()
        end
    },
}
function PROJECTILE:Think()
    if self.AddThink then
        self:AddThink()
    end
    self:Walk()
end
PROJECTILE.IsProjectile = true
PROJECTILE.Pierces = 0

function PROJECTILE:GetTypeTable()
    return BASE_PROJ.projectilesList[self.PROJECTILEType]
end

function PROJECTILE:GetSpeed()
    return self.SpeedUnits
end
function PROJECTILE:SetSpeed(speed)
    self.SpeedUnits = speed
end

function PROJECTILE:ProcessDMG(dmginfo)
    return dmginfo
end

function PROJECTILE:OnContact(enemy)
    if enemy and enemy.TakeDamage then
        enemy:TakeDamage(self.Damage or 5, self:GetTypeTable() and self:GetTypeTable().DMGType or "Normal")
        if self:GetTypeTable().SndOnHit then
            local snd = PlaySound("damageDeal",math.random(1,#BASE_MODULE.Sounds["damageDeal"]))
            if snd then
                snd:setPitch(rand(1.2,1.4))
            end
        end
    end
    self:Remove()
end
function PROJECTILE:Remove()
    self:OnRemove()
    if not self.Phys.b:isDestroyed() then
        self.Phys.b:destroy()
    end
    if not self.Phys.f:isDestroyed() then
        self.Phys.f:destroy()
    end
    self.Removed = true
    self.Phys = nil
    projectiles[self.ID] = nil
    self = nil
end
function PROJECTILE:OnRemove()
end
function PROJECTILE:GetPos()
    return self.Position.x, self.Position.y
end
function PROJECTILE:SetPos(x, y)
    if self.Phys.b then
        self.Position = {}
        self.Position['x'] = x
        self.Position['y'] = y
    else
        local phys = self.Phys.b
        phys:setPosition(x,y)
    end
end

function PROJECTILE:GetColor()
    return self.Color
end
function PROJECTILE:SetColor(color)
    self.Color = color
end


function PROJECTILE:Initialize(x,y)
    local abs = self:GetTypeTable()
    self:SetSpeed(abs.FlySpeed)
    self:SetColor(self:GetTypeTable().Color)
    self.Size = {x = abs.Size,y = abs.Size}
    self.DMGType = self:GetTypeTable() and self:GetTypeTable().DMGType or "Normal"

    self.Damage = abs.Damage or 5
    if abs.Init then
        abs.Init(self)
    end
    if abs.Think then
        self.AddThink = abs.Think
    end
    self.World = BASE_MODULE.world
    static = {}
    static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
    static.b:setMass(0)
    static.b:setFixedRotation(true)
    static.s = love.physics.newRectangleShape(self.Size.x,self.Size.y)       
    static.f = love.physics.newFixture(static.b, static.s)
    static.f:setGroupIndex(-48)
    static.f:setUserData(tostring(self.ID))
    static.f:setRestitution(0.1) 
    self.Phys = static
    if abs.OnContact then
        self.OnContact = abs.OnContact
    end
    self.DieTime = CurTime()  + 30
    if abs.InitB then
        abs.InitB(self)
    end
    self.predraw = abs.predraw
end
function PROJECTILE:Walk(speed)
    if self.Phys and self.Phys.b and not self.Removed and not self.Phys.b:isDestroyed() then
        self.Phys.b:setLinearVelocity(self:GetSpeed() * (speed or 1), self.YSpeed or 0)
    end
    if self.DieTime < CurTime() and not self.Removed then
        self:Remove()
    end
end
function BASE_PROJ:BasePROJ(specifize, x,y)
    base = Copy(PROJECTILE)
    if BASE_PROJ.projectilesList[specifize] then
        base.PROJECTILEType = specifize
    else
        base.PROJECTILEType = "Normal"
    end
    base.ID = #projectiles + 1
    base:Initialize(x,y)
    projectiles[base.ID] = base
    return base
end


function BASE_PROJ:Think()
    size = {1,1}
    color = Color(2,2,2)

    for k,v in pairs(projectiles) do
        if v and v.Position and not v.Removed and not v.Phys.b:isDestroyed() and v.Phys.b and v.World == BASE_MODULE.world then
            size = v.Size
            color = Copy(v.Color)
            pos = v.Phys and {x = v.Phys.b:getX(), y = v.Phys.b:getY()} or v.Position
            love.graphics.setColor(color.r/255,color.g/255,color.b/255, (color.a or 255)/255)
            if v.predraw then
                v:predraw(pos)
            end
            if v.img then
                love.graphics.draw( v.img, pos['x'], pos['y'], 0, size.x, size.y)
            else
                --love.graphics.rectangle( "fill", pos.x, pos.y, size['x'], size['y'] )
                love.graphics.polygon("fill", v.Phys.b:getWorldPoints(
                           v.Phys.s:getPoints()))
            end
            love.graphics.print((v.Damage or 5), pos['x'] - 24 - size.x,pos['y'] - 44)
            love.graphics.setColor(1, 1, 1, 1)
            if v.Think then
                v:Think()
            end
        end
    end
end