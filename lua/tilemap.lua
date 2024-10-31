
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
    return selfy
end
function tile:SetColor(color)
    self.Color = {}
    self.Color = color
    tilesblock[self.ID].Color = color
end
tile.BHealth = 325
tile.Health = 325

function tile:OnContact(enemy)
    if enemy and enemy.Phys and enemy.Phys.b then
        if enemy.GetSpeed and enemy:GetSpeed() then
            enemy.Phys.b:applyForce(enemy:GetSpeed()*85, 0)
            if enemy.AttackSpeed and (enemy.NextEat or 0) < CurTime() then
                self.Health = self.Health - 25 * enemy.DamageX 
                enemy.NextEat = CurTime() + enemy.AttackSpeed*5
                enemy.NoWalk = CurTime() + 0.4
                if self.Health <= 0 then
                    self:Remove()
                end
            end
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
    tile.Health = tile.BHealth
    tile.SizeY = tile.Size
    if self.Init then
        self:Init()
    end
    if not self.HasCollision then
        self.World = BASE_MODULE.world
        static = {}
        static.b = love.physics.newBody(BASE_MODULE.world, self.Position["x"],self.Position["y"], "static")
        static.b:setFixedRotation(true)
        static.s = love.physics.newRectangleShape(self.SizeX or self.Size,self.SizeY or self.Size)       
        static.f = love.physics.newFixture(static.b, static.s)
        static.f:setGroupIndex(-48)
        static.f:setUserData(tostring(self.ID))
        static.f:setRestitution(0.1) 
        self.Phys = static
        self.HasCollision = true
    end
    if self.InitB then
        self:InitB()
    end
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
        if v and v.Position and (v.World == BASE_MODULE.world or not v.World) then
            size = v.Size or size
            color = Copy(v.Color or color)
            love.graphics.setColor(color.r/255,color.g/255,color.b/255, (color.a or 255)/255)
            local finded = false
            if SELECTED_TOOL ~= 0 and type(SELECTED_TOOL) == "table" and v.WeaponOnMe and SELECTED_TOOL.WeaponOnMe then
                if WEAPONS.IDFusion[v.WeaponOnMe.."plus"..SELECTED_TOOL.WeaponOnMe] or WEAPONS.IDFusion[SELECTED_TOOL.WeaponOnMe.."plus"..v.WeaponOnMe] then
                    color.g = color.g * math.abs(math.sin(CurTime()*3))
                    color.r = color.r * 0.3
                    color.b = color.b * 0.3
                    love.graphics.setColor(color.r/255,color.g/255,color.b/255)
                end
                local x,y = v.Position.x,v.Position.y
                local x3,y3 = love.mouse.getPosition()
                local x2,y2 = v.Size, v.Size
                if x3 < x + x2 and x3 > x and y3 < y + y2 and y3 > y then
                    finded = true
               end
            end
            if v.Phys then
                love.graphics.polygon("fill", v.Phys.b:getWorldPoints(
                           v.Phys.s:getPoints()))
            end
            love.graphics.rectangle( "fill", v.Position.x or 0, v.Position.y or 0, size, size)
            love.graphics.setColor(1, 1, 1,1)
            if v.Think then
                v:Think()
            end
            if v.Draw then
                v:Draw(v.Phys.b:getX(), v.Phys.b:getY())
            end
            if v.HasCollision then
                love.graphics.print(v.Health,v.Position['x'] - size,v.Position['y'] - size/1.5)
                love.graphics.print(math.ceil((v.NextShoot-CurTime())*100)/100, v.Position['x'] - size,v.Position['y'] - size/2)
            end
            if finded then
                local i = WEAPONS.IDFusion[v.WeaponOnMe.."plus"..SELECTED_TOOL.WeaponOnMe] or WEAPONS.IDFusion[SELECTED_TOOL.WeaponOnMe.."plus"..v.WeaponOnMe]
                if WEAPONS.FusionsDesc[i] then
                    local x3,y3 = love.mouse.getPosition()
                    love.graphics.setColor(0.1,.1,.1)
                    love.graphics.print( WEAPONS.FusionsDesc[i],x3+1,y3+33)
                    love.graphics.setColor(1,1,1)
                    love.graphics.print( WEAPONS.FusionsDesc[i],x3,y3+32)
                    love.graphics.setColor(color.r/255,color.g/255,color.b/255)
                end
            end
        end
    end
end
