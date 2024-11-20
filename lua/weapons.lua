WEAPONS = {}
WEPANIMS = {}
function WEAPONS:LoadAnimations(name)
    WEPANIMS["tripla"] = {}
    for i=1,5 do
        WEPANIMS["tripla"]["attack_"..i] = love.graphics.newImage('images/animations/'..name..'/shoot_a'..i..'.png')
    end
    for i=1,3 do
        WEPANIMS["tripla"]["idle_"..i] = love.graphics.newImage('images/animations/'..name..'/idle_'..i..'.png')
    end
    WEPANIMS["tripla"]["dmg_l"] =  love.graphics.newImage('images/animations/'..name..'/dmg_take.png')
end
function AnimG(type)
    return WEPANIMS[type]
end
WEAPONS:LoadAnimations("tripla")
WEAPONS.FuncByID = {
    {Think = function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 1.9
            for i=1,3 do
                local x,y = self.Position["x"],self.Position['y']
                local proj = BASE_PROJ:BasePROJ(nil,x,y)
                proj.YSpeed = i == 1 and -60 or i == 2 and 60 or 0
                proj:SetPos(x,y)
            end
            self.Attack = CurTime() + 0.5
        end
    end, 
    Animation = function(self, x,y)
        x,y = x-32,y-32
        if self.Attack and self.Attack > CurTime() then 
            love.graphics.draw( AnimG("tripla")["attack_"..(math.Round((self.Attack-CurTime())%4)+1)], x, y, 0, 1, 1)
        else
            love.graphics.draw( AnimG("tripla")["idle_"..(math.Round((CurTime()/2)%2)+1)], x, y, 0, 1, 1)
        end
    end},

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
            self.NextShoot = CurTime() + 0.95
            for i=1,5 do
                local x,y = self.Position["x"],self.Position['y']
                local proj = BASE_PROJ:BasePROJ(nil,x,y)
                proj.YSpeed = -90 + 30*i
                proj.Damage = 80
                proj:SetPos(x,y)
            end
            
        end
    end,
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 10
            BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 55
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
            local snd = PlaySound("damageHard",math.random(1,#BASE_MODULE.Sounds["damageHard"]))
            if snd then
                snd:setPitch(rand(1.1,1.3))
            end
            enemy:TakeDamage(10 + WAVE:GetWave()*5, "Spike")
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
                proj.Damage = math.Round(35/(2.5/((self.NoShoot or 1)%5))) + 15
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
    supergun = 3500,
    money = 175,
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
    "Морозный СМГ\nСтреляет тремя пулями подряд наносящими 10(x2 урон по огнeнным врагам).\nКаждое попадание уменьшает скорость врага на 15%, дeйстуeт 5 раз.\nСтреляет прямо.\nВ пустыне не замораживает,а накладывает статус намокания,который усиливает урон по врагу.",
    "Генератор Щита\nЗадевает половину верхней линии и наносит 500 урона(урон уменьшается когда наносит урон по врагам с маленьким здоровьем).\nСтреляет прямо.",
    "Воротила\nСтреляет пулями с волнообразной траекторирей, при этом урон в полете увеличивается.\nМожет задевать другие линии.",
    "Зарядник\nЗаряжает атаку, чтобы выстрельнуть 12 пулями подряд, у которых 4 урона.\nСтреляет прямо.",
    "Усиливающийся пистолет\nНемного увеличивает урон своих пуль когда стоит на поле.\nСтреляет прямо.",
    "Электрошаровик\nСтреляет шаровой молнией, которая можeт попасть по врагу 3 раза и послe уничтожится.\nСтреляет прямо.\nУрон уменьшается на 15 когда попадает по врагу.",
    "Короткий миниган\nВсегда стреляет пулями по 15 урона, но на очeнь короткой дистанции.\nСтреляет прямо.",
    "Огнепых\nСтреляет огненным шаром, который поджигаeт врага.\nСтатус Поджига наносит 0.075% от макс.здоровья урон. Каждое попадание дает дополнительные 0.075% урона от макс.здоровья.\nСтреляет прямо.",
    "Вязкий газ\nСтреляет вязкой пулей с уроном 25, которая останавливаeт врага на 0.5 секунды и при этом можeт сильно оттолкнуть eго.\nСтреляет прямо.",
    "Супер-пушка\nСтреляет 5 пулями за раз с 80 уроном и с маленькой задержкой.\nМожет попадать по всему полю.",
    "Добытчик минералов\nКаждые 10 секунд дает 55 минералов.\nМинералы нужны всегда.",
    "Шипастая оборона\nИмеет здоровье в 5000 единиц.\nНаносит в ответ 10 урона, когда получает урон, наносимый урон увeличиваeтся от волны(на 10).\nОчень большой",
    "Зиг-загич\nУрон в 90 единиц и стреляет 2 пулями.\nНужен для стрельбы между линиями.",
    "Воротильный бумеранг\nВысокая задержка, урон в 650 единиц.\nНужен для стрельбы между линиями.",
    "Бумeранговая пушка\nОчень быстро стреляет, урон в 250 единиц.\nНужен для стрельбы между линиями.",
    "Паттерное орудие\nСтреляет редко, но паттерном 1-2-3-4-5 с уроном 15.\nНужен для прямой стрельбы и между линиями.",
    "Яростливый звон\nЧем меньше здоровья, тем больше урона.\nПолностью задевает свою линию.",
    "Дубликатор\nСоздает перед собой 2 подражания пули, c тeм жe уроном, но бeз больших функций.\nИногда задерживает пули и хранит их взади себя и не дублирует дублированные пули, а оставляeт их.",
}
WEAPONS.IconForWep = {}
WEAPONS.ColForWep = {}
WEAPONS.BaseCD = {}
function WEAPONS.AddWeapon(name, desc, func, cost, img, color, cd, icon)
    local id = #WEAPONS.NamesByID + 1
    WEAPONS.NamesByID[id] = name
    WEAPONS.FuncByID[id] = func
    WEAPONS.CostByName[name] = cost
    WEAPONS.DescByID[id] = desc or "No Name\nNo Desc"
    if img then
        WEAPONS.IconsByID[id] = {img, color}
    end
    if icon then
        WEAPONS.IconForWep[name] = icon
        WEAPONS.ColForWep[name] = color
    end
    BASE_MODULE[name.."_cd"] = BASE_MODULE[name.."_cd"] or 0
    WEAPONS.BaseCD[name] = WEAPONS.BaseCD[name] or cd or 3
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
    1900, love.graphics.newImage('images/speeder.png'), Color(37,211,14), nil,  love.graphics.newImage('images/speeder.png')
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
    5000, love.graphics.newImage('images/speeder.png'), colUpg, nil,  love.graphics.newImage('images/speeder.png')
)

wepadd("rain", 
"Стрелы вверх!\nСоздает дождь из снарядов каждые 11 секунд.\nВ дожде обычно от 12 до 30 снарядов с уроном в 80-220 единиц.",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 11
            local x,y = self.Position["x"],self.Position['y']
            for i=1,rand(12,30) do
                local damage = rand(80,220)
                local proj = BASE_PROJ:BasePROJ("Normal",x,y)
                proj:SetPos(x,y)
                proj.DieTime = CurTime() + 22
                proj.Damage = damage
                DoNextFrame(function() proj.YSpeed = -rand(300,500)/(BASE_MODULE["SpeedMul"] or 1) end)
                proj:SetSpeed(rand(50,90))
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
WEAPONS.BaseCD["momental"] = 45
wepadd("momental", 
"Большой Квадрат Судьбы\nТратится сразу,но наносит 7500-15000 урона врагам 3 линиях своим большим снарядом.\nСразу удаляется когда применится.\nКулдаун в 45 секунд.",
    function(self)
            BASE_MODULE.momental_cd = CurTime() + 30
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("MassDamage",x,y)
            proj:SetPos(x,y)
            self:Remove()
    end,--MassDamage
    1500, love.graphics.newImage('images/death.png'), Color(0,0,0)
)

BASE_MODULE["doom_cd"] = 0
WEAPONS.BaseCD["doom"] = 600
wepadd("doom", 
"Сама судьба\nНакладывает на задетых врагов статус смерти, который сносит им 50% здоровья(ДАЖЕ БОССАМ).\nСразу удаляется когда применится.\nКулдаун в 10 минут.",
    function(self)
            BASE_MODULE.doom_cd = CurTime() + 600
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("DoomBall",x,y)
            proj:SetPos(x,y)
            self:Remove()
    end,--MassDamage
    10000, love.graphics.newImage('images/fulldoom.png'), Color(0,0,0)
)

BASE_MODULE["mini_cd"] = 0
WEAPONS.BaseCD["mini"] = 15
wepadd("mini", 
"Спасенье\nВзрыв-помощник,наносящий 2000 урона врагу суммарно в эпицентре взрыва, с АоE эффeктом.\nКД 15 сeкунд",
    function(self)
            BASE_MODULE.mini_cd = CurTime() + 15
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ("Explosive",x,y)
            proj:SetPos(x,y)
            proj.DieTime = CurTime() + 3
            self:Remove()
    end,
    250, love.graphics.newImage('images/boomba.png'), Color(0,0,0)
)

wepadd("gunner_of_bombs", 
"Подрывник\nСтреляет взрывной пулей каждые 2 секунды.\nВзрывная пуля наносит урон по области.\nСтреляет случайно по всeй линии.",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 2
            local x,y = self.Position["x"],self.Position['y']  - math.random(-64,64)
            local proj = BASE_PROJ:BasePROJ("ExploBullet",x,y)
            proj:SetPos(x,y - 50)
        end
    end,
    860, love.graphics.newImage('images/boomer.png'), Color(192,103,58)
)
local DiceDraw = {
    function(x,y)
        love.graphics.rectangle( "fill", x-6, y-6, 12, 12)
    end,
    function(x,y)
        love.graphics.rectangle( "fill", x+6, y+6, 12, 12)
        love.graphics.rectangle( "fill", x-18, y-18, 12, 12)
    end,
    function(x,y)
        love.graphics.rectangle( "fill", x+6, y+6, 12, 12)
        love.graphics.rectangle( "fill", x-18, y-18, 12, 12)
        love.graphics.rectangle( "fill", x-6, y-6, 12, 12)
    end,
    function(x,y, v)
        local g2,s2, g1,s1 = v.Phys.b:getWorldPoints(v.Phys.s:getPoints())
        love.graphics.rectangle( "fill", g2 + 6, s2 + 6, 12, 12)
        love.graphics.rectangle( "fill", g1 - 18, s1 + 6, 12, 12)
        love.graphics.rectangle( "fill", g2 + 6, s2 + 6 + 38, 12, 12)
        love.graphics.rectangle( "fill", g1 - 18, s1 + 6 + 38, 12, 12)
    end,
    function(x,y, v)
        local g2,s2, g1,s1 = v.Phys.b:getWorldPoints(v.Phys.s:getPoints())
        love.graphics.rectangle( "fill", g2 + 6, s2 + 6, 12, 12)
        love.graphics.rectangle( "fill", g1 - 18, s1 + 6, 12, 12)
        love.graphics.rectangle( "fill", g2 + 6, s2 + 6 + 38, 12, 12)
        love.graphics.rectangle( "fill", g1 - 18, s1 + 6 + 38, 12, 12)
        love.graphics.rectangle( "fill", x-6, y-6, 12, 12)
    end,
    function(x,y, v)
        local g2,s2, g1,s1 = v.Phys.b:getWorldPoints(v.Phys.s:getPoints())
        love.graphics.rectangle( "fill", g2 + 6, s2 + 6, 12, 12)
        love.graphics.rectangle( "fill", g1 - 18, s1 + 6, 12, 12)
        love.graphics.rectangle( "fill", g2 + 6, s2 + 6 + 38, 12, 12)
        love.graphics.rectangle( "fill", g1 - 18, s1 + 6 + 38, 12, 12)
        love.graphics.rectangle( "fill", g2 + 6, s2 + 6 + 19, 12, 12)
        love.graphics.rectangle( "fill", g1 - 18, s1 + 6 + 19, 12, 12)
    end,

}
wepadd("dicer", 
"Костяная установка\nСтреляет каждые ЧИСЛО НА ОРУЖИЕ секунд.\nПули наносят 45 * ЧИСЛО НА ОРУЖИЕ урона.\nСтреляет по случайному врагу на линии.",
    {
       Think = function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 1 * ((self.ShootingMoment or 1)+1)
            local x,y = self.Position["x"],self.Position['y']  - math.random(-64,64)
            local gr = self:FindTarget(125, nil, 125)
            if gr then
                y = gr.Phys.b:getY() - gr.Size["y"]/2
            end
            local proj = BASE_PROJ:BasePROJ("Bullet",x,y)
            proj:SetPos(x,y)
            proj.Damage = 45 * ((self.ShootingMoment or 1)+1)
            self.ShootingMoment = ((self.ShootingMoment or 0)+1) %6
        end
    end,
    Draw = function(self, x,y)
        love.graphics.setColor(0, 0, 0,1)
        DiceDraw[(self.ShootingMoment or 1)+1](x,y, self)
        love.graphics.setColor(1, 1, 1,1)
    end,
    Init = function(self)
        DoNextFrame(function() self.Color = Color(203,203,203) end)
    end
},
    250, love.graphics.newImage('images/dicing.png'), colBullet
)

BASE_MODULE["money_cd"] = 0
WEAPONS.BaseCD["money"] = 6
BASE_MODULE["shield_dmg_cd"] = 0
WEAPONS.BaseCD["shield_dmg"] = 20

function math.Round( num, idp )
	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult
end

wepadd("buckshot_auto", 
"Авто-дробовик\nСтреляет по 3 врагам на линии.\nДробь очень эффективна вблизи и на гигантских врагах.\nПлохо замечает противников, которые меньше солдата.",
    { Think = function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 3.6
            local x,y = self.Position["x"] + 45,self.Position['y'] 
            local gr = self:FindTargets(250, -33, 250)
            
            for i=1,3 do
                if gr[i] then
                    y = math.Clamp(gr[i].Phys.b:getY() - gr[i].Size["y"]/2, y-77, y+77)
                else
                    y = y - math.random(-64,64)
                end
                self["YPosFor"..i] = y
                self["XPosFor"..i] = x
            end
        end
        if self.AllCursorsOnPos then
            for i2=1,3 do
                local x = self["XPosFor"..i2] 
                local y = self["YPosFor"..i2] 
                for i=1,7 do
                    local proj = BASE_PROJ:BasePROJ("Bullet",x,y)
                    proj:SetPos(x,y)
                    proj:SetSpeed(rand(300,400))
                    proj.YSpeed = rand(-11,11)
                    proj.Damage = 22
                end
            end
            self.AllCursorsOnPos = false
        end
    end,
    Draw = function(self, x, y)
        love.graphics.setColor(0, 0, 0,1)
        for i=1,3 do
            if not self["YOldPos"..i] then
                self["YOldPos"..i] = self["YPosFor"..i] or y
            end
            local f,g = (self["XPosFor"..i] or x) - 10, self["YOldPos"..i] or y or 0
            if math.Round(g) ~= math.Round(self["YPosFor"..i] or 0) then
                self["YOldPos"..i] = math.Approach(self["YOldPos"..i], self["YPosFor"..i] or y, math.abs((self["YPosFor"..i] or 55) - self["YOldPos"..i])/7 * BASE_MODULE["SpeedMul"] )           
            else
                if (self.NextCurs or 0) < CurTime() then
                    self.AllCursorsOnPos = true  
                    self.NextCurs = CurTime() + 2.9
                end              
            end
            love.graphics.polygon( 'line', f, g+10, f, g-10, f+20, g )
        end
        love.graphics.setColor(1, 1, 1,1)
    end},
    625, love.graphics.newImage('images/buckshot_auto.png'), colBullet
)



wepadd("automat", 
"Авто-пушка\nСлучайно выбирает цель и стреляет по ней.\nСтреляет достаточно быстро и плохо видит маленьких врагов.",
    { Think = function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 0.6
            local x,y = self.Position["x"] + 45,self.Position['y'] 
            local gr = self:FindTarget(122, -15, 66)
            
                if gr then
                    y = math.Clamp(gr.Phys.b:getY() - gr.Size["y"]/2, y-77, y+77)
                else
                    y = y - math.random(-64,64)
                end
                self["YPosFor"] = y
                self["XPosFor"] = x
        end
        if self.AllCursorsOnPos then
                local x = self["XPosFor"] 
                local y = self["YPosFor"] 
                local proj = BASE_PROJ:BasePROJ("Bullet",x,y)
                proj:SetPos(x,y)
                proj:SetSpeed(rand(700,800))
                proj.Damage = 34
            self.AllCursorsOnPos = false
        end
    end,
    Draw = function(self, x, y)
        love.graphics.setColor(0, 0, 0,1)
            if not self["YOldPos"] then
                self["YOldPos"] = self["YPosFor"] or y
            end
            local f,g = (self["XPosFor"] or x) - 10, self["YOldPos"] or y or 0
            if math.Round(g) ~= math.Round(self["YPosFor"] or 0) then
                self["YOldPos"] = math.Approach(self["YOldPos"], self["YPosFor"] or y, math.abs((self["YPosFor"] or 55) - self["YOldPos"])/7 * BASE_MODULE["SpeedMul"] )           
            else
                if (self.NextCurs or 0) < CurTime() then
                    self.AllCursorsOnPos = true  
                    self.NextCurs = CurTime() + 0.3
                end              
            end
            love.graphics.polygon( 'line', f, g+10, f, g-10, f+20, g )
        love.graphics.setColor(1, 1, 1,1)
    end},
    325, love.graphics.newImage('images/autmat.png'), colBullet
)


wepadd("laser", 
"Ультра-лазер\nСлучайно выбирает цель ПО ВСЕМУ ПОЛЮ и стреляет по ней.\nНу...Лазер...Мощный...Огромный...за 7250 вы этого и ждете, разве нет?\nКак основопологающая защита - ужасна, но для толп подходит и может целить за границы.\nИсточник лазера так же при стрельбе немного едет назад.",
    { Think = function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 22
            local x,y = self.Position["x"] + 55,self.Position['y'] 
            local gr = self:FindTarget(4444, -3333, 2222)
            
                if gr then
                    y = gr.Phys.b:getY() - gr.Size["y"]/2
                else
                    y = y - math.random(-333,333)
                end
                self["YPosFor"] = y
                self["XPosFor"] = x
        end
        if self.AllCursorsOnPos then
                local x = self["XPosFor"] 
                local y = self["YPosFor"] 
                local proj = BASE_PROJ:BasePROJ("Laser",x + 2500,y)
                proj:SetPos(x+ proj.Size.x/2,y)
            self.AllCursorsOnPos = false
        end
    end,
    Draw = function(self, x, y)
        love.graphics.setColor(0, 0, 0,1)
            if not self["YOldPos"] then
                self["YOldPos"] = self["YPosFor"] or y
            end
            local f,g = (self["XPosFor"] or x) - 32, self["YOldPos"] or y or 0
            if math.Round(g) ~= math.Round(self["YPosFor"] or 0) then
                self["YOldPos"] = math.Approach(self["YOldPos"], self["YPosFor"] or y, math.max(math.abs((self["YPosFor"] or 55) - self["YOldPos"])/150 * BASE_MODULE["SpeedMul"], 0.11) )           
            else
                if (self.NextCurs or 0) < CurTime() then
                    self.AllCursorsOnPos = true  
                    self.NextCurs = CurTime() + 0.4
                    self["XPosFor"] = self["XPosFor"] - 3 * BASE_MODULE["SpeedMul"]
                end
                if not BASE_MODULE.OnPause then
                    self["XPosFor"] = self["XPosFor"] - 0.2 * BASE_MODULE["SpeedMul"]
                end
            end
            love.graphics.polygon( 'line', f, g+30, f, g-30, f+50, g )
        love.graphics.setColor(1, 1, 1,1)
    end},
    7250, love.graphics.newImage('images/laser.png'), Color(44,238,232), nil,  love.graphics.newImage('images/wepsome/laserito.png')
)


wepadd("silencer", 
"Наводчик тишины\nСтреляет по случайному врагу на линии снарядом наносящий 400 урона,который отключает специальную способность на 7 секунд.\nМожет отключать способность и боссу.\nРаботает лишь на способности которые завязаны на времени",
    function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 4
            local x,y = self.Position["x"],self.Position['y']  - math.random(-64,64)
            local gr = self:FindTarget(125, nil, 125)
            if gr then
                y = gr.Phys.b:getY() - gr.Size["y"]/2
            end
            local proj = BASE_PROJ:BasePROJ("Silenced",x,y)
            proj:SetPos(x,y)
            proj.Damage = 400
            --NextDig
        end
    end,
    1300, love.graphics.newImage('images/wepsome/silencer.png'), Color(125,125,125)
)