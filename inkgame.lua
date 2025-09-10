--[[
██╗   ██╗ ██████╗ ██╗██████╗ ██╗    ██╗ █████╗ ██████╗ ███████╗
██║   ██║██╔═══██╗██║██╔══██╗██║    ██║██╔══██╗██╔══██╗██╔════╝
██║   ██║██║   ██║██║██║  ██║██║ █╗ ██║███████║██████╔╝█████╗  
╚██╗ ██╔╝██║   ██║██║██║  ██║██║███╗██║██╔══██║██╔═══╝ ██╔══╝  
 ╚████╔╝ ╚██████╔╝██║██████╔╝╚███╔███╔╝██║  ██║██║     ███████╗
  ╚═══╝   ╚═════╝ ╚═╝╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     ╚══════╝

                🚀 VOIDWARE — Ink Game 🚀
----------------------------------------------------------------------------
  IMPORTANT:
  You must copy and use the FULL script below. Do NOT press on the link.:

  loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/loader.lua", true))()

----------------------------------------------------------------------------
  For support head over to discord.gg/voidware
----------------------------------------------------------------------------
]]
if not game:IsLoaded() then return end
local CheatEngineMode = false
if (not getgenv) or (getgenv and type(getgenv) ~= "function") then CheatEngineMode = true end
if getgenv and not getgenv().shared then CheatEngineMode = true; getgenv().shared = {}; end
if getgenv and not getgenv().debug then CheatEngineMode = true; getgenv().debug = {traceback = function(string) return string end} end
if getgenv and not getgenv().require then CheatEngineMode = true; end
if getgenv and getgenv().require and type(getgenv().require) ~= "function" then CheatEngineMode = true end
local debugChecks = {
    Type = "table",
    Functions = {
        "getupvalue",
        "getupvalues",
        "getconstants",
        "getproto"
    }
}
local function checkExecutor()
    if identifyexecutor ~= nil and type(identifyexecutor) == "function" then
        local suc, res = pcall(function()
            return identifyexecutor()
        end)   
        --local blacklist = {'appleware', 'cryptic', 'delta', 'wave', 'codex', 'swift', 'solara', 'vega'}
        local blacklist = {'solara', 'cryptic', 'xeno', 'ember', 'ronix'}
        local core_blacklist = {'solara', 'xeno'}
        if suc then
            for i,v in pairs(blacklist) do
                if string.find(string.lower(tostring(res)), v) then CheatEngineMode = true end
            end
            for i,v in pairs(core_blacklist) do
                if string.find(string.lower(tostring(res)), v) then
                    pcall(function()
                        getgenv().queue_on_teleport = function() warn('queue_on_teleport disabled!') end
                    end)
                end
            end
        end
    end
end
task.spawn(function() pcall(checkExecutor) end)
local function checkDebug()
    if CheatEngineMode then return end
    if not getgenv().debug then 
        CheatEngineMode = true 
    else 
        if type(debug) ~= debugChecks.Type then 
            CheatEngineMode = true
        else 
            for i, v in pairs(debugChecks.Functions) do
                if not debug[v] or (debug[v] and type(debug[v]) ~= "function") then 
                    CheatEngineMode = true 
                else
                    local suc, res = pcall(debug[v]) 
                    if tostring(res) == "Not Implemented" then 
                        CheatEngineMode = true 
                    end
                end
            end
        end
    end
end
--if (not CheatEngineMode) then checkDebug() end
shared.CheatEngineMode = shared.CheatEngineMode or CheatEngineMode

