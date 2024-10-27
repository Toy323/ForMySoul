BASE_ENEMY = {}
ENEMIES = {}
ENEMY = {}
ENEMY.Size = {x = 48,y = 48}
require("lua/table_enc")
BASE_ENEMY.enemiesList = {
    ["Soldier"] = {
        HP = 500,
        MovementSpeed = 45,
        AttackSpeed = 0.5,
        Color = Color(255,255,255),
        Size = 32
    },
    ["Tank"] = {
        HP = 3250,
        MovementSpeed = 15,
        AttackSpeed = 0.5,
        Color = Color(255,255,255),
        Size = 48
    },
    ["Runner"] = {
        HP = 315,
        MovementSpeed = 115,
        AttackSpeed = 0.2,
        Color = Color(166,71,255),
        Size = 32
    },
    ["Fireman"] = {
        HP = 1000,
        MovementSpeed = 35,
        AttackSpeed = 0.6,
        Color = Color(186,57,28),
        Size = 55,
        ProcDMG = function(self, dmg)
            if dmg.type == "Fire" then
                dmg.Damage = 0
                self:SetSpeed(self:GetSpeed() + 3)
            elseif dmg.type == "Ice" then
                dmg.Damage = dmg.Damage * 2
            end
            return dmg
        end
    },
}
function ENEMY:Think()
    self:Walk()
    --self:TakeDamage(0.07)
end
ENEMY.IsEnemy = true


function ENEMY:GetTypeTable()
    return BASE_ENEMY.enemiesList[self.EnemyType]
end
ENEMY.Statuses = {}
function ENEMY:GetStatuses()
    return self.Statuses
end
function ENEMY:GetStatus(st)
    return self.Statuses["status_"..st]
end
BASE_MODULE["status_burn"] = {
    Think = function(self, owner)
        if (self.NextAttack or 0) < CurTime() then
            owner:TakeDamage(owner:GetMaxHealth()*0.03*(self.Stacks or 1)*0.25, "Fire")
            self.NextAttack = CurTime() + 2
        end
    end,
    PreDraw = function(self, owner, col)
        col = Color(col.r + 25 * math.sin(CurTime()*4),col.g - 199 * math.abs(math.sin(CurTime()*4)),col.b - 199 * math.abs(math.sin(CurTime()*4)))
        return col
    end,
    Debuff = true

}
function ENEMY:GiveStatus(st)
    local sas = BASE_MODULE["status_"..st]
    if sas then
        local real = {}
        if self:GetStatus(st) then
            real = self:GetStatus(st)
        else
            local gs = Copy(sas)
            self.Statuses["status_"..st] = gs
            real = self.Statuses["status_"..st]
            if not real.SpawnTime then
                real.SpawnTime = CurTime()
            end
        end
        return real
    else
        print('STATUS '..st.." NOT FINDED!")
    end
end

function ENEMY:GetSpeed()
    return self.SpeedUnits
end
function ENEMY:SetSpeed(speed)
    self.SpeedUnits = speed
end

function ENEMY:ProcessDMG(dmginfo)
    local statuses = self:GetStatuses()
    if statuses then
        for k,v in pairs(statuses) do
            if v.ProcDMG then
                v.ProcDMG(v, self, dmginfo)
            end
        end
    end
    if self.ProcDMG then
        dmginfo = self:ProcDMG(dmginfo)
    end
    return dmginfo
end

function ENEMY:TakeDamage(dmg, type)
    dmginfo = {Damage = dmg, type = type or "Normal"}
    dmginfo = self:ProcessDMG(dmginfo)
    self:SetHealth(self:GetHealth() - dmginfo.Damage)
    if self:GetHealth() <= 0 then
        self:Remove()
    end
end
function ENEMY:Remove()
    self.Phys.b:destroy()
    ENEMIES[self.ID] = nil
end

function ENEMY:GetMaxHealth()
    return self.MaxHP
end
function ENEMY:SetMaxHealth(mhp)
    self.MaxHP = mhp
end

function ENEMY:GetHealth()
    return self.HPCurrent
end
function ENEMY:SetHealth(hp)
    self.HPCurrent = hp
end

function ENEMY:GetPos()
    return self.Position.x, self.Position.y
end
function ENEMY:SetPos(x, y)
    if self.Phys.b then
        self.Position = {}
        self.Position['x'] = x
        self.Position['y'] = y
    else
        local phys = self.Phys.b
        phys:setPosition(x,y)
    end
end

function ENEMY:GetColor()
    return self.Color
end
function ENEMY:SetColor(color)
    self.Color = color
end


function ENEMY:Initialize(x,y)
    local tab = self:GetTypeTable()
    self:SetSpeed(tab.MovementSpeed)
    local hp = tab.HP
    self:SetMaxHealth(hp)
    self:SetHealth(hp)
    self:SetColor(tab.Color)
    self.AttackSpeed = tab.AttackSpeed
    self.Size = {x = tab.Size,y = tab.Size}
    if tab.ProcDMG then
        self.ProcDMG = tab.ProcDMG
    end

    static = {}
    static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
    static.b:setMass(1)
    static.s = love.physics.newRectangleShape(self.Size.x,self.Size.y + 32)       
    static.f = love.physics.newFixture(static.b, static.s)
    static.f:setGroupIndex(-32)
    static.f:setUserData(tostring(self.ID).."G")
    static.f:setRestitution(0.1) 
    self.Phys = static
end
ENEMY.NoWalk = 0
function ENEMY:Walk(speed)
    if self.NoWalk > CurTime() then return end
    self.Phys.b:setLinearVelocity(self:GetSpeed() * -(speed or 1), 0)
end
function BASE_ENEMY:BaseEnemy(specifize, x,y)
    base = Copy(ENEMY)
    if BASE_ENEMY.enemiesList[specifize] then
        base.EnemyType = specifize
    else
        base.EnemyType = "Soldier"
    end
    base.ID = #ENEMIES + 1
    base:Initialize(x,y)
    ENEMIES[base.ID] = base
    return base
end


function BASE_ENEMY:Think()
    size = {1,1}
    color = Color(2,2,2)

    for k,v in pairs(ENEMIES) do
        if v and v.Position then
            size = v.Size
            color = Copy(v.Color)
            pos = v.Phys and {x = v.Phys.b:getX(), y = v.Phys.b:getY()} or v.Position
            local statuses = v.GetStatuses and v:GetStatuses()
    
            if v:GetHealth() < v:GetMaxHealth() * 0.5 then
                color.g = color.g * math.sin(BASE_MODULE["Time"]*10 + v.ID)
                color.b = color.b * math.sin(BASE_MODULE["Time"]*10 + v.ID)
            end
            if statuses then
                for k2,v2 in pairs(statuses) do
                    if v2.PreDraw then
                       color = v2.PreDraw(v2, v, color) or color
                    end
                end
            end
            love.graphics.setColor(color.r/255,color.g/255,color.b/255)
            if v.img then
                love.graphics.draw( v.img, pos['x'], pos['y'], 0, size.x, size.y)
            else
                love.graphics.rectangle( "fill", pos.x, pos.y, size['x'], size['y'] )
            end
            love.graphics.print(v:GetHealth(),pos['x'] - 33,pos['y'] - 44)
            love.graphics.setColor(1, 1, 1, 1)
            if v.Think then
                v:Think()
            end
            if statuses then
                for k2,v2 in pairs(statuses) do
                    if v2.Think then
                        v2.Think(v2, v)
                    end
                end
            end
        end
    end
end