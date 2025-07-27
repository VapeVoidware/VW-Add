game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Voidware - Anticheat Test | Ink Game",
    Text = "Your executor "..(hookmetamethod ~= nil and "supports ✅" or "doesn't support ❌").." the anticheat patch!",
    Duration = 10
})