--[[task.spawn(function()
    pcall(function()
        local Services = setmetatable({}, {
            __index = function(self, key)
                local suc, service = pcall(game.GetService, game, key)
                if suc and service then
                    self[key] = service
                    return service
                else
                    warn(`[Services] Warning: "{key}" is not a valid Roblox service.`)
                    return nil
                end
            end
        })

        local Players = Services.Players
        local TextChatService = Services.TextChatService
        local ChatService = Services.ChatService
        repeat
            task.wait()
        until game:IsLoaded() and Players.LocalPlayer ~= nil
        local chatVersion = TextChatService and TextChatService.ChatVersion or Enum.ChatVersion.LegacyChatService
        local TagRegister = shared.TagRegister or {}
        if not shared.CheatEngineMode then
            if chatVersion == Enum.ChatVersion.TextChatService then
                TextChatService.OnIncomingMessage = function(data)
                    TagRegister = shared.TagRegister or {}
                    local properties = Instance.new("TextChatMessageProperties", game:GetService("Workspace"))
                    local TextSource = data.TextSource
                    local PrefixText = data.PrefixText or ""
                    if TextSource then
                        local plr = Players:GetPlayerByUserId(TextSource.UserId)
                        if plr then
                            local prefix = ""
                            if TagRegister[plr] then
                                prefix = prefix .. TagRegister[plr]
                            end
                            if plr:GetAttribute("__OwnsVIPGamepass") and plr:GetAttribute("VIPChatTag") ~= false then
                                prefix = prefix .. "<font color='rgb(255,210,75)'>[VIP]</font> "
                            end
                            local currentLevel = plr:GetAttribute("_CurrentLevel")
                            if currentLevel then
                                prefix = prefix .. string.format("<font color='rgb(173,216,230)'>[</font><font color='rgb(255,255,255)'>%s</font><font color='rgb(173,216,230)'>]</font> ", tostring(currentLevel))
                            end
                            local playerTagValue = plr:FindFirstChild("PlayerTagValue")
                            if playerTagValue and playerTagValue.Value then
                                prefix = prefix .. string.format("<font color='rgb(173,216,230)'>[</font><font color='rgb(255,255,255)'>#%s</font><font color='rgb(173,216,230)'>]</font> ", tostring(playerTagValue.Value))
                            end
                            prefix = prefix .. PrefixText
                            properties.PrefixText = string.format("<font color='rgb(255,255,255)'>%s</font>", prefix)
                        end
                    end
                    return properties
                end
            elseif chatVersion == Enum.ChatVersion.LegacyChatService then
                ChatService:RegisterProcessCommandsFunction("CustomPrefix", function(speakerName, message)
                    TagRegister = shared.TagRegister or {}
                    local plr = Players:FindFirstChild(speakerName)
                    if plr then
                        local prefix = ""
                        if TagRegister[plr] then
                            prefix = prefix .. TagRegister[plr]
                        end
                        if plr:GetAttribute("__OwnsVIPGamepass") and plr:GetAttribute("VIPChatTag") ~= false then
                            prefix = prefix .. "[VIP] "
                        end
                        local currentLevel = plr:GetAttribute("_CurrentLevel")
                        if currentLevel then
                            prefix = prefix .. string.format("[%s] ", tostring(currentLevel))
                        end
                        local playerTagValue = plr:FindFirstChild("PlayerTagValue")
                        if playerTagValue and playerTagValue.Value then
                            prefix = prefix .. string.format("[#%s] ", tostring(playerTagValue.Value))
                        end
                        prefix = prefix .. speakerName
                        return prefix .. " " .. message
                    end
                    return message
                end)
            end
        end
    end)
end)--]]

--game:GetService("Players").LocalPlayer:Kick("Voidware Is Temporarily Down. Please wait while we bring it back discord.gg/voidware :c")
local IS_DOWN = false

if IS_DOWN and not shared.BYPASS_VW_PROTECTION then

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Voidware | Ink Game",
        Text = "Voidware is currently down! Please wait until we patch the anticheat once again :c",
        Duration = 10
    })

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Voidware | Discord",
        Text = "Join discord.gg/voidware for updates",
        Duration = 10
    })

else
    local commit = shared.CustomCommit and tostring(shared.CustomCommit) or shared.StagingMode and "staging" or "0f3445958b07a5f7eabe98c1dd1f378ac227dd31"

    local verified_executors = {"jjs", "valex", "hydrogen", "delta", "solara", "krnl"}
    local suc, current_executor = pcall(function()
        return string.lower(tostring(identifyexecutor()))
    end)
    if not suc then shared.CheatEngineMode = true end
    local verified = false
    if not shared.CheatEngineMode then
        for _, v in pairs(verified_executors) do
            if string.find(current_executor, v) then
                verified = true
                break
            end
        end
    end

    --[[pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware | Ink Game | Announcment",
            Text = "Warning! After Ink Game updates voidware might become detected so be careful until we fully verify that vw works!",
            Duration = 10
        })
    end)--]]

    if (shared.CheatEngineMode or not verified) and not shared.AcceptedRisksOfBan then
        if not shared.CheatEngineMode and not verified then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware | Ink Game",
                Text = "Warning! Your executor hasn't been tested yet if it's going to be able to bypass the anticheat!",
                Duration = 10
            })
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware | Currently Tested Executors",
                Text = "The following executors have been tested as fully working: " .. table.concat(verified_executors, ", "),
                Duration = 10
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Voidware | Ink Game",
                Text = "Warning! Your executor might not support all functions needed to patch the anticheat!",
                Duration = 10
            })
        end
        --[[game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware | Ink Game",
            Text = "If you understand the risk of getting banned by using your executor, execute the script again.",
            Duration = 10
        })--]]
        shared.AcceptedRisksOfBan = true
        --return
    end

    --[[if not hookmetamethod then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware - Anticheat Test | Ink Game",
            Text = "Your executor "..(hookmetamethod ~= nil and "supports ✅" or "doesn't support ❌").." the anticheat patch!",
            Duration = 10
        })
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware - Anticheat Test | Ink Game",
            Text = "Please use a different executor! For support: discord.gg/voidware",
            Duration = 10
        })
        return
    end--]]

    --[[pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Voidware | Announcment",
            Text = "Warning: Rebelling with Voidware may lead to bans. Don't join Rebels and start a new game when one starts. Sorry for the inconvenience! We are working on it",
            Duration = 8
        })
    end)--]]

    task.spawn(function()
        pcall(function()
            if not hookmetamethod then return end
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..tostring(commit).."/inkgamereducer.lua", true))()
        end)
    end)

    loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/"..tostring(commit).."/newinkgame.lua", true))()
end
