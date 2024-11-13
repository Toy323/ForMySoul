WAVE = {}
WAVE.NextWave = 0
WAVE.EnemyOnWave = 0
WAVE.Locations = {["Flatland"] = {}, ["Desert"] = {}, ["Graveyard"] = {}}
WAVE.AddMoneyLoc = {["Flatland"] = {}, ["Desert"] = {}, ["Graveyard"] = {}}
function WAVE:GetWave()
    return BASE_MODULE["WaveNow"] 
end
function Count(g)
    local a = 0
    for k,v in pairs(g) do
        if v then
            a = a + 1
        end
    end
    return a
end
local waveHolder = {"Tank_v2", "Fireman", "Healer", "Rando", "Mayor_doublid","Dodger_v2", "Destroyer", "Powerupper", "Rusher", "Doublid", "Soldier_v2", "Sir", "Slowdowner", "Sundowner", "Dune_warrior", "Sundowner_Boss", "Mayor_dodger"}

WAVE.Locations["Flatland"] = {
    {"Soldier", "Crip"},
    {"Soldier", "Runner"},
    {"Bullet", "Runner", "Dodger"},
    {"Soldier", "Runner", "Doublid"},
    {"Soldier", "Runner", "Fireman", "Fireman"},
    {"Soldier", "Fireman", "Doublid", "Tank"},
    {"Soldier", "Tank", "Doublid"},
    {"Tank", "Runner", "Dodger"},
    {"Boss_Dodge"}, -- 9
    {"Soldier", "Fireman", "Dodger"},
    {"Soldier", "Tank", "Dodger"},
    {"Tank", "Runner", "Dodger", "Doublid"},
    {"Destroyer", "Dodger", "Bullet"},
    {"Dodger", "Rusher"},--14
    {"Dodger"},--15
    {"Boss_Dodge", "Destroyer", "Dodger"},--16
    {"Rusher", "Doublid"},
    {"Soldier", "Dodger", "Rusher"},
    {"Powerupper", "Powerupper", "Fireman"},
    {"Powerupper", "Powerupper", "Fireman", "Bullet"},
    {"Powerupper", "Dodger", "Tank", "Tank"},
    {"Boss_Destroyer"},
    {"Doublid", "Bullet", "Bullet"},
    {"Tank_v2", "Destroyer", "Tank_v2","Tank_v2","Tank_v2"},
    {"Powerupper", "Powerupper", "Tank_v2"},--25
    {"Mother", "Crip", "Crip", "Crip"},
    {"Mother", "Crip", "Crip"},
    {"Mother"},--28
    {"Doublid", "Mother"},
    {"Powerupper", "Fireman", "Bullet", "Bullet"},
    {"Fireman", "Tank_v2"},
    {"Fireman", "Tank_v2"},
    {"Fireman", "Tank_v2"},
    {"Mother"},--34
    {"Dodger_v2"},--35
    {"Tank_v2", "Mother",  "Tank_v2"},--36
    {"Dodger_v2",  "Tank_v2"}, -- 37
    {"Dodger_v2", "Soldier_v2"}, -- 38
    {"Dodger_v2", "Soldier_v2"}, -- 39
}
WAVE.AddMoneyLoc["Flatland"] = {
    3,
    1,
    [35] = -1500,
    [39] = 300,
}
WAVE.AddMoneyLoc["Flatland"][50] = 2500
WAVE.Locations["Flatland"][65] = {"Boss_Mother"}

WAVE.Locations["Desert"] = {
    {"Sir"},
    {"Sir"},
    {"Sir"},
    {"Sir", "Dodger", "Dodger"},
    {"Sir", "Dodger"}, -- 5
    {"Sir"},
    {"Slowdowner"},
    {"Slowdowner", "Sir"},
    {"Sir", "Doublid", "Doublid"},
    {"Sir", "Dodger"}, -- 10
    {"Slowdowner", "Sir", "Doublid"},
    {"Slowdowner", "Sir"},
    {"Sundowner"},
    {"Sundowner"},
    {"Sir", "Doublid"},
    {"Sir", "Dodger", "Dodger"},
    {"Slowdowner", "Sir"},
    {"Slowdowner","Slowdowner","Sundowner"},
    {"Slowdowner","Slowdowner","Sundowner"},
    {"Slowdowner","Slowdowner","Sundowner"}, -- 20
    {"Sundowner_Boss"},
    {"Slowdowner","Sir","Sir","Sir","Sundowner"},
    {"Slowdowner","Sir","Mayor","Sir","Sundowner"},
    {"Slowdowner","Sir","Mayor","Mayor"},
    {"Mayor", "Dodger"}, -- 25
    {"Mayor", "Doublid"},
    {"Mayor", "Dodger"},
    {"Mayor", "Doublid"},
    {"Sundowner_Boss"},
    {"Mayor_dodger"}, -- 30
    {"Mayor_dodger", "Rusher"},
    {"Mayor_dodger", "Mayor"},
    {"Slowdowner", "Mayor"},
    {"Slowdowner", "Sundowner","Mayor"},
    {"Mayor"}, -- 35
    {"Mayor"},
    {"Mayor"},
    {"Mayor_dodger", "Mayor", "Doublid"},
    {"Mayor_doublid", "Doublid", "Doublid", "Doublid"},
    {"Mayor_doublid", "Doublid", "Doublid"}, -- 40
    {"Mayor_doublid", "Doublid"},
    {"Mayor_doublid"},
    {"Dune_doublid", "Doublid", "Doublid", "Doublid"},
    {"Dune_doublid", "Doublid", "Mayor_doublid", "Doublid"},
    {"Dune_doublid", "Mayor_doublid", "Mayor_doublid", "Rusher"}, -- 45
    {"Dune_doublid"}, -- 46
    {"Dune_warrior", "Mayor_dodger"}, -- 47
    {"Dune_warrior"}, -- 48
    {"Dune_warrior", "Mayor_dodger"}, -- 49
    {"Dune_warrior","Dodger_v2","Dodger_v2"}, -- 50
    {"Sundowner_Boss"}, -- 51
    {"Sundowner_Boss", "Dune_warrior", "Dune_warrior"}, -- 52
    {"Dune_warrior_boss"} -- 53
}

