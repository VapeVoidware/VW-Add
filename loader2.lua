--[[
██╗   ██╗ ██████╗ ██╗██████╗ ██╗    ██╗ █████╗ ██████╗ ███████╗
██║   ██║██╔═══██╗██║██╔══██╗██║    ██║██╔══██╗██╔══██╗██╔════╝
██║   ██║██║   ██║██║██║  ██║██║ █╗ ██║███████║██████╔╝█████╗  
╚██╗ ██╔╝██║   ██║██║██║  ██║██║███╗██║██╔══██║██╔═══╝ ██╔══╝  
 ╚████╔╝ ╚██████╔╝██║██████╔╝╚███╔███╔╝██║  ██║██║     ███████╗
  ╚═══╝   ╚═════╝ ╚═╝╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     ╚══════╝

                🚀 VOIDWARE — Loader 🚀
----------------------------------------------------------------------------
  IMPORTANT:
  You must copy and use the FULL script below. Do NOT press on the link.:

  loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/loader.lua", true))()

----------------------------------------------------------------------------
  For support head over to discord.gg/voidware
----------------------------------------------------------------------------
]]
repeat task.wait() until game:IsLoaded()
local meta = {
    [2619619496] = {
        title = "Bedwars",
        dev = "vwdev/vwrw.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VWRewrite/"..(shared.CustomCommit and tostring(shared.CustomCommit) or "main").."/NewMainScript.lua"
    },
    [7008097940] = {
        no = true,
        title = "Ink Game",
        dev = "vwdev/inkgame.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..(shared.CustomCommit and tostring(shared.CustomCommit) or "main").."/inkgame.lua",
    },
    [6331902150] = {
        title = "Forsaken",
        dev = "vwdev/forsaken.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..(shared.CustomCommit and tostring(shared.CustomCommit) or "main").."/forsaken.lua"
    },
    [7326934954] = {
        title = "99 Nights In The Forest",
        dev = "vwdev/nightsintheforest.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..(shared.CustomCommit and tostring(shared.CustomCommit) or "main").."/nightsintheforest.lua"
    },
    [8316902627] = {
        staging = true,
        title = "Plants VS Brainrots",
        dev = "vwdev/plantsvsbrainrots.lua",
        script = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..(shared.CustomCommit and tostring(shared.CustomCommit) or "main").."/plantsvsbrainrots.lua"
    }
}
local data = meta[game.GameId]
pcall(function()
    shared.ACTIVE_LOADER:Destroy()
end)
local timedFunction = function(call, timeout, resFunction, ...)
	local suc, err
	local args = {}
	if call ~= nil and call == true then
		call = timeout
		timeout = 5
		args = {resFunction, ...}
	end
	task.spawn(function()
		suc, err = pcall(function()
			return call(unpack(args))
		end)
	end)
	timeout = timeout or 5
	local start = tick()
    repeat task.wait() until suc ~= nil or tick() - start >= timeout
	if suc == nil then
		suc = false
		err = "TIMEOUT_EXCEEDED"
	end
	if not suc then
		warn(debug.traceback(err))
	end
	if resFunction ~= nil and type(resFunction) == "function" then
		return resFunction(suc, err)
	end
	return suc, err
end
local __def_table = setmetatable({}, {
    __index = function(self) return self end,
    __call = function(self) return self end,
    __newindex = function(self) return self end
})
local loaderFile
if data ~= nil and data.no then
    loaderFile = __def_table
end
loaderFile = loaderFile or timedFunction(function()
    local data = game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/3ec1c4abde539b3587265577e5c3dfe94d2f1b30/libraries/loader.lua", true)
    if data ~= nil then
        timedFunction(function()
            if not isfolder("voidware_libraries") then makefolder("voidware_libraries") end
            writefile("voidware_libraries/loader.lua", data)
        end, 1)
    end
    return loadstring(data)()
end, 5, function(suc, err)
    return suc and err or timedFunction(function()
        if not isfolder("voidware_libraries") then makefolder("voidware_libraries") end
        if not isfile("voidware_libraries/loader.lua") then 
            error("loader file missing!")
            return
        end
        return loadstring(readfile("voidware_libraries/loader.lua"))()
    end, 5, function(suc, err)
        return suc and err or __def_table
    end)
end)
loaderFile.Colors.Gradient = {
	ColorSequenceKeypoint.new(0, Color3.fromHex("#ffd6e8")),
	ColorSequenceKeypoint.new(0.5, Color3.fromHex("#ff8fab")),
	ColorSequenceKeypoint.new(1, Color3.fromHex("#ff477e")),
}
local loader = loaderFile:Loader()
shared.ACTIVE_LOADER = loader
loader:Connect(function(res)
    if shared.VoidDev then
        warn(`LOADER RESULT: {tostring(res)}`)
    end
    shared.ACTIVE_LOADER = nil
end)
loader:Update("Booting Up...", 0)
loader:Update("Fetching Game Data...", 10)

if data and data.staging and not shared.VoidDev then
    data = nil
end
if not data then
    loader:Abort(`Unsupported game :c`)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Voidware | Loader",
        Text = "Unsupported game :c",
        Duration = 15
    })
    return
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Voidware | Loader",
        Text = "Loading for "..tostring(data.title).."...",
        Duration = 15
    })
    loader:Update(`Preparing Voidware {tostring(data.title)}...`, 40)
    local res, err
    if shared.VoidDev and data.dev ~= nil and pcall(function() return isfile(data.dev) end) then
        res, err = loadstring(readfile(data.dev))
    else
        res, err = loadstring(game:HttpGet(data.script, true))
    end
    if type(res) ~= "function" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware Loading Error",
            Text = tostring(res),
            Duration = 15
        })
        loader:Abort(`Loading Failed {tostring(err)} :c \n Please try again later\n`)
        task.delay(0.5, function()
            if shared.VoidDev then return end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware Loading Error",
                Text = "Please report this issue to erchodev#0 \n or in discord.gg/voidware",
                Duration = 15
            })
        end)
    else
        loader:Update(`Loading Voidware...`, 60)
        local suc, err = pcall(res)
        if not suc then
            loader:Abort(`Main Loading Error {tostring(err)} :c \n Please try again later\n`)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware Main Error",
                Text = tostring(err),
                Duration = 15
            })
            task.delay(0.5, function()
                if shared.VoidDev then return end
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Voidware Main Error",
                    Text = "Please report this issue to erchodev#0 \n or in discord.gg/voidware",
                    Duration = 15
                })
            end)
        else
            loader:Update(`Finishing Up...`, 80)
            shared.ACTIVE_LOADER = nil
            loader:Update(`Successfully loaded Voidware {tostring(data.title)} :D`, 100)
            task.delay(0.5, function()
                pcall(function()
                    loader:Destroy()
                end)
            end)
        end
    end
end