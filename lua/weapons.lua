WEAPONS = {}


WEAPONS.FuncByID = {
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
                proj.YSpeed = 160 * math.sin(CurTime() + proj.ID*4)
                proj.Damage = proj.Damage + 0.02
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
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 4.5
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Gas",x,y)
            proj:SetPos(x,y)
        end
    end,
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 0.74
            for i=1,5 do
                local x,y = self.Position["x"],self.Position['y']
                local proj = BASE_PROJ:BasePROJ(nil,x,y)
                proj.YSpeed = i == 1 and -30 or i == 2 and 30 or i == 3 and 70 or i == 4 and -70 or 0
                proj.Damage = 50
                proj:SetPos(x,y)
            end
            
        end
    end,
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 10
            BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 35
        end
    end,
    {OnContact = function(self, enemy)
        if enemy and enemy.AttackSpeed and (enemy.NextEat or 0) < CurTime() then
            self.Health = self.Health - 25
            enemy.NextEat = CurTime() + enemy.AttackSpeed*5
            enemy.Phys.b:applyForce(enemy:GetSpeed()*15, 0)
            enemy.NoWalk = CurTime() + 0.2
            if self.Health <= 0 then
                self:Remove()
            end
            enemy:TakeDamage(125, "Spike")
        end
    end,
    Init = function(self)
        self.Health = 5000
        self.SizeY = 320
    end},
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 0.74
            for i=1,2 do
                local x,y = self.Position["x"],self.Position['y']
                local proj = BASE_PROJ:BasePROJ(nil,x,y)
                proj.YSpeed = i == 1 and -50 or 50
                proj.Damage = 90
                proj:SetPos(x,y)
            end
        end
    end,
    function(self)
        if self.NextShoot < CurTime()  then
            self.NextShoot = CurTime() + 6
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Bumrang",x,y)
            proj:SetPos(x,y)
            proj:SetSpeed(240)
            proj.Think = function()
                proj.YSpeed = 450 * math.sin(CurTime()*3 + proj.ID*4)
                proj:Walk()
                proj.StartingRang = (proj.StartingRang or 0) + 1
                if proj.StartingRang > 470 then
                    proj.SpeedUnits = proj.SpeedUnits*-1
                    proj.StartingRang = 0
                end
            end
        end
    end,
    function(self)
        if self.NextShoot < CurTime()  then
            self.NextShoot = CurTime() + 0.5
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Bumrang",x,y)
            proj:SetPos(x,y)
            proj:SetSpeed(240)
            proj.Damage = 250
            proj.Think = function()
                proj.YSpeed = 320 * math.sin(CurTime()*3 + proj.ID*4)
                proj:Walk()
                proj.StartingRang = (proj.StartingRang or 0) + 1
                if proj.StartingRang > 470 then
                    proj.SpeedUnits = proj.SpeedUnits*-1
                    proj.StartingRang = 0
                end
            end
        end
    end,
    function(self)
        if self.NextShoot < CurTime() -((self.NoShoot or 0)%5 == 0 and 2 or 0) then
            self.NextShoot = CurTime() + 0.45
            local x,y = self.Position["x"],self.Position['y']
            for i=0,math.max(0,(self.NoShoot or 0)%5) do
                local proj = BASE_PROJ:BasePROJ("Normal",x,y)
                proj.YSpeed = i < 3 and -30*i or 30*i
                proj:SetPos(x,y)
                proj.Damage = 15
            end
            self.NoShoot = (self.NoShoot or 0) + 1
        end
    end,
    {Think = function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 3
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("RagingBullet",x,y + 30)
            proj:SetPos(x,y - 50)
            proj.Damage = 40 * (12.5-self.Health*0.01)
        end
    end,
    Init = function(self)
        self.Health = 1250
    end},
    {OnContact2 = function(a,b)
        if b.IsProjectile then
            local proj2 = b.PROJECTILEType
            local x,y = a.Position.x,  a.Position.y
            if  b.Touched then
                b:SetPos(x + 174, y)
                return
            end
            local oldd = b.Damage
            b:Remove()
            for i=1,2 do
                DoNextFrame(function() 
                    local proj = BASE_PROJ:BasePROJ(proj2, x +54, y - 30 + 30*i) 
                    proj:SetPos(x + 174, y - 30 + 30*i)
                    proj.Damage = oldd
                    proj.Touched = true
                end)
            end
        elseif a.IsProjectile  then
            local proj2 = a.PROJECTILEType
            local x,y = b.Position.x,  b.Position.y
            if  a.Touched then
                a:SetPos(x + 174, y)
                return
            end
            local oldd = a.Damage
            a:Remove()
            for i=1,2 do
                DoNextFrame(function() 
                    local proj = BASE_PROJ:BasePROJ(proj2, x +54, y - 30 + 30*i) 
                    proj:SetPos(x + 174, y - 30 + 30*i)
                    proj.Damage = oldd
                    proj.Touched = true
                end)
            end
        end
    end,
    InitB = function(self)
        self.Phys.f:setGroupIndex(-49)
    end},
}