WAVE.AddMoneyLoc["Desert"][45] = 1500
WAVE.AddMoneyLoc["Desert"][50] = 2500
WAVE.AddMoneyLoc["Desert"][75] = 5000
WAVE.AddMoneyLoc["Desert"][150] = 10000
WAVE.AddMoneyLoc["Desert"][250] = 20000
WAVE.AddMoneyLoc["Desert"][300] = 30000
WAVE.AddMoneyLoc["Desert"][400] = 100000
WAVE.Locations["Desert"][100] = {"Dune_warrior_boss2"}
WAVE.Locations["Desert"][250] = {"Dune_warrior_boss2"}
WAVE.Locations["Desert"][400] = {"Dune_warrior_boss2", "Boss_Mother"}

WAVE.Locations["Graveyard"] = {
    {"General"},
    {"General"},
    {"General"},
    {"General"},
    {"General"},
    {"General_mayor"},
    {"General_mayor"},
    {"General_mayor", "General"},
    {"General_mayor", "General"},
    {"General_mayor", "General"},
    {"Gravedigger"},
    {"General_mayor","General_mayor","General_mayor","General_l"},
    {"General_mayor","General_mayor","General_l"},
    {"General","General","General_l"},
    {"General","General_l"},
    {"General_l", "Gravedigger"},
    {"General_bomb"},
    {"General_bomb"},
    {"General_bomb", "Rando"},
    {"General_bomb", "Gravedigger"},
    {"Gravedigger", "Rando", "Rando", "Rando"},
    {"General_bomb", "Rando", "Rando"},
    {"Gravedigger", "Rando"},
    {"Rando"},
    {"Gravedigger_boss"},-- 24 - 25
    {"General_mayor", "Rando"},
    {"General_mayor", "Healer"},
    {"Healer"},
    {"Healer"},
    {"Healer", "Gravedigger", "Gravedigger"},
    {"Gravedigger_boss", "Healer"},
    {"Rando", "Healer", "General_bomb"},
    { "Healer", "General_bomb"},
    {"General_l","Rando", "Healer", "General_bomb"},
    {"General_l","Rando", "Healer", "General_bomb", "Gravedigger"},
    {"General_l","Rando", "Healer", "General_bomb", "Gravedigger"},
    {"General_l","Rando", "Healer", "General_bomb", "Gravedigger"},
    {"Healer_mayor"},
}

WAVE.Locations["Graveyard"][150] = {"Necro_boss"}

WAVE.AddMoneyLoc["Graveyard"][45] = 1500
WAVE.AddMoneyLoc["Graveyard"][50] = 2500
WAVE.AddMoneyLoc["Graveyard"][75] = 5000
WAVE.AddMoneyLoc["Graveyard"][250] = 10000
WAVE.AddMoneyLoc["Graveyard"][300] = 20000
WAVE.AddMoneyLoc["Graveyard"][400] = 50000
WAVE.AddMoneyLoc["Graveyard"][500] = 100000

function WAVE:Start()
    BASE_MODULE.ActiveMode = true
    local ene = Count(ENEMIES)
    if self.NextWave < CurTime() or self.EnemyOnWave-ene >= self.EnemyOnWave*0.75 then
        BASE_MODULE["WaveNow"] = BASE_MODULE["WaveNow"] + 1
        local wave = self:GetWave()
        self.NextWave = CurTime() + 25 + wave*5
        BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 175 + wave*35
        local cost = math.ceil(rand(1, wave*4) + 4 + wave^1.42 + (WAVE.AddMoneyLoc[BASE_MODULE.Location or "Flatland"][BASE_MODULE["WaveNow"]] or 0))
        if wave < 4 then
            cost = cost/3
        end
        local list2 = BASE_ENEMY.enemiesList
        local pick = WAVE.Locations[BASE_MODULE.Location or "Flatland"] and WAVE.Locations[BASE_MODULE.Location or "Flatland"][wave]
        local zero = 0
        while cost > 0 do
            local name = pick and pick[rand(1,#pick)] or waveHolder[rand(1,#waveHolder)]
            local enemy = list2[name]
            cost = cost - enemy.Cost
            local y = rand(350,1000)
            local x = 2300 + math.random(-150,300)
            BASE_ENEMY:BaseEnemy(name, x,y):SetPos(x,y)
            zero = zero + 1
            if cost <= 0 then
                break 
            end
        end
        self.EnemyOnWave = ene + zero
    end 
end