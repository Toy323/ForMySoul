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
        Face = love.graphics.newImage('images/enemy/des_face.png'),
        Desc = "Гига-таранщик\nСтал мeдлeнee, но зато стал живучee.\nС лeгкостью уничтожаeт постройки.\nНeмного увeличиваeт скорость при получeнии урона."
    },
    ["Boss_Mother"] = {
        HP = 500000,
        MovementSpeed = 3,
        AttackSpeed = 0.01,
        Color = Color(252,107,209),
        Size = 265,
        Boss = true,
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

--Враги пустыни
    ["Sir"] = {
        HP = 444,
        MovementSpeed = 66,
        AttackSpeed = 0.02,
        Color = Color(82,89,0),
        Size = 44,
        Cost = 7,
        Desc = "Сержант\nОдин из слабейших врагов в пустыне, почти не угрожает обороне, но атакует быстро.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(32)
            static.s = love.physics.newPolygonShape( 44, -22, 44, 22, -44, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end
    },

    ["Slowdowner"] = {
        HP = 2100,
        MovementSpeed = 44,
        AttackSpeed = 0.02,
        Color = Color(41,229,182),
        Size = 88,
        Cost = 12,
        Desc = "Выкачиватель\nБольшой, но способен повышать задержку между атаками для некоторых сооружений при получении урона.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(32)            
            static.s = love.physics.newPolygonShape( 88, -44, 88, 44, -88, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        ProcDMG = function(self, dmg)
            local ac = tilesblock[rand(1,#tilesblock)] 
            if ac and ac.NextShoot then
                ac.NextShoot = ac.NextShoot + rand(0.2,6)
            end
            return dmg
        end,
    },
    ["Sundowner"] = {
        HP = 2500,
        MovementSpeed = 44,
        AttackSpeed = 0.02,
        Color = Color(4,11,34),
        Size = 88,
        Cost = 32,
        Desc = "Энергодав\nКрадет ресурсы при получении урона.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(128)
            static.s = love.physics.newPolygonShape( 88, -44, 88, 44, -88, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        ProcDMG = function(self, dmg)
            BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] - 1
            return dmg
        end,
    },
    ["Sundowner_Boss"] = {
        HP = 17500,
        MovementSpeed = 7,
        AttackSpeed = 0.02,
        Color = Color(56,66,96),
        Size = 100,
        Cost = 500,
        Boss = true,
        Desc = "Вор Ресурсов\nКрадет ресурсы при получении урона, проверка вашей экономики.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(256)
            static.s = love.physics.newPolygonShape( 100, -50, 100, 50, -100, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        ProcDMG = function(self, dmg)
            BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] - 10
            return dmg
        end,
    },
    ["Mayor"] = {
        HP = 2500,
        MovementSpeed = 66,
        AttackSpeed = 0.02,
        Color = Color(108,115,31),
        Size = 44,
        Cost = 22,
        Desc = "Майор\nСильнее сержанта,но в разы жирнее, почти не угрожает обороне, но атакует быстро.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(128)
            static.s = love.physics.newPolygonShape( 44, -22, 44, 22, -44, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end
    },

    ["Mayor_dodger"] = {
        HP = 7500,
        MovementSpeed = 26,
        AttackSpeed = 0.02,
        Color = Color(108,115,31),
        Size = 22,
        Cost = 22,
        Desc = "Майор-воротила\nМеняет положение при получении урона и он мелкий.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(128)
            static.s = love.physics.newPolygonShape( 22, -11, 22, 11, -22, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        ProcDMG = function(self, dmg)
            self.OrigY = rand(160,1150)
            return dmg
        end,
    },

    ["Mayor_doublid"] = {
        HP = 2500,
        MovementSpeed = 30,
        AttackSpeed = 0.02,
        Color = Color(115,31,94),
        Size = 66,
        Cost = 44,
        Desc = "Майор-двоитель\nПри смерти создает 4 майора.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(128)
            static.s = love.physics.newPolygonShape( 66, -33, 66, 33, -66, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        OnRemove = function(self,x,y)
            for i=1,4 do
                DoNextFramePlus(function() BASE_ENEMY:BaseEnemy("Mayor", x-12*i,y):SetPos( x-12*i,y) end, 1)
            end
        end,

    },

    ["Dune_doublid"] = {
        HP = 10000,
        MovementSpeed = 22,
        AttackSpeed = 0.02,
        Color = Color(221,203,99),
        Size = 66,
        Cost = 60,
        Desc = "Пустынный-раздвоитель\nПри смерти создает 6 майор-двоителей.\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(true)
            static.b:setMass(128)
            static.s = love.physics.newPolygonShape( 66, -33, 66, 33, -66, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        OnRemove = function(self,x,y)
            for i=1,6 do
                DoNextFramePlus(function() BASE_ENEMY:BaseEnemy("Mayor_doublid", x-12*i,y):SetPos( x-12*i,y) end, 1)
            end
        end,

    },

    ["Dune_warrior"] = {
        HP = 8000,
        MovementSpeed = 112,
        AttackSpeed = 0.02,
        Color = Color(123,107,13),
        Size = 50,
        Cost = 35,
        Desc = "Воин Пустыни\nПолучает сопротивлению к определенному типу урона при получении урона(максимум 75%).\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(true)
            static.b:setMass(128)
            static.s = love.physics.newPolygonShape( 50, -25, 50, 25, -50, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        ProcDMG = function(self, dmg)
            if not  self.DamagesResist then
                self.DamagesResist = {}
            end
            if self.DamagesResist[dmg.type] then
                dmg.Damage = dmg.Damage * (1-self.DamagesResist[dmg.type])
            end
            self.DamagesResist[dmg.type] = math.min(0.75, self.DamagesResist[dmg.type] and self.DamagesResist[dmg.type] + 0.02 or 0.02)
            return dmg
        end,

    },
    ["Dune_warrior_boss"] = {
        HP = 50000,
        MovementSpeed = 22,
        AttackSpeed = 0.02,
        Color = Color(105,2,2),
        Size = 250,
        Cost = 3335,
        Boss = true,
        Desc = "Генерал-майор Пустыни\nПолучает сопротивлению к определенному типу урона при получении урона(максимум 85%).\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(true)
            static.b:setMass(128)
            static.s = love.physics.newPolygonShape( 250, -125, 250, 125, -250, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        ProcDMG = function(self, dmg)
            if not  self.DamagesResist then
                self.DamagesResist = {}
            end
            if self.DamagesResist[dmg.type] then
                dmg.Damage = dmg.Damage * (1-self.DamagesResist[dmg.type])
            end
            self.DamagesResist[dmg.type] = math.min(0.95, self.DamagesResist[dmg.type] and self.DamagesResist[dmg.type] + 0.01 or 0.01)
            return dmg
        end,
        OnContact = function(self, proj)
            if proj.IsTile then
                proj.Health = proj.Health - 100
                if proj.Health <= 0 then
                    proj:Remove()
                end
            end
        end,

    },
    ["Dune_warrior_boss2"] = {
        HP = 750000,
        MovementSpeed = 3,
        AttackSpeed = 0.02,
        Color = Color(52,1,1),
        Size = 350,
        Cost = 10000,
        Boss = true,
        Face = love.graphics.newImage('images/enemy/ful_face.png'),
        Desc = "Главнокомандующий Воин Пустыни\nПолучает сопротивлению к определенному типу урона при получении урона(максимум 99%).\nБлагодаря своей форме может иногда проскальзывать сквозь оборону.\nФинальный босс пустыни.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(true)
            static.b:setMass(20000)
            static.s = love.physics.newPolygonShape( 350, -225, 350, 225, -350, 0 )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        ProcDMG = function(self, dmg)
            if not  self.DamagesResist then
                self.DamagesResist = {}
            end
            if self.DamagesResist[dmg.type] then
                dmg.Damage = dmg.Damage * (1-self.DamagesResist[dmg.type])
            end
            self.DamagesResist[dmg.type] = math.min(0.99, self.DamagesResist[dmg.type] and self.DamagesResist[dmg.type] + 0.01 or 0.01)
            return dmg
        end,
        OnContact = function(self, proj)
            if proj.IsTile then
                proj.Health = proj.Health - 600
                if proj.Health <= 0 then
                    proj:Remove()
                end
            end
        end,

    },
    --Graveyard
    ["General"] = {
        HP = 225,
        MovementSpeed = 72,
        AttackSpeed = 0.6,
        Color = Color(83,84,79),
        Size = 44,
        Cost = 3,
        Desc = "Генерал\nОдин из слабейших врагов на кладбище, почти не угрожает обороне, но их очeнь много.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,7) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-55,55)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end
    },

    ["General_mayor"] = {
        HP = 500,
        MovementSpeed = 52,
        AttackSpeed = 0.6,
        Color = Color(202,198,203),
        Size = 44,
        Cost = 9,
        Desc = "Генерал-майор\nПосле смерти создает генерала на своем месте.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,7) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-55,55)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        OnRemove = function(self,x,y)
            DoNextFrame(function() BASE_ENEMY:BaseEnemy("General", x,y):SetPos( x,y) end)
        end,

    },

    ["General_l"] = {
        HP = 900,
        MovementSpeed = 52,
        AttackSpeed = 0.6,
        Color = Color(0,0,0),
        Size = 44,
        Cost = 29,
        Desc = "Генерал-лейтенант\nПосле смерти создает генерал-майора на своем месте.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(3900)
            local bruh = {}
            for i=1,rand(3,7) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-99,99)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        OnRemove = function(self,x,y)
            DoNextFrame(function() BASE_ENEMY:BaseEnemy("General_mayor", x,y):SetPos( x,y) end)
        end,

    },
    ["General_bomb"] = {
        HP = 3000,
        MovementSpeed = 22,
        AttackSpeed = 0.1,
        Color = Color(59,19,19),
        Size = 44,
        Cost = 125,
        Desc = "Генерал-бомба\nПосле смерти создает 6 генерал-лейтенантов на своем месте.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(3900)
            local bruh = {}
            for i=1,rand(3,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-150,200)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
        end,
        OnRemove = function(self,x,y)
            for i=1,6 do
                DoNextFrame(function() BASE_ENEMY:BaseEnemy("General_l", x + i*32,y-i*2):SetPos( x + i*32,y-i*2) end)
            end
        end,

    },
    ["Gravedigger"] = {
        HP = 2000,
        MovementSpeed = 45,
        AttackSpeed = 0.1,
        Color = Color(47,71,179),
        Size = 55,
        Cost = 190,
        Desc = "Могильщик\nКаждые 15 секунд выкапывает пару врагов.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(0,50)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
            
            self.NextDig = CurTime() + 10
            self.Think = function()
                self:Walk()
                if self.NextDig < CurTime() and not self.Phys.b:isDestroyed() then
                    self.NextDig = CurTime() + 15
                    local x,y = self.Phys.b:getX(), self.Phys.b:getY()
                    for i=1,rand(1,5) do
                        DoNextFrame(function() BASE_ENEMY:BaseEnemy("General_mayor", x + i*32,y-i*2):SetPos( x + i*32,y-i*2) end)
                    end
                end
            end
        end,
    },
    ["Rando"] = {
        HP = 5000,
        MovementSpeed = 45,
        AttackSpeed = 0.1,
        Color = Color(193,115,219,111),
        Size = 100,
        Cost = 250,
        Desc = "Путник\nРаз в 12 секунд меняет всем врагам начальную позицию.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-100,100)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
            
            self.NextDig = CurTime() + 10
            self.Think = function()
                self:Walk()
                if self.NextDig < CurTime() and not self.Phys.b:isDestroyed() then
                    self.NextDig = CurTime() + 12
                    for k,v in pairs(ENEMIES) do
                        v.OrigY = rand(350,1000)
                    end
                end
            end
        end,
    },
    ["Hypnodance"] = {
        HP = 25000,
        MovementSpeed = 12,
        AttackSpeed = 0.1,
        Color = Color(81,11,105,82),
        Size = 100,
        Cost = 200,
        Desc = "Музыкальный безумец\nОчень медленный и жирный.\nПостоянно меняет всем врагам начальную позицию.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-100,100)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
            
            self.NextDig = CurTime() + 2
            self.Think = function()
                self:Walk()
                if self.NextDig < CurTime() and not self.Phys.b:isDestroyed() then
                    self.NextDig = CurTime() + 0.9
                    for k,v in pairs(ENEMIES) do
                        v.OrigY = rand(350,1000)
                    end
                end
            end
        end,
    },
    ["Healer"] = {
        HP = 12000,
        MovementSpeed = 50,
        AttackSpeed = 0.1,
        Color = Color(80,174,40,193),
        Size = 155,
        Cost = 120,
        Desc = "Лекарь\nОчень жирный.\nПостоянно лечит здоровье всем врагам на поле.\nПо 1.5% макс здоровья в 4 секунды.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(4,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-155,155)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
            
            self.NextDig = CurTime() + 2
            self.Think = function()
                self:Walk()
                if self.NextDig < CurTime() and not self.Phys.b:isDestroyed() then
                    self.NextDig = CurTime() + 4
                    for k,v in pairs(ENEMIES) do
                        if v then
                            v:SetHealth(math.min(v:GetMaxHealth(), v:GetHealth() + v:GetMaxHealth()*0.015))
                        end
                    end
                end
            end
        end,
    },
    ["Healer_mayor"] = {
        HP = 100000,
        MovementSpeed = 10,
        AttackSpeed = 0.1,
        Color = Color(29,79,7,193),
        Size = 200,
        Cost = 10000,
        Desc = "Главарь лекарей Досеитовой магии\nОчень жирный.\nПостоянно лечит здоровье всем врагам на поле.\nПо 25% макс здоровья в 1 секунду.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(false)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-300,300)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
            
            self.NextDig = CurTime() + 2
            self.Think = function()
                self:Walk()
                if self.NextDig < CurTime() and not self.Phys.b:isDestroyed() then
                    self.NextDig = CurTime() + 1
                    for k,v in pairs(ENEMIES) do
                        if v then
                            v:SetHealth(math.min(v:GetMaxHealth(), v:GetHealth() + v:GetMaxHealth()*0.25))
                        end
                    end
                end
            end
        end,
    },
    ["Gravedigger_boss"] = {
        HP = 25000,
        MovementSpeed = 55,
        AttackSpeed = 0.1,
        Boss = true,
        Color = Color(48,13,53),
        Size = 250,
        Cost = 5000,
        Desc = "Могильный оживитель\nКаждые 7 секунд выкапывает множество сильных врагов.\nИмеет случайную форму.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(true)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-250,250)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
            
            self.NextDig = CurTime() + 10
            self.Think = function()
                self:Walk()
                if self.NextDig < CurTime() and not self.Phys.b:isDestroyed() then
                    self.NextDig = CurTime() + 7
                    local x,y = self.Phys.b:getX(), self.Phys.b:getY()
                    for i=1,rand(3,8) do
                        DoNextFrame(function() BASE_ENEMY:BaseEnemy("General_bomb", x + i*32,y-i*2):SetPos( x + i*32,y-i*2) end)
                    end
                end
            end
        end,


    },
    ["Necro_boss"] = {
        HP = 250000,
        MovementSpeed = 12,
        AttackSpeed = 0.1,
        Boss = true,
        Color = Color(40,40,40),
        Size = 500,
        Cost = 50000,
        Desc = "Босс подмогильных фракций - Негромант\nКаждые 11 секунд выкапывает босса.\nИмеет случайную форму.\nФинальный босс кладбища.",
        Init = function(self, x,y)
            self.Phys.b:destroy()
            static = {}
            static.b = love.physics.newBody(BASE_MODULE.world, x,y, "dynamic")
            static.b:setFixedRotation(true)
            static.b:setMass(900)
            local bruh = {}
            for i=1,rand(3,5) do
                for i2=1,2 do
                    bruh[#bruh + 1] = rand(-500,500)
                end
            end
            static.s = love.physics.newPolygonShape( bruh )    
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setGroupIndex(-32)
            static.f:setUserData(tostring(self.ID).."G")
            static.f:setRestitution(1) 
            self.Phys = static
            
            self.NextDig = CurTime() + 10
            self.Think = function()
                self:Walk()
                if self.NextDig < CurTime() and not self.Phys.b:isDestroyed() then
                    self.NextDig = CurTime() + 11
                    local x,y = self.Phys.b:getX(), self.Phys.b:getY()
                    local rands = rand(1,6)
                    DoNextFrame(function() BASE_ENEMY:BaseEnemy(rands == 1 and "Gravedigger_boss" or rands == 2 and "Dune_warrior_boss2" or rands == 3 and "Dune_warrior_boss" or rands == 4 and "Boss_Mother" or rands == 5 and "Boss_Destroyer" or "Sundowner_Boss" , x,y):SetPos( x,y) end)
                end
            end
        end,


    },
    
}
function ENEMY:Think()
    self:Walk()
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
BASE_MODULE["status_sap"] = {
    Think = function(self, owner)
    end,
    PreDraw = function(self, owner, col)
        col = Color(col.r - 5 * math.sin(RealTime()*4),col.g - 5 * math.abs(math.sin(RealTime()*4)),col.b + 80 * math.abs(math.sin(RealTime()*4)))
        return col
    end,
    ProcDMG = function(self, owner, dmg)
        if dmg.type == "Fire" then
            dmg.Damage = dmg.Damage/1.5
        elseif dmg.type == "Energy" then
            dmg.Damage = dmg.Damage*4
        elseif dmg.type == "Water" then
            dmg.Damage = dmg.Damage*2
        end
        return dmg
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
                dmginfo = v.ProcDMG(v, self, dmginfo)
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
    self.face = tab.Face
    self.facethink = tab.FaceThink
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
    if tab.Init then
        tab.Init(self, x,y)
    end
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
            love.graphics.setColor(color.r/255,color.g/255,color.b/255, (color.a or 255)/255)
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
            if v.face then
                if v.facethink then
                    v:facethink()
                else
                    love.graphics.draw( v.face, pos.x - size.x/2, pos.y - size.y/3, 0, 1, 1)
                end
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