WEAPONS.CostByName = {    
    tripla = 50,
    frize = 125,
    shield = 600,
    sinusoid = 125,
    charger = 250,
    powerer = 150,
    lballer = 250,
    alwaysgatling = 250,
    flamekicker = 300,
    news = 250,
    supergun = 2250,
    money = 125,
    shield_dmg = 750,
    duoes = 350,
    brg = 850,
    brg_u = 5000,
    pato = 650,
    double = 1650,
    rager = 550,
}
WEAPONS.NamesByID = {
    "tripla",
    "frize",
    "shield",
    "sinusoid",
    "charger",
    "powerer",
    "lballer",
    "alwaysgatling",
    "flamekicker",
    "news",
    "supergun",
    "money",
    "shield_dmg",
    "duoes",
    "brg",
    "brg_u",
    "pato",
    "rager",
    "double",
}
local colBullet = Color(133,16,88)
local colUpg = Color(109,35,255)
WEAPONS.IconsByID = {
    {love.graphics.newImage('images/tripla.png'), colBullet},
    {love.graphics.newImage('images/friza.png'), Color(41,241,221)},
    {love.graphics.newImage('images/shield.png'), Color(255,255,255)},
    {love.graphics.newImage('images/sinusoid.png'), colBullet},
    {love.graphics.newImage('images/charger.png'), colBullet},
    {love.graphics.newImage('images/powerer.png'), colBullet},
    {love.graphics.newImage('images/lballer.png'), Color(0,56,141)},
    {love.graphics.newImage('images/alwaysgatling.png'), colBullet},
    {love.graphics.newImage('images/flamekicker.png'), Color(158,58,0)},
    {love.graphics.newImage('images/vyazk.png'), Color(0,158,3)},
    {love.graphics.newImage('images/supra.png'), colBullet},
    {love.graphics.newImage('images/miner.png'), Color(46,46,46)},
    {love.graphics.newImage('images/shield_dmg.png'), Color(156,14,4)},
    {love.graphics.newImage('images/duoes.png'), colBullet},
    {love.graphics.newImage('images/brg.png'), colBullet},
    {love.graphics.newImage('images/brg.png'), colUpg},
    {love.graphics.newImage('images/patertno.png'), colBullet},
    {love.graphics.newImage('images/rager.png'), Color(80,0,0)},
    {love.graphics.newImage('images/doubled.png'), Color(8,224,22)},
}


WEAPONS.DescByID = {
    "Тристрел\nСтреляет тремя пулями по 15 урона каждая.\nМожет задевать другии линии.",
    "Морозный СМГ\nСтреляет тремя пулями подряд наносящими 10(x2 урон по огнeнным врагам).\nКаждое попадание уменьшает скорость врага на 15%, дeйстуeт 5 раз.\nСтреляет прямо.",
    "Генератор Щита\nЗадевает половину верхней линии и наносит 500 урона(урон уменьшается когда наносит урон по врагам с маленьким здоровьем).\nСтреляет прямо.",
    "Воротила\nСтреляет пулями с волнообразной траекторирей, при этом урон в полете увеличивается.\nМожет задевать другие линии.",
    "Зарядник\nЗаряжает атаку, чтобы выстрельнуть 12 пулями подряд, у которых 4 урона.\nСтреляет прямо.",
    "Усиливающийся пистолет\nНемного увеличивает урон своих пуль когда стоит на поле.\nСтреляет прямо.",
    "Электрошаровик\nСтреляет шаровой молнией, которая можeт попасть по врагу 3 раза и послe уничтожится.\nСтреляет прямо.\nУрон уменьшается на 15 когда попадает по врагу.",
    "Короткий миниган\nВсегда стреляет пулями по 15 урона, но на очeнь короткой дистанции.\nСтреляет прямо.",
    "Огнепых\nСтреляет огненным шаром, который поджигаeт врага.\nСтатус Поджига наносит 0.075% от макс.здоровья урон. Каждое попадание дает дополнительные 0.075% урона от макс.здоровья.\nСтреляет прямо.",
    "Вязкий газ\nСтреляет вязкой пулей с уроном 25, которая останавливаeт врага на 0.5 секунды и при этом можeт сильно оттолкнуть eго.\nСтреляет прямо.",
    "Супер-пушка\nСтреляет 5 пулями за раз с 50 уроном и с маленькой задержкой.\nМожет попадать по всему полю.",
    "Добытчик минералов\nКаждые 10 секунд дает 35 минералов.\nМинералы нужны всегда.",
    "Шипастая оборона\nИмеет здоровье в 5000 единиц.\nНаносит в ответ 125 урона, когда получает урон.\nОчень большой",
    "Зиг-загич\nУрон в 90 единиц и стреляет 2 пулями.\nНужен для стрельбы между линиями.",
    "Воротильный бумеранг\nВысокая задержка, урон в 650 единиц.\nНужен для стрельбы между линиями.",
    "Бумeранговая пушка\nОчень быстро стреляет, урон в 250 единиц.\nНужен для стрельбы между линиями.",
    "Паттерное орудие\nСтреляет редко, но паттерном 1-2-3-4-5 с уроном 15.\nНужен для прямой стрельбы и между линиями.",
    "Яростливый звон\nЧем меньше здоровья, тем больше урона.\nПолностью задевает свою линию.",
    "Дубликатор\nСоздает перед собой 2 подражания пули, c тeм жe уроном, но бeз больших функций.\nИногда задерживает пули и хранит их взади себя и не дублирует дублированные пули, а оставляeт их.",
}
function WEAPONS.AddWeapon(name, desc, func, cost, img, color)
    local id = #WEAPONS.NamesByID + 1
    WEAPONS.NamesByID[id] = name
    WEAPONS.FuncByID[id] = func
    WEAPONS.CostByName[name] = cost
    WEAPONS.DescByID[id] = desc or "No Name\nNo Desc"
    if img then
        WEAPONS.IconsByID[id] = {img, color}
    end
    return id
