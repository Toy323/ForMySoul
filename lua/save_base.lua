local function runFile(name)
	local ok, chunk, err = pcall(love.filesystem.load, name) -- load the chunk safely
	if not ok    then  return false, "Failed loading code: "..chunk  end
	if not chunk then  return false, "Failed reading file: "..err    end

	local ok, value = pcall(chunk) -- execute the chunk safely
	if not ok then  return false, "Failed calling chunk: "..tostring(value)  end

	return true, value -- success!
end


function dataLoad()
    file = love.filesystem.read("Data.txt")
    if file then
        data = lume.deserialize(file)
        if data  then
            Session = data.Session
        end
        print(Session)
    end
    modmanager = love.filesystem.read("manager_mods.txt")
    local t = {}
    if modmanager then
        for line in love.filesystem.lines("manager_mods.txt") do
            t[#t+1]=line
            print(line)
            if line == "No" then
                break
            end
            local state, func = runFile(line)
            if state then
                print(func())
            end
        end
    else
        love.filesystem.write("manager_mods.txt", table.concat({"No"}, "\n"))
        for line in love.filesystem.lines("manager_mods.txt") do
            t[#t+1]=line    
            print(line)
        end
    end
end
function saveGame()
	data = {}
    data.Session = Session or "G_"..rand(0,256)
	serialized = lume.serialize(data)
  	love.filesystem.write("Data.txt", serialized)
end