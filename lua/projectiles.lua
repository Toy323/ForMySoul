BASE_PROJ = {}
projectiles = {}
PROJECTILE = {}
PROJECTILE.Size = {x = 48,y = 48}
require("lua/table_enc")
BASE_PROJ.projectilesList = {
    ["Normal"] = {
        Damage = 5,
        FlySpeed = 500,
        Color = Color(161,0,176),
        Size = 12
    },
    ["LBall"] = {
        Damage = 50,
        FlySpeed = 70,
        Color = Color(0,138,176),
        Size = 60,
        OnContact = function(self, enemy)
            enemy:TakeDamage(self.Damage or 30)
            self.Damage = self.Damage - 15
            self.Size = {x= self.Size.x - 12,y = self.Size.y - 12}
            self.Pierces  = self.Pierces  + 1
            if  self.Pierces > 2 then
                self:Remove()
            end
        end
    },
    ["Frizer"] = {
        Damage = 10,
        FlySpeed = 350,
        Color = Color(0,138,176),
        Size = 12,
        OnContact = function(self, enemy)
            enemy:TakeDamage(self.Damage or 30, "Ice")
            enemy.MaxFreezes = (enemy.MaxFreezes or 0) + 1
            if enemy.MaxFreezes < 5 then
                enemy:SetSpeed(enemy:GetSpeed()*0.85)
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
        end
    },
    ["Shield"] = {
        Damage = 500,
        FlySpeed = 40,
        Color = Color(0,138,176),
        Size = 200,
        OnContact = function(self, enemy)
            local olddmg = self.Damage
            self.Damage = math.max(-0.01,olddmg - math.abs(enemy:GetHealth()))
            enemy:TakeDamage(olddmg or 30)
            if self.Damage < 0 then
                self:Remove()
            end
        end,
        Init = function(self)
            self.Size.x = 50
        end
    },
}
function PROJECTILE:Think()
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
        enemy:TakeDamage(self.Damage or 5)
    end
    self:Remove()
end
function PROJECTILE:Remove()
    self:OnRemove()
    self.Phys.b:destroy()
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

    self.Damage = abs.Damage or 5
    if abs.Init then
        abs.Init(self)
    end

    static = {}
    static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
    static.b:setMass(0)
    static.s = love.physics.newRectangleShape(self.Size.x + 24,self.Size.y + 48)       
    static.f = love.physics.newFixture(static.b, static.s)
    static.f:setGroupIndex(-48)
    static.f:setUserData(tostring(self.ID))
    static.f:setRestitution(0.1) 
    self.Phys = static
    if abs.OnContact then
        self.OnContact = abs.OnContact
    end
    self.DieTime = CurTime()  + 30
end
function PROJECTILE:Walk(speed)
    self.Phys.b:setLinearVelocity(self:GetSpeed() * (speed or 1), self.YSpeed or 0)
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
        if v and v.Position then
            size = v.Size
            color = Copy(v.Color)
            pos = v.Phys and {x = v.Phys.b:getX(), y = v.Phys.b:getY()} or v.Position
            love.graphics.setColor(color.r/255,color.g/255,color.b/255)
            if v.img then
                love.graphics.draw( v.img, pos['x'], pos['y'], 0, size.x, size.y)
            else
                love.graphics.rectangle( "fill", pos.x, pos.y, size['x'], size['y'] )
            end
            love.graphics.print((v.Damage or 5), pos['x'] - 24,pos['y'] - 44)
            love.graphics.setColor(1, 1, 1, 1)
            if v.Think then
                v:Think()
            end
        end
    end
end