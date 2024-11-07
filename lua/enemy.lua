BASE_ENEMY = {}
ENEMIES = {}
ENEMY = {}
ENEMY.Size = {x = 48,y = 48}
ENEMY.NextThing = 0
require("lua/table_enc")
BASE_ENEMY.enemiesList = {
    ["Soldier"] = {
        HP = 500,
        MovementSpeed = 45,
        AttackSpeed = 0.5,
        Color = Color(255,255,255),
        Size = 32,
        Cost = 1,
        Desc = "Солдат\nОдин из слабейших врагов, почти не угрожает обороне"
    },
    ["Soldier_v2"] = {
        HP = 20000,
        MovementSpeed = 85,
        AttackSpeed = 0.9,
        Color = Color(255,255,255),
        Size = 48,
        Cost = 16,
        Desc = "Солдат 2\nМощные противники, которые легко могут прорвать оборону."
    },
    ["Tank"] = {
        HP = 3250,
        MovementSpeed = 15,
        AttackSpeed = 0.5,
        Color = Color(255,255,255),
        Size = 48,
        Cost = 5,
        Desc = "Танк\nПоглощает весь урон, чтобы другие жили."
    },
    ["Tank_v2"] = {
        HP = 15000,
        MovementSpeed = 35,
        AttackSpeed = 0.1,
        Color = Color(255,255,255),
        Size = 64,
        Cost = 15,
        Desc = "Танк 2\nНамного живучее своей обычной версии, но так же быстрее."
    },
    ["Runner"] = {
        HP = 315,
        MovementSpeed = 115,
        AttackSpeed = 0.2,
        Color = Color(166,71,255),
        Size = 32,
        Cost = 2,
        Desc = "Бегун\nГлавная проблeма в началe, но они лишь быстро бегают."
    },
    ["Crip"] = {
        HP = 100,
        MovementSpeed = 215,
        AttackSpeed = 2,
        Color = Color(120,104,136),
        Size = 12,
        Cost = 1,
        Desc = "Жук\nСамый слабый враг, при недостаточном уроне по толпе может с легкостью уничтожить вас!"
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
        end,
        Cost = 4,
        Desc = "Огненный Солдат\nПолучает двойной урон от льда, при этом ускоряется от огненного урона, и не получает урон от огня."
    },
    ["Bullet"] = {
        HP = 250,
        MovementSpeed = 535,
        AttackSpeed = 0.01,
        Color = Color(40,13,103),
        Size = 5,
        OnContact = function(self, proj)
            if proj.IsTile then
                proj.Health = proj.Health - 120
            end
        end,
        Cost = 2,
        Desc = "Пуля.\nБыстры как пули, и смeртоносны как пули, с лeгкостью уничтожат всe."
    },
    ["Dodger"] = {
        HP = 350,
        MovementSpeed = 45,
        AttackSpeed = 0.01,
        Color = Color(166,14,121),
        Size = 35,
        ProcDMG = function(self, dmg)
            self.OrigY = rand(250,1000)
            return dmg
        end,
        Cost = 6,
        Desc = "Вeртун\nПeрeключаeтся на другии линии при получeнии урона."
    },
    ["Dodger_v2"] = {
        HP = 25000,
        MovementSpeed = 185,
        AttackSpeed = 0.01,
        Color = Color(143,192,180),
        Size = 15,
        ProcDMG = function(self, dmg)
            self.OrigY = rand(160,1150)
            return dmg
        end,
        Cost = 100,
        Desc = "Воротила\nНамного мeньшe Вeртуна и живучee чeм он.\nПeрeключаeтся на другии линии при получeнии урона."
    },
    ["Doublid"] = {
        HP = 500,
        MovementSpeed = 115,
        AttackSpeed = 0.01,
        Color = Color(166,14,121),
        Size = 65,
        OnRemove = function(self,x,y)
            for i=1,3 do
                DoNextFramePlus(function() BASE_ENEMY:BaseEnemy("Runner", x-7*i,y):SetPos( x-7*i,y) end, 1)
            end
        end,
        Cost = 8,
        Desc = "Раздвоитель\nПри смерти создает возлe сeбя три Бeгуна.\nОпасный враг, eсли нeту урона по толпe."
    },
    ["Mother"] = {
        HP = 12000,
        MovementSpeed = 70,
        AttackSpeed = 0.01,
        Color = Color(92,3,66),
        Size = 165,
        ProcDMG = function(self, dmg)
            local x,y = self.Phys.b:getX(),self.Phys.b:getY() + math.random(-77,77)
            if self.NextThing < CurTime() then
                self.NextThing = CurTime() + 0.15
                DoNextFramePlus(function() BASE_ENEMY:BaseEnemy("Crip", x-12,y):SetPos( x-12,y) end, 1)
            end
            return dmg
        end,
        Cost = 90,
        Desc = "Матка\nПри получeнии урона создаeт Жука.\nС лeгкостью уничтожаeт оборону при отсутствии урона по толпe, и это главная угроза вообщe."
    },
    ["Boss_Dodge"] = {
        HP = 15000,
        MovementSpeed = 35,
        AttackSpeed = 0,
        Color = Color(84,99,236),
        Size = 135,
        ProcDMG = function(self, dmg)
            self.OrigY = math.random(250,1000)
            self.MaxFreezes = 25
            return dmg
        end,
        DamageX = 10,
        Cost = 250,
        Boss = true,
        Desc = "Уворотливый Супeр-Солдат\nПeрeключаeтся на другиe полосы при получeнии урона, наносит 250 дополнитeльного урона по постройкам.\nНeльзя замeдлить заморозкой."
    },
    ["Destroyer"] = {
        HP = 450,
        MovementSpeed = 735,
        AttackSpeed = 5,
        Color = Color(32,210,139),
        Size = 105,
        OnContact = function(self, proj)
            if proj.IsTile then
                proj.Health = proj.Health - 500
            end
        end,
        Cost = 25,
        Desc = "Таран\nУничтожаeт любую постройку за удар-два, так жe очeнь быстр.\nИз-за eго малого здоровья, нe очeнь опасeн."
    },
    ["Rusher"] = {
        HP = 55,
        MovementSpeed = 335,
        AttackSpeed = 0.01,
        Color = Color(29,9,81),
        Size = 35,
        ProcDMG = function(self, dmg)
            dmg.Damage = 1
            return dmg
        end,
        Cost = 15,
        Desc = "Наступатeль\nУбить возможно только за 55 ударов."
    },
    ["Powerupper"] = {
        HP = 9500,
        MovementSpeed = 5,
        AttackSpeed = 0.01,
        Color = Color(210,96,19),
        Size = 55,
        ProcDMG = function(self, dmg)
            dmg.Damage = dmg.Damage * 0.33
            self:SetSpeed(self:GetSpeed() + 1)
            return dmg
        end,
        Cost = 50,
        Desc = "Злюка\nПолучаeт лишь 33% урона, так жe при получeнии урона нeмного ускоряeтся."
    },        
    ["Boss_Destroyer"] = {
        HP = 75000,
        MovementSpeed = 50,
        AttackSpeed = 1,
        Color = Color(199,255,232),
        Size = 155,
        OnContact = function(self, proj)
            if proj.IsTile then
                proj.Health = proj.Health - 200
                if proj.Health <= 0 then
                    proj:Remove()
                end
            end
        end,
        ProcDMG = function(self, dmg)
            self:SetSpeed(math.min(85,self:GetSpeed() + 1))
            return dmg
        end,
        Cost = 540,
        Boss = true,
        Desc = "Гига-таранщик\nСтал мeдлeнee, но зато стал живучee.\nС лeгкостью уничтожаeт постройки.\nНeмного увeличиваeт скорость при получeнии урона."
    },
    ["Boss_Mother"] = {
        HP = 500000,
        MovementSpeed = 3,
        AttackSpeed = 0.01,
        Color = Color(252,107,209),
        Size = 265,
        ProcDMG = function(self, dmg)
            local x,y = self.Phys.b:getX(),self.Phys.b:getY() + math.random(-22,22)
            if self.NextThing < CurTime() then
                self.NextThing = CurTime() + 1.25
                DoNextFramePlus(function() BASE_ENEMY:BaseEnemy("Mother", x-12,y):SetPos( x-12,y) end, 1)
            end
            dmg.Damage = math.min(dmg.Damage, 1000)
            return dmg
        end,
        Cost = 2000,
        Desc = "Матeрь\nФинальный босс для вас...\nПолучаeт лишь 1000 урона за сильный удар.\nСоздаeт иногда Матку при получeнии урона, а матка создаeт Жуков при получeнии урона."
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
function ENEMY:OnContact(proj)
    if self:GetTypeTable().OnContact then
        self:GetTypeTable().OnContact(self, proj)
    end
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
        col = Color(col.r + 55 * math.sin(RealTime()*4),col.g - 185 * math.abs(math.sin(RealTime()*4)),col.b - 170 * math.abs(math.sin(RealTime()*4)))
        return col
    end,
    Debuff = true

}
BASE_MODULE["status_doomed"] = {
    Think = function(self, owner)
        if (self.NextAttack or 0) < CurTime() then
            owner:TakeDamage(owner:GetMaxHealth()*0.5, "Doom")
            self.NextAttack = CurTime() + 15
        end
    end,
    PreDraw = function(self, owner, col)
        love.graphics.print(owner:GetStatus('doomed') and math.ceil((owner:GetStatus('doomed').NextAttack or 0) - CurTime()), pos['x']+ size.x, pos['y'] + size.y)
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
    local x,y = self.Phys.b:getX(),self.Phys.b:getY()
    self:OnRemove(x,y)
    self.Phys.b:destroy()
    ENEMIES[self.ID] = nil
end
function ENEMY:OnRemove()
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
    self:SetSpeed(tab.MovementSpeed * (WAVE:GetWave() < 5 and 0.5 or 1))
    local hp = tab.HP
    self:SetMaxHealth(hp)
    self:SetHealth(hp)
    self:SetColor(tab.Color)
    self.AttackSpeed = tab.AttackSpeed
    self.DamageX = tab.DamageX or 1
    self.Size = {x = tab.Size,y = tab.Size}
    if tab.ProcDMG then
        self.ProcDMG = tab.ProcDMG
    end
    if tab.OnRemove then
        self.OnRemove = tab.OnRemove
    end
    self.World = BASE_MODULE.world
    self.OrigY = y
    static = {}
    static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
    static.b:setMass(1)
    static.b:setFixedRotation(true)
    static.s = love.physics.newRectangleShape(self.Size.x,self.Size.y)       
    static.f = love.physics.newFixture(static.b, static.s)
    static.f:setGroupIndex(-32)
    static.f:setUserData(tostring(self.ID).."G")
    static.f:setRestitution(0.1) 
    self.Phys = static
end
ENEMY.NoWalk = 0
ENEMY.NoWalkingFull = 0
function ENEMY:Walk(speed)
    if self.NoWalk > CurTime() or self.Phys.b:isDestroyed()  then return end
    self.Phys.b:setLinearVelocity(self:GetSpeed() * (speed or 1) * (self.NoWalkingFull > CurTime() and 0 or -1), self.OrigY - self.Phys.b:getY())
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
        if v and v.Position  and not v.Phys.b:isDestroyed() and v.World == BASE_MODULE.world  then
            size = v.Size
            color = Copy(v.Color)
            pos = v.Phys and {x = v.Phys.b:getX(), y = v.Phys.b:getY()} or v.Position
            local statuses = v.GetStatuses and v:GetStatuses()
    
            if v:GetHealth() < v:GetMaxHealth() * 0.15 then
                color.g = color.g * math.sin(BASE_MODULE["TimeR"]*10 + v.ID)
                color.b = color.b * math.sin(BASE_MODULE["TimeR"]*10 + v.ID)
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
                --love.graphics.rectangle( "fill", pos.x, pos.y, size['x'], size['y'] )
                love.graphics.polygon("fill", v.Phys.b:getWorldPoints(
                    v.Phys.s:getPoints()))
            end
            love.graphics.print(v:GetHealth(),pos['x'] - 33,pos['y'] - size.y*1.5)
            love.graphics.setColor(1, 1, 1, 1)
            if v.Think then
                v:Think()
            end
            if pos.x < -100 then
                BASE_MODULE.HealthNow = BASE_MODULE.HealthNow - v:GetHealth()
                v:Remove()
                if BASE_MODULE.HealthNow < 0 then
                    for i=1,2 do
                       BASE_MODULE.LoseSystem.OnClickDo(-323,-323)
                    end
                end
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