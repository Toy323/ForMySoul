WAVE = {}
WAVE.NextWave = 0
WAVE.EnemyOnWave = 0
WAVE.Locations = {["Flatland"] = {}, ["Desert"] = {}}
WAVE.AddMoneyLoc = {["Flatland"] = {}, ["Desert"] = {}}
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
local waveHolder = {"Tank_v2", "Fireman", "Runner","Dodger_v2", "Destroyer", "Powerupper", "Rusher", "Doublid", "Soldier_v2", "Sir", "Slowdowner", "Sundowner", "Dune_warrior", "Sundowner_Boss", "Mayor_dodger"}

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
    {"Sir", "Dodger"},
    {"Sir"},
    {"Slowdowner"},
    {"Slowdowner", "Sir"},
    {"Sir", "Doublid", "Doublid"},
    {"Sir", "Dodger"},
    {"Slowdowner", "Sir", "Doublid"},
    {"Slowdowner", "Sir"},
    {"Sundowner"},
    {"Sundowner"},
    {"Sir", "Doublid"},
    {"Sir", "Dodger", "Dodger"},
    {"Slowdowner", "Sir"},
    {"Slowdowner","Slowdowner","Sundowner"},
    {"Slowdowner","Slowdowner","Sundowner"},
    {"Slowdowner","Slowdowner","Sundowner"},
    {"Sundowner_Boss"},
    {"Slowdowner","Sir","Sir","Sir","Sundowner"},
    {"Slowdowner","Sir","Mayor","Sir","Sundowner"},
    {"Slowdowner","Sir","Mayor","Mayor"},
    {"Mayor", "Dodger"},
    {"Mayor", "Doublid"},
    {"Mayor", "Dodger"},
    {"Mayor", "Doublid"},
    {"Sundowner_Boss"},
    {"Mayor_dodger"},
    {"Mayor_dodger", "Rusher"},
    {"Mayor_dodger", "Mayor"},
    {"Slowdowner", "Mayor"},
    {"Slowdowner", "Sundowner","Mayor"},
    {"Mayor"},
    {"Mayor"},
    {"Mayor"},
    {"Mayor_dodger", "Mayor", "Doublid"},
    {"Mayor_doublid", "Doublid", "Doublid", "Doublid"},
    {"Mayor_doublid", "Doublid", "Doublid"},
    {"Mayor_doublid", "Doublid"},
    {"Mayor_doublid"},
    {"Dune_doublid", "Doublid", "Doublid", "Doublid"},
    {"Dune_doublid", "Doublid", "Mayor_doublid", "Doublid"},
    {"Dune_doublid", "Mayor_doublid", "Mayor_doublid", "Rusher"},
    {"Dune_doublid"},
    {"Dune_warrior", "Mayor_dodger"},
    {"Dune_warrior"},
    {"Dune_warrior", "Mayor_dodger"},
    {"Dune_warrior","Dodger_v2","Dodger_v2"},
    {"Sundowner_Boss"},
    {"Sundowner_Boss", "Dune_warrior", "Dune_warrior"},
    {"Dune_warrior_boss"}
}
function WAVE:Start()
    BASE_MODULE.ActiveMode = true
    local ene = Count(ENEMIES)
    if self.NextWave < CurTime() or self.EnemyOnWave-ene >= self.EnemyOnWave*0.65 then
        BASE_MODULE["WaveNow"] = BASE_MODULE["WaveNow"] + 1
        self.NextWave = CurTime() + 25 + self:GetWave()*5
        BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 175 + self:GetWave()*35
        local cost = math.ceil(rand(1, self:GetWave()*4) + 4 + self:GetWave()^1.35 + (WAVE.AddMoneyLoc[BASE_MODULE.Location or "Flatland"][BASE_MODULE["WaveNow"]] or 0))
        if self:GetWave() < 4 then
            cost = cost/3
        end
        local list2 = BASE_ENEMY.enemiesList
        local pick = WAVE.Locations[BASE_MODULE.Location or "Flatland"] and WAVE.Locations[BASE_MODULE.Location or "Flatland"][self:GetWave()]
        local zero = 0
        while cost > 0 do
            local name = pick and pick[rand(1,#pick)] or waveHolder[rand(1,#waveHolder)]
            local enemy = list2[name]
            cost = cost - enemy.Cost
            local y = rand(250,1000)
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