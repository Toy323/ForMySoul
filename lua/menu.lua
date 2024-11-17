local back = love.graphics.newImage('images/back.png')
local forward = love.graphics.newImage('images/forward.png')
local options = love.graphics.newImage('images/options.png')
local almanax = love.graphics.newImage('images/ab_enemy.png')
local resume2 = love.graphics.newImage('images/256_ready.png')
menus = {}
local sliders = {}
function menus:update(time)
    for k,v in pairs(sliders) do
        v:update()
    end
end
function menus:draw()
    for k,v in pairs(sliders) do
        v:draw()
        if v.DrawTextAbove then
            love.graphics.setFont(FONTS_MODULES["opensansc21"])
            love.graphics.print(string.format(v.DrawTextAbove,v:getValue()*100),v.x - v.length/2,v.y - 48)
        end
    end
end
local cache2 = {}
function loadAlmanax()
    local x2,y2 = love.graphics.getDimensions()
    local button = BUTTON.AddButton(1,x2/12 - 64/2,y2/1.2 - 64/2,Color(90,0,0),1,1, back)

    button.OnClickDo = function()
        BUTTON.RemoveButton(button.ID)
        remCache2()
        loadMenu()
    end
    local enemies = BASE_ENEMY.enemiesList
    local es = {}
    local i = 0
    for k,v in pairs(enemies) do
        es[i] = v 
        i = i + 1
    end
    local v = es[0]
    local size = v.Size
    local g = BUTTON.AddButton(size, x2/3,y2/3, v.Color)
    g.ID2 = 0
    g.Aaa = es[0]
    g["txt"] = "Здоровья:"..g.Aaa.HP.."\nСкорость:"..g.Aaa.MovementSpeed
    g["xt"] = -55
    g["yt"] = -55
    g["colt"] = Color(182,182,182)
    cache2[#cache2 + 1] = g.ID
    g.OnClickDo = function()
        g.Aaa = es[(g.ID2 + 1) % Count(es)]
        g.ID2 = g.ID2 + 1
        g.Color = g.Aaa.Color
        g.Size = {x = g.Aaa.Size, y = g.Aaa.Size}

        g["txt"] = "Здоровья:"..g.Aaa.HP.."\nСкорость:"..g.Aaa.MovementSpeed
        g["xt"] =  -55
        g["yt"] = -55
        g["colt"] = Color(182,182,182)
    end
    g.OnSeen = function(x,y)
        if g.Aaa then
            love.graphics.setColor(0.1,.1,.1)
            love.graphics.print(g.Aaa.Desc,x+1,y+33)
            love.graphics.setColor(1,1,1)
            love.graphics.print(g.Aaa.Desc,x,y+32)
        end
    end
end

function loadInfo()
    local x2,y2 = love.graphics.getDimensions()
    local button = BUTTON.AddButton(1,x2/12 - 64/2,y2/1.2 - 64/2,Color(90,0,0),1,1, back)

    button.OnClickDo = function()
        love.timer.sleep(0.1)
        BUTTON.RemoveButton(button.ID)
        remCache2()
        loadMenu()
    end


    local button = BUTTON.AddButton(1,x2*0.03,y2/8,Color(99,88,77),77, 48, nil, {"Об Игре", 0, 22})
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        --Костыли!!!
    end
    button.OnSeen = function(x,y)
        local desc = [[Эта игра в стиле Tower Defense
        Основные игровые ресурсы - это ресурс и энергия.
        Вам выдают 10000 очков здоровья в начале игры, каждый враг,прошедший в конец, отнимает ваши ОЗ равному своему текущему ОЗ.
        Чтобы защищаться от врагов - вам надо ставить всякого рода сооружeния, от безобидных добытчиком, до лазеров.
        Враги могут ходить между линиями!
        Некоторые сооружения можно совмещать, они будут светится если вы взяли постройку которая совмещается с ним, не забывайте экспериментировать!
        Выбирать можно до 9 сооружений.
        Чтобы начать игру надо нажать на галочку(она зеленая).
        Желтоватая странная иконка - это рестарт раунда, так что можно быстро перезапускать раунд.
        ]]
        local x,y = x2*0.06, y2/4
        love.graphics.setFont(FONTS_MODULES["opensansc22"])
        love.graphics.setColor(0.1,.1,.1)
        love.graphics.print( desc,x,y+33)
        love.graphics.setColor(1,1,1)
        love.graphics.print( desc,x,y+32)
    end
    
    local button = BUTTON.AddButton(1,x2*0.12,y2/8,Color(77,47,17),77, 48, nil, {"Об Ресурсах", 0, 22})
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        --Костыли!!!
    end
    button.OnSeen = function(x,y)
        local desc = [[Ресурсы - важный ресурс, без него тут не выжить
        Зарабатываются ресурсы с конца волны либо с добытчиком.
        За конец волны вам дают 175 + 35*волна единиц ресурса.
        Ресурсы могут быть украдены у вас, в основном это происходит на локации 'Пустыня', некоторые враги воруют ресурсы там.
        ]]
        local x,y = x2*0.06, y2/4
        love.graphics.setFont(FONTS_MODULES["opensansc22"])
        love.graphics.setColor(0.1,.1,.1)
        love.graphics.print( desc,x,y+33)
        love.graphics.setColor(1,1,1)
        love.graphics.print( desc,x,y+32)
    end


    local button = BUTTON.AddButton(1,x2*0.2,y2/8,Color(77,47,17),77, 48, nil, {"ААА", 0, 22})
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        --Костыли!!!
    end
    button.OnSeen = function(x,y)
        local desc = [[Это плейсхолдер для каких-то текстов.
        ]]
        local x,y = x2*0.06, y2/4
        love.graphics.setFont(FONTS_MODULES["opensansc22"])
        love.graphics.setColor(0.1,.1,.1)
        love.graphics.print( desc,x,y+33)
        love.graphics.setColor(1,1,1)
        love.graphics.print( desc,x,y+32)
    end


end

function loadSet()
    local x2,y2 = love.graphics.getDimensions()
    local button = BUTTON.AddButton(1,x2/12 - 64/2,y2/1.2 - 64/2,Color(90,0,0),1,1, back)

    button.OnClickDo = function()
        love.timer.sleep(0.1)
        BUTTON.RemoveButton(button.ID)
        remCache2()
        loadMenu()
        sliders["musicslider"] = nil
    end
    
    sliders["musicslider"] = newSlider(x2/5,y2/3,200,mVolume or 0.45,0,1, function(vol)
        mVolume = vol
    end)
    sliders["musicslider"].DrawTextAbove = "Громкость всех звуков: %s"

end

function remCache2()
    for k,v in pairs(cache2) do
        BUTTON.RemoveButton(v)
    end
    cache2 = {}
end
local locID = {
    ["Flatland"] = 1,
    ["Desert"] = 2,
    ["Graveyard"] = 3,
    [1] = "Flatland",
    [2] = "Desert",
    [3] = "Graveyard"
}

BASE_MODULE.Location = "Flatland"
local descosLoc = {
    ["Flatland"] = "СМЕНИТЬ ЛОКАЦИЮ НА: Плоскоземле\nБесконечный мир досея, самые адекватные враги ждут вас тут.\nЛокация без особенностей.\nФинальная волна - 65, после нее бесконечный режим.",
    ["Desert"] = [[CМЕНИТЬ ЛОКАЦИЮ НА: Пустыня 'Дюнида'
    После нападения на плоскоземле, вы ушли в пустыню, чтобы сразить врагов там.
    Тут ждут улучшенные версии врагов и новая форма - треугольник
    Особенность: Пустыня не терпит ваши постройки, они постепенно умирают.
    Знайте, за вами отправили более устрашающее войско.
    Финальная волна - 400, после нее бесконечный режим.]],
    ["Graveyard"] = [[CМЕНИТЬ ЛОКАЦИЮ НА: Кладбище древности
    Прошли сквозь Пустыню?А тeпeрь...Кладбище - Досея, множество мелких врагов...
    Кое-кто вас ждет.
    Особенность: Враги постоянно оживают и часть клеток становятся не используемыми.
    Финальная волна - 150, последняя уникальная волна - 500.]],

}
function loadMenu(arguments)
    local x2,y2 = love.graphics.getDimensions()
    local button = BUTTON.AddButton(1,x2/2- 256/2,y2/2 - 256/2,Color(0,90,15),1,1, resume2)
    local budid = button.ID
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        remCache2()
        loadGame()
        BASE_MODULE.Location = BASE_MODULE.SelLoc or "Flatland"
    end
    local button = BUTTON.AddButton(1,x2/3- 256/2,y2/2 - 256/2,Color(90,78,0),1,1, almanax)
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        remCache2()
        loadAlmanax()
    end

    local button = BUTTON.AddButton(1,x2/1.3 - 256/2,y2/2 - 256/2,Color(0,0,0),1,1, forward)
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        if GetLocationFeatures().Music then
            BASE_MODULE.Sounds["Music"][BASE_MODULE.Location]:setLooping(false)
            BASE_MODULE.Sounds["Music"][BASE_MODULE.Location]:stop()
        end
        BASE_MODULE.Location = locID[locID[BASE_MODULE.Location] + 1] or "Flatland"
        BASE_MODULE.SelLoc = BASE_MODULE.Location
        if GetLocationFeatures().Music then
            BASE_MODULE.Sounds["Music"][BASE_MODULE.Location]:setVolume(mVolume or 0.45)
            BASE_MODULE.Sounds["Music"][BASE_MODULE.Location]:setLooping(true)
            BASE_MODULE.Sounds["Music"][BASE_MODULE.Location]:play()
        end
    end
    button.OnSeen = function(x,y)
        local desc = descosLoc[locID[locID[BASE_MODULE.Location] + 1] or "Flatland"]
        love.graphics.setColor(0.1,.1,.1)
        love.graphics.print( desc,x+1,y+33)
        love.graphics.setColor(1,1,1)
        love.graphics.print( desc,x,y+32)
    end


    local button = BUTTON.AddButton(1,x2/1.3 - 256/2,y2/1.75,Color(101,101,101),48, 48, nil, {"i", 16, 0, nil, "opensansc32"})
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        remCache2()
        loadInfo()
    end
    button.OnSeen = function(x,y)
        local desc = "Информация об игре."
        love.graphics.setColor(0.1,.1,.1)
        love.graphics.print( desc,x+1,y+33)
        love.graphics.setColor(1,1,1)
        love.graphics.print( desc,x,y+32)
    end

    local button = BUTTON.AddButton(1,x2/1.3 - 256/2,y2/1.25,Color(75,75,75),1, 1, options)
    cache2[#cache2 + 1] = button.ID
    button.OnClickDo = function()
        remCache2()
        loadSet()
    end
end