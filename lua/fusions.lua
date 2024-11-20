WEAPONS.Fusions = {}
WEAPONS.FusionsDesc = {}
WEAPONS.IDFusion = {}
WEAPONS.ColorOfFus = {}
WEAPONS.RevertID = {}

function WEAPONS:AddFusion(wep1, wep2, func, desc, color)
    local id = #WEAPONS.Fusions + 1
    WEAPONS.Fusions[id] = func
    WEAPONS.IDFusion[wep1.."plus"..wep2] = id
    WEAPONS.IDFusion[wep2.."plus"..wep1] = id
    WEAPONS.RevertID[id] = wep2.."plus"..wep1
    WEAPONS.FusionsDesc[id] = desc
    WEAPONS.ColorOfFus[id] = color
    return id
end

function WEAPONS:AddFusionUpg(id, wep, func, desc, color)
    local upgid = #WEAPONS.Fusions + 1
    WEAPONS.Fusions[upgid] = func
    WEAPONS.IDFusion[id.."plus"..wep] = upgid
    WEAPONS.IDFusion[wep.."plus"..id] = upgid
    WEAPONS.RevertID[upgid] = id.."plus"..wep
    WEAPONS.FusionsDesc[upgid] = desc
    WEAPONS.ColorOfFus[upgid] = color
    return upgid
end


local fuse = WEAPONS.AddFusion
local fuse_g = WEAPONS.AddFusionUpg

fuse(WEAPONS, "rain", "gunner_of_bombs", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 25
        local x,y = self.Position["x"],self.Position['y']
        for i=1,rand(16,33) do
            local damage = rand(30,60)
            local proj = BASE_PROJ:BasePROJ("ExploBullet",x,y)
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
"Артилерия\nДа будет дождь из взрывных пуль!\nОбе характеристики двух орудий, пули при этом становятся взрывными.\nЗадержка выстрела дольше, прямой урон от попадания меньше.", Color(86,14,14)
)
fuse(WEAPONS, "sinusoid", "tripla", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 3
        for i=1,3 do
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ(nil,x,y)
            proj.YSpeed = i == 1 and -60 or i == 2 and 60 or 0
            proj:SetPos(x,y)
            proj:SetSpeed(250)
            proj.Damage = 21
            proj.Think = function()
                proj.YSpeed = 160 * math.sin(CurTime() + proj.ID*4)
                proj.Damage = proj.Damage + 0.04
                proj:Walk()
            end
        end
        
    end
end,
"Тройная волна\nСтреляет сразу тремя пулями, у которых волнообразная траектория.\nУвеличиваемый урон в полете усиливается в 2 раза.\nСкорострельность уменьшена, урон становится чуть выше", Color(205,98,235)
)
fuse(WEAPONS, "momental", "tripla", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 1.9
        for i=1,3 do
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ(nil,x,y)
            proj.YSpeed = i == 1 and -60 or i == 2 and 60 or 0
            proj:SetPos(x,y)
            proj:SetSpeed(250)
            proj.Damage = 120
        end
        
    end
end,
"Проклятые пули\nПули наносят намного больше урона.", Color(50,50,50)
)

fuse(WEAPONS, "momental", "sinusoid", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 3

        local x,y = self.Position["x"],self.Position['y']
        local proj = BASE_PROJ:BasePROJ(nil,x,y)
        proj:SetPos(x,y)
        proj:SetSpeed(340)
        proj.Damage = 125
        proj.Think = function()
            proj.YSpeed = 240 * math.sin(CurTime() + proj.ID*4)
            proj.Damage = proj.Damage + 0.1
            proj:Walk()
        end
    end
end,
"Уничтожительный воротила\nПули наносят намного больше урона, их скорость выше,а увеличение урона с временем становится намного мощнее.", Color(114,114,114)
)