end
local wepadd = WEAPONS.AddWeapon
wepadd("slowpoke", 
"Разгонный Добытчик\nДает 50 минералов раз в 20 секунд.\nКаждая выработка уменьшает задержку на 0.5, максимальная задержка равна 2.5 секундам.\nПри полном разгоне стреляет огненной пулей.",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + (self.CoolDown or 20)
            self.CoolDown = math.max((self.CoolDown or 20.5) - 0.5, 2.5)
            BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 50
            if self.CoolDown < 3 then
                local x,y = self.Position["x"],self.Position['y']
                local proj = BASE_PROJ:BasePROJ("FireNormal",x,y)
                proj:SetPos(x,y)
                proj.DieTime = CurTime() + 25
            end
        end
    end,
    225, love.graphics.newImage('images/miner.png'), Color(158,58,0)
)
wepadd("speeder", 
"Ускоритель\nКаждые 8 секунд ускоряет все сооружения.\nУскорение снижает текущую задержку выстрела или добычи на 25%.\nНе может ускорить себя же и себе подобных.\nМожет быть ускорен старшим братом,но лишь на 25%",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 8
            for k,v in ipairs(tilesblock) do
                if v and v.NextShoot and v.WeaponOnMe ~= "speeder" then
                    local time = v.NextShoot - CurTime()
                    time = time * (v.WeaponOnMe == "speeder" and 0.88 or 0.75)
                    v.NextShoot = time + CurTime()
                end
            end
        end
    end,
    1900, love.graphics.newImage('images/speeder.png'), Color(37,211,14)
)
wepadd("speederv2", 
"Сверх-ускоритель\nКаждые 25 секунд ускоряет все сооружения.\nУскорение снижает текущую задержку выстрела или добычи на 75%.\nНе может ускорить себя же и себе подобных.\nМожет быть ускорен своим младшим братом,но лишь на 12%.",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 25
            for k,v in ipairs(tilesblock) do
                if v and v.NextShoot and v.WeaponOnMe ~= "speederv2" then
                    local time = v.NextShoot - CurTime()
                    time = time * 0.25 * (v.WeaponOnMe == "speeder" and 3 or 1)
                    v.NextShoot = time + CurTime()
                end
            end
        end
    end,
    5000, love.graphics.newImage('images/speeder.png'), colUpg
)

wepadd("rain", 
"Стрелы вверх!\nСоздает дождь из снарядов каждые 17 секунд.\nВ дожде обычно от 12 до 30 снарядов с уроном в 50-120 единиц.",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 17
            local x,y = self.Position["x"],self.Position['y']
            for i=1,math.random(12,30) do
                local damage = math.random(40,90)
                local proj = BASE_PROJ:BasePROJ("Normal",x,y)
                proj:SetPos(x,y)
                proj.DieTime = CurTime() + 22
                proj.Damage = damage
                DoNextFrame(function() proj.YSpeed = -math.random(300,500) end)
                proj:SetSpeed(math.random(50,90))
                proj.Think = function()
                    proj.YSpeed = (proj.YSpeed or 0) + 3
                    proj:Walk()
                end
            end
        end
    end,
    2000, love.graphics.newImage('images/rain.png'), colBullet
)
wepadd("chains", 
"Оцепенитель\nСнаряд обездвиживает врага на 3 секунды, но нe босса.\nСтреляет раз в 3 секунды и на вeсь ряд.",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 3
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Chains",x,y + 30)
            proj:SetPos(x,y - 50)
        end
    end,
    300, love.graphics.newImage('images/chains.png'), Color(62,62,62)
)
BASE_MODULE["momental_cd"] = 0
WEAPONS.BaseCD = {}
WEAPONS.BaseCD["momental"] = 30
wepadd("momental", 
"Большой Квадрат Судьбы\nТратится сразу,но наносит 7500-15000 урона врагам 3 линиях своим большим снарядом.\nСразу удаляется когда применится.\nКулдаун в 30 секунд.",
    function(self)
        if BASE_MODULE.momental_cd < CurTime() then
            BASE_MODULE.momental_cd = CurTime() + 30
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("MassDamage",x,y)
            proj:SetPos(x,y)
            self:Remove()
        end
    end,--MassDamage
    1500, love.graphics.newImage('images/death.png'), Color(0,0,0)
)