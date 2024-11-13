PARC = {}
PARC_NOW = {}
PARCB = {}

function PARCB:Remove()
    PARC_NOW[self.ID] = nil
    self = nil
end
function PARCB:New(color, dt, size, pos, think)
    local p = Copy(PARCB)
    p.Position = {}
    p.Position.x = pos.x
    p.Position.y = pos.y
    p.Color = color
    p.Size = {x = size, y = size}

    p.DieTime = dt + RealTime()

    p.Think = think
    p.ID = #PARC_NOW + 1
    PARC_NOW[#PARC_NOW + 1] = p
    return PARC_NOW[#PARC_NOW]
end
function PARC:Think()
    size = {1,1}
    color = Color(2,2,2)

    for k,v in pairs(PARC_NOW) do
        if v and v.Position and not v.Removed then
            size = v.Size
            color = Copy(v.Color)
            pos = v.Position
            love.graphics.setColor(color.r/255,color.g/255,color.b/255, (color.a or 255)/255)
            if v.img then
                love.graphics.draw( v.img, pos['x'], pos['y'], 0, size.x, size.y)
            else
                love.graphics.rectangle( "fill", v.Position.x or 0, v.Position.y or 0, size.x, size.y)
            end
            love.graphics.setColor(1, 1, 1, 1)
            if v.Think then
                v:Think()
            end
            if v.DieTime and v.DieTime < RealTime() then
                v:Remove()
            end
        end
    end
end