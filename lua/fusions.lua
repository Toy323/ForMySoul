WEAPONS.Fusions = {}
WEAPONS.FusionsDesc = {}
WEAPONS.IDFusion = {}
WEAPONS.ColorOfFus = {}

function WEAPONS:AddFusion(wep1, wep2, func, desc, color)
    local id = #WEAPONS.Fusions + 1
    WEAPONS.Fusions[id] = func
    WEAPONS.IDFusion[wep1.."plus"..wep2] = id
    WEAPONS.IDFusion[wep2.."plus"..wep1] = id
    WEAPONS.FusionsDesc[id] = desc
    WEAPONS.ColorOfFus[id] = color
end


local fuse = WEAPONS.AddFusion

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