
tile = {}
tiles = {}
tile.IsTile = true
tilesblock = {}

require("lua/table_enc")
function tile:BaseTile()
    base = Copy(tile)
    base.ID = #tilesblock + 1
    tilesblock[base.ID] = base
    return base
end
function tile:Remove()
    if self.Phys then
        self.Phys.b:destroy()
        if not self.Phys.f:isDestroyed() then
            self.Phys.f:destroy()
        end
    end
    tilesblock[self.ID] = nil
    self.Removed = true
    local pos = self.Position
    self:OnRemove(pos.x,pos.y)

    self = nil
end
function tile:OnRemove(x,y)
end
function tile:SetPos(x, y)
    self.Position = {}
    self.Position["x"] = x
    self.Position["y"] = y
end
function tile:Create(x, y, size, color)
    local selfy = tile:BaseTile()
    selfy:SetPos(x,y)
    selfy.Size = size
    selfy.Color = color
end
function tile:SetColor(color)
    self.Color = {}
    self.Color = color
    tilesblock[self.ID].Color = color
end
tile.Health = 250

function tile:OnContact(enemy)
    if enemy and enemy.AttackSpeed and (enemy.NextEat or 0) < CurTime() then
        self.Health = self.Health - 25
        enemy.NextEat = CurTime() + enemy.AttackSpeed*5
        enemy.Phys.b:applyForce(enemy:GetSpeed()*15, 0)
        enemy.NoWalk = CurTime() + 0.2
        if self.Health <= 0 then
            self:Remove()
        end
    end
end
function tile:CreateButton(x, y, size, color, func)
    local selfy = tile:BaseTile()
    selfy:SetPos(x,y)
    selfy.Size = size
    selfy.Color = color

    local button = BUTTON.AddButton(size+4,x,y,Color(43,115,96))
    button.OnClickDo = func

    button.Parent = selfy
end
function tile:AddCollision()
    static = {}
    static.b = love.physics.newBody(BASE_MODULE.world, self.Position["x"],self.Position["y"], "static")
    static.b:setFixedRotation(true)
    static.s = love.physics.newRectangleShape(self.Size,self.Size)       
    static.f = love.physics.newFixture(static.b, static.s)
    static.f:setGroupIndex(-48)
    static.f:setUserData(tostring(self.ID))
    static.f:setRestitution(0.1) 
    self.Phys = static
    self.HasCollision = true
end

function tiles:CreateRowDow(x, y, size, num, col)
    for i=0,num do
        tile:Create(x, y + i * size,size/2, col)
    end
end

function tiles:CreateMapLineDown(x, y, numbers, size, col)
    for i=0,numbers do
        tile:Create(x+size*i,y+size*i, size/2, col)
    end
end
FORMULA_CUBE  = "cube"
FORMULA_PARALEP_D  = "paralep_d"
FORMULA_PARALEP_R  = "paralep_r"
local formulas = {
    ["cube"] = function(x2, y, count, size, sizeofrow, col)
        for x=0,count do
            tile:Create(x2+x * size,y, size/2, col)
            tiles:CreateRowDow(x2+x * size, y, size, count, col)
        end
    end,
    ["paralep_d"] = function(x2, y, count, size, sizeofrow, col)
        for x=0,count do
            --tile:Create(x2+x * size,y, size/2, col)
            tiles:CreateRowDow(x2+x * size, y, size, sizeofrow, col)
        end
    end,
    ["paralep_r"] = function(x2, y, count, size, sizeofrow, col)
        for x=0,sizeofrow do
           -- tile:Create(x2+x * size,y, size/2)
            tiles:CreateRowDow(x2+x * size, y, size, count, col)
        end
    end
}
function tiles:CreateMapFull(x, y, numbers, size, formula, sizeofrow, col)
    formulas[formula](x,y,numbers, size, sizeofrow, col)
end
function tiles:Think()
    size = 2
    color = Color(2,2,2)

    for k,v in pairs(tilesblock) do
        if v and v.Position then
            size = v.Size or size
            color = v.Color or color
            love.graphics.setColor(color.r/255,color.g/255,color.b/255, (color.a or 255)/255)
            if v.Phys then
                love.graphics.polygon("fill", v.Phys.b:getWorldPoints(
                           v.Phys.s:getPoints()))
            end
            love.graphics.rectangle( "fill", v.Position.x or 0, v.Position.y or 0, size, size)
            love.graphics.setColor(1, 1, 1,1)
            if v.Think then
                v:Think()
            end
            if v.HasCollision then
                love.graphics.print(v.Health,v.Position['x'] - 33,v.Position['y'] - 44)
            end
        end
    end
end
