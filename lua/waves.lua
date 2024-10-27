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
local waveHolder = {"Tank", "Fireman", "Soldier", "Runner"}
local wavesD = {
    {"Soldier", "Bullet"}, --, "Doublid"
    {"Soldier", "Runner"},
    {"Bullet", "Runner", "Dodger"}, --, "Doublid"
    {"Soldier", "Runner"},
    {"Soldier", "Runner", "Fireman", "Fireman"},
    {"Soldier", "Fireman"},
    {"Soldier", "Tank"},
    {"Tank", "Runner", "Dodger"},
    {"Boss_Dodge"}

}
function WAVE:Start()
    BASE_MODULE.ActiveMode = true
    local ene = Count(ENEMIES)
    if self.NextWave < CurTime() or self.EnemyOnWave-ene >= self.EnemyOnWave*0.65 then
        BASE_MODULE["WaveNow"] = BASE_MODULE["WaveNow"] + 1
        self.NextWave = CurTime() + 25 + self:GetWave()*5
        BASE_MODULE["MoneyNow"] = BASE_MODULE["MoneyNow"] + 75 + self:GetWave()*25
        local cost = math.random(1, self:GetWave()*3.6) + 4 + self:GetWave()*2
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
            local x = 2500 + math.random(-350,500)
            BASE_ENEMY:BaseEnemy(name, x,y):SetPos(x,y)
            zero = zero + 1
            if cost <= 0 then
                break 
            end
        end
        self.EnemyOnWave = ene + zero
    end 
end