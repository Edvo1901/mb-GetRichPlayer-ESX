function sendToDiscord(message) --Functions to send the log to discord
    local time = os.date("*t")

    local embed = {
            {
                ["color"] = Config.LogColour, --Set color
                ["author"] = {
                    ["icon_url"] = Config.AvatarURL, -- et avatar
                    ["name"] = Config.ServerName, --Set name
                },
                ["title"] = "**".. Config.LogTitle .."**", --Set title
                ["description"] = message, --Set message
                ["footer"] = {
                    ["text"] = '' ..time.year.. '/' ..time.month..'/'..time.day..' '.. time.hour.. ':'..time.min, --Get time
                },
            }
        }

    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    while (Config.SendLogByTime.enable) do
        Citizen.Wait(Config.SendLogByTime.time * (60 * 1000)) --Wait time before trigger the event
        TriggerEvent("mb-GetRichPlayer:server:sendLog") --Trigger sending log event
    end
end)

--Admin command to trigger the event without waititng for the timer or simply you disable the auto log feature
ESX.RegisterCommand(TranslateCap('command_name'), 'admin', function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("mb-GetRichPlayer:server:getTopPlayerMoney", Config.LogMessageType)
    else
        TriggerEvent("mb-GetRichPlayer:server:getAllPlayerMoney", Config.LogMessageType)
    end
end, true, {help = TranslateCap('command_help')})

--Event for TOP RICHEST ONLY
RegisterNetEvent("mb-GetRichPlayer:server:getTopPlayerMoney", function(type)
    if (type == "full") then
        local topRichestPlayers
        local resultWithLicense = ''

        if Config.BlackMoney then
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        else
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        end

        for _, v in pairs(topRichestPlayers) do
            resultWithLicense = resultWithLicense .. "`" .. _ .. "." .. TranslateCap('message_with_license', topRichestPlayers[_]["full_name"], topRichestPlayers[_]["identifier"], topRichestPlayers[_]["accounts"], topRichestPlayers[_]["total_money"])
        end

        sendToDiscord(resultWithLicense) --Send log to discord
    elseif (type == "standard") then
        local topRichestPlayers
        local resultWithoutLicense = ''

        if Config.BlackMoney then
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        else
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        end

        for _, v in pairs(topRichestPlayers) do
            resultWithoutLicense = resultWithoutLicense .. "`" .. _ .. "." .. TranslateCap('message_without_license', topRichestPlayers[_]["full_name"], topRichestPlayers[_]["accounts"], topRichestPlayers[_]["total_money"])
        end

        sendToDiscord(resultWithoutLicense) --Send log to discord
    else
        local topRichestPlayers
        local shortMsg = ''

        if Config.BlackMoney then
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        else
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
        end

        for _, v in pairs(topRichestPlayers) do
            shortMsg = shortMsg .. "`" .. _ .. "." .. TranslateCap('message_short', topRichestPlayers[_]["full_name"], topRichestPlayers[_]["total_money"])
        end

        sendToDiscord(shortMsg) --Send log to discord
    end
end)

--Event for ALL PLAYER
RegisterNetEvent("mb-GetRichPlayer:server:getAllPlayerMoney", function(type)
    if (type == "full") then
        local topRichestPlayers
        local resultWithLicense = ''

        if Config.BlackMoney then
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
        else
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
        end

        for _, v in pairs(topRichestPlayers) do
            resultWithLicense = resultWithLicense .. "`" .. _ .. "." .. TranslateCap('message_with_license', topRichestPlayers[_]["full_name"], topRichestPlayers[_]["identifier"], topRichestPlayers[_]["accounts"], topRichestPlayers[_]["total_money"])
        end

        sendToDiscord(resultWithLicense) --Send log to discord
    elseif (type == "standard") then
        local topRichestPlayers
        local resultWithoutLicense = ''

        if Config.BlackMoney then
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
        else
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
        end

        for _, v in pairs(topRichestPlayers) do
            resultWithoutLicense = resultWithoutLicense .. "`" .. _ .. "." .. TranslateCap('message_without_license', topRichestPlayers[_]["full_name"], topRichestPlayers[_]["accounts"], topRichestPlayers[_]["total_money"])
        end

        sendToDiscord(resultWithoutLicense) --Send log to discord
    else
        local topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
        local shortMsg = ''

        if Config.BlackMoney then
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
        else
            topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
        end

        for _, v in pairs(topRichestPlayers) do
            shortMsg = shortMsg .. "`" .. _ .. "." .. TranslateCap('message_short', topRichestPlayers[_]["full_name"], topRichestPlayers[_]["total_money"])
        end

        sendToDiscord(shortMsg) --Send log to discord
    end
end)

--Auto send log to discord
RegisterNetEvent("mb-GetRichPlayer:server:sendLog", function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("mb-GetRichPlayer:server:getTopPlayerMoney", Config.LogMessageType)
    else
        TriggerEvent("mb-GetRichPlayer:server:getAllPlayerMoney", Config.LogMessageType)
    end
end)
