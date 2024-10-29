WAVE = {}
WAVE.NextWave = 0
WAVE.EnemyOnWave = 0
function WAVE:GetWave()
    return BASE_MODULE["WaveNow"] 
end
local function Count(g)
    local a = 0
    for k,v in pairs(g) do
        if v then
            a = a + 1
        end
    end
    return a
end
local waveHolder = {"Tank_v2", "Fireman", "Runner", "Destroyer", "Powerupper", "Rusher", "Doublid"}
local wavesD = {
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
    {"Powerupper", "Powerupper", "Tank_v2"},
    {"Mother", "Crip", "Crip", "Crip"},
    {"Mother", "Crip", "Crip"},
    {"Mother"},
    {"Doublid", "Mother"},
    {"Powerupper", "Fireman", "Bullet", "Bullet"},
    {"Fireman", "Tank_v2"},
    {"Tank_v2", "Mother", "Tank_v2"},

}
function WAVE:Start()
    BASE_MODULE.ActiveMode = true
    local ene = Count(ENEMIES)
    if self.NextWave < CurTime() or self.EnemyOnWave-ene >= self.EnemyOnWave*0.65 then
        BASE_MODULE["WaveNow"] = BASE_MODULE["WaveNow"] + 1
        self.NextWave = CurTime() + 25 + self:GetWave()*5
        BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 175 + self:GetWave()*35
        local cost = math.random(1, self:GetWave()*4) + 4 + self:GetWave()*2
        if self:GetWave() < 4 then
            cost = cost/3
        end
        local list2 = BASE_ENEMY.enemiesList
        local pick = wavesD[self:GetWave()]
        local zero = 0
        while cost > 0 do
            local name = pick and pick[math.random(1,#pick)] or waveHolder[math.random(1,#waveHolder)]
            local enemy = list2[name]
            cost = cost - enemy.Cost
            local y = math.random(250,1000)
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