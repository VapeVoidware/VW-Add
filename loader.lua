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
    }
}
local data = meta[game.GameId]
if not data then
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
    local res
    if shared.VoidDev and data.dev ~= nil and pcall(function() return isfile(data.dev) end) then
        res = loadstring(readfile(data.dev))
    else
        res = loadstring(game:HttpGet(data.script, true))
    end
    if type(res) ~= "function" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware Loading Error",
            Text = tostring(res),
            Duration = 15
        })
        task.delay(0.5, function()
            if shared.VoidDev then return end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware Loading Error",
                Text = "Please report this issue to erchodev#0 \n or in discord.gg/voidware",
                Duration = 15
            })
        end)
    else
        local suc, err = pcall(res)
        if not suc then
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
        end
    end
end