fuse_g(WEAPONS, 4, "tripla", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 3
        for i=1,3 do
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ(nil,x,y)
            proj.YSpeed = i == 1 and -60 or i == 2 and 60 or 0
            proj:SetPos(x,y)
            proj:SetSpeed(250)
            proj.Damage = 160
            proj.Think = function()
                proj.YSpeed = 160 * math.sin(CurTime() + proj.ID*4)
                proj.Damage = proj.Damage + 0.1
                proj:Walk()
            end
        end
        
    end
end,
"Тройная догоняющая смерть\nВ разы больше урона, объеденяет 3 орудия сразу.", Color(57,57,57)
)
fuse_g(WEAPONS, 3, "sinusoid", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 3
        for i=1,3 do
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ(nil,x,y)
            proj.YSpeed = i == 1 and -60 or i == 2 and 60 or 0
            proj:SetPos(x,y)
            proj:SetSpeed(250)
            proj.Damage = 160
            proj.Think = function()
                proj.YSpeed = 160 * math.sin(CurTime() + proj.ID*4)
                proj.Damage = proj.Damage + 0.1
                proj:Walk()
            end
        end
    end
end,
"Тройная догоняющая смерть\nВ разы больше урона, объеденяет 3 орудия сразу.", Color(57,57,57)
)
fuse_g(WEAPONS, 2, "momental", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 3
        for i=1,3 do
            local x,y = self.Position["x"],self.Position['y']
            local proj = BASE_PROJ:BasePROJ(nil,x,y)
            proj.YSpeed = i == 1 and -60 or i == 2 and 60 or 0
            proj:SetPos(x,y)
            proj:SetSpeed(250)
            proj.Damage = 160
            proj.Think = function()
                proj.YSpeed = 160 * math.sin(CurTime() + proj.ID*4)
                proj.Damage = proj.Damage + 0.1
                proj:Walk()
            end
        end
    end
end,
"Тройная догоняющая смерть\nВ разы больше урона, объеденяет 3 орудия сразу.", Color(57,57,57)
)

fuse(WEAPONS, "money", "double", 
{ Think = function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 25
        BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 125
    end
end,
OnContact2 = function(a,b)
    if b.IsProjectile then
        a.NextShoot = (a.NextShoot or 5) - 0.5
        DoNextFrame(function() b:Remove() end)
    elseif a.IsProjectile  then
        b.NextShoot = (b.NextShoot or 5) - 0.5
        DoNextFrame(function() a:Remove() end)
    end
end,
InitB = function(self)
    self.Phys.f:setGroupIndex(-49)
end},
"Поглощающий Добытчик\nДобывает ресурсы раз в 25 секунд, кол-во добываемых минералов становится 125\nКаждый снаряд попавший по постройке ускоряет ее на 0.5 секунды, при этом снаряд удаляется.", Color(181,136,1)
)

fuse(WEAPONS, "slowpoke", "shield_dmg", 
{
    Think = function(self)
        if self.NextShoot < CurTime() then
            self.NextShoot = CurTime() + 10
            self.Health = math.min(7500,self.Health + 25 + (25 * math.min(self.Regenerator or 1, 20)))
            self.Regenerator = ( self.Regenerator or 0 ) + 1
        end
    end,
    OnContact = function(self, enemy)
    if enemy and enemy.AttackSpeed and (enemy.NextEat or 0) < CurTime() then
        self.Health = self.Health - 35
        enemy.NextEat = CurTime() + enemy.AttackSpeed*5
        enemy.Phys.b:applyForce(enemy:GetSpeed()*35, 0)
        enemy.NoWalk = CurTime() + 0.5
        if self.Health <= 0 then
            self:Remove()
        end
        local snd = PlaySound("damageHard",math.random(1,#BASE_MODULE.Sounds["damageHard"]))
        if snd then
            snd:setPitch(rand(0.6,0.9))
        end
        enemy:TakeDamage(5 + WAVE:GetWave()*math.min(25,self.Regenerator or 1), "Spike")
    end
end,
Init = function(self)
    self.Health = 1500
    self.SizeY = 400
end},
"Разгонныe шипы\nБольше обычного щита, при этом стартовое здоровье 1500.\nРегенирует 50 здоровья раз в 10 секунд и усиливает это лечение на 25(максимум +250), и так же увеличивает урон при регенерации(до x25)\nМаксимум ХП 7500.", Color(207,156,1)
)

fuse(WEAPONS, "flamekicker", "gunner_of_bombs", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 2.5
        local x,y = self.Position["x"],self.Position['y']  - math.random(-64,64)
        local proj = BASE_PROJ:BasePROJ("ExploBulletF",x,y)
        proj:SetPos(x,y - 50)
    end
end,
"Огненный шар\nВзрыв становится огнeнным.\nЗа каждый тик урона усиливаeт ГОРEНИE на врагe на 1 стак.\nУрон у взрыва становиться чуть вышe, тип  урона становится огнeнным.", Color(207,156,1)
)
fuse(WEAPONS, "laser", "lballer", 
{ Think = function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 18
        local x,y = self.Position["x"] + 55,self.Position['y'] 
        local gr = self:FindTarget(4444, -3333, -33)
        
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
            proj.Damage = 323
        self.AllCursorsOnPos = false
    end
end,
Draw = function(self, x, y)
    love.graphics.setColor(47/255,109/255,202/255,1)
        if not self["YOldPos"] then
            self["YOldPos"] = self["YPosFor"] or y
        end
        local f,g = (self["XPosFor"] or x) - 32, self["YOldPos"] or y or 0
        if math.Round(g) ~= math.Round(self["YPosFor"] or 0) then
            self["YOldPos"] = self["YPosFor"] or y          
        else
            if (self.NextCurs or 0) < CurTime() then
                self.AllCursorsOnPos = true  
                self.NextCurs = CurTime() + 0.4
                self["XPosFor"] = self["XPosFor"] - 6 * BASE_MODULE["SpeedMul"]
            end
            if not BASE_MODULE.OnPause then
                self["XPosFor"] = self["XPosFor"] - 0.4 * BASE_MODULE["SpeedMul"]
            end
        end
        love.graphics.polygon( 'line', f, g+30, f, g-30, f+50, g )
    love.graphics.setColor(1, 1, 1,1)
end},
"Перегруженный лазер\nИсточник лазера телепортируется по полю, но сильнее толкается.\nУрон немного выше, лазер быстрее откатывается.", Color(40,123,134)
)
fuse(WEAPONS, "shield", "powerer", 
function(self)
    if self.NextShoot < CurTime()  then
        self.NextShoot = CurTime() + 25
        local x,y = self.Position["x"],self.Position['y']
        local proj = BASE_PROJ:BasePROJ("Shield",x,y)
        proj:SetPos(x,y)
        proj.NG = 0
        proj.Think = function()
            if proj.NG < CurTime() then
                proj.Damage = math.Round(proj.Damage *1.01,2)
                proj.NG = CurTime() + 0.08
            end
            proj:Walk()
        end
    end
end,
"Усиливающийся щит\nЩит во время полета очень сильно усиляется.\nЩит может усилится вплоть до 8000 урона!", Color(88,175,163)
)

fuse(WEAPONS, "silencer", "chains", 
function(self)
    if self.NextShoot < CurTime() then
        self.NextShoot = CurTime() + 4
        local x,y = self.Position["x"],self.Position['y']  - math.random(-64,64)
        local gr = self:FindTarget(125, nil, 125)
        if gr then
            y = gr.Phys.b:getY() - gr.Size["y"]/2
        end
        local proj = BASE_PROJ:BasePROJ("S_Silencer",x,y)
        proj:SetPos(x,y)
        proj.Damage = 400
        --NextDig
    end
end,
"Вечная тишь\nВыдается дебафф отключающий почти все способности врага.\nEсли враг сразу умер от удара, то дебафф тишины не будет работать.\nНе работает на врагах с первой локации.", Color(64,64,64)
)
