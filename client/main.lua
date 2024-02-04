local isInFrisk = false

RegisterNetEvent('spy-frisk:client:openMenu',function()
    local optionsMenu = {}
    if Config.Dependency.UseMenu == 'qb' then
        optionsMenu[#optionsMenu+1] = { header = 'Frisk Menu',isMenuHeader = true}
        optionsMenu[#optionsMenu+1] = { icon = "fas fa-circle-xmark", header = "Close", params = { event = "spy:close" } }
    end
    for k, v in ipairs(Config.Menu) do
        if Config.Dependency.UseMenu == 'ox' then 
            optionsMenu[#optionsMenu+1] = {
                title = v.Label,
                description = v.Desc,
                icon = v.Icon,
                onSelect = function()
                    TriggerEvent('spy-frisk:client:startfrisk',false,k)                             
                end,
            }
        else
            optionsMenu[#optionsMenu+1] = { 
                header = v.Label,
                txt = v.Desc,
                icon = 'fas fa-'..v.Icon,
                params = {
                    isAction = true,
                    event = function()
                        TriggerEvent('spy-frisk:client:startfrisk',false,k) 
                    end
                } 
            }

        end
    end
    if Config.SearchAll.Enabled then
        if Config.Dependency.UseMenu == 'ox' then
            optionsMenu[#optionsMenu+1] = {
                title = Config.SearchAll.Label,
                description = Config.SearchAll.Desc,
                icon = Config.SearchAll.Icon,
                onSelect = function()
                    TriggerEvent('spy-frisk:client:startfrisk',true)                             
                end,
            }
        else
            optionsMenu[#optionsMenu+1] = { 
                header = Config.SearchAll.Label,
                txt = Config.SearchAll.Desc,
                icon = 'fas fa-'..Config.SearchAll.Icon,
                params = {
                    isAction = true,
                    event = function()
                        TriggerEvent('spy-frisk:client:startfrisk',true) 
                    end
                } 
            }
        end
    end
    if Config.Dependency.UseMenu == 'ox' then
        lib.registerContext({
            id = 'spyfriskM',
            title = 'Frisk Menu',
            options = optionsMenu
        })
        lib.showContext('spyfriskM')
    else
        exports['qb-menu']:openMenu(optionsMenu)
    end
end)


RegisterNetEvent('spy-frisk:client:startfrisk',function(SearchAll,Category)
    local ped = PlayerPedId()
    local player,targetPed,targetCoords = lib.getClosestPlayer(GetEntityCoords(ped), 1.5, false)
    if player then
        local targetId = GetPlayerServerId(player)
        if GlobalState.IsInFrisk[targetId] then NotifyPlayer('Player already in frisk!', 3000, 'error') return end
        if (IsPedInAnyVehicle(ped,true) or IsPedInAnyVehicle(targetPed,true)) then NotifyPlayer('Inside Vehicle!',3000,'error') return end
        TriggerServerEvent('spy-frisk:server:syncfriskstart',ped,targetId,targetPed)
        StartProgress(ped,targetId,targetPed,SearchAll,Category)    
    else
        NotifyPlayer('No one nearby!',3000,'error')
    end
end)

RegisterNetEvent('spy-frisk:client:getchecked',function(PlayerWhoWant,Category)
    local foundIllegal = false  
    for _, itemname in pairs(Config.Menu[Category].Items) do
        local hasItem = HasItemsCheck(itemname)
        if hasItem then
            foundIllegal = true  
            break  
        end
    end
    TriggerServerEvent('spy-frisk:server:sendstatus', foundIllegal, PlayerWhoWant,Category,false)
end)

RegisterNetEvent('spy-frisk:client:getcheckedall',function(PlayerWhoWant)
    local foundIllegal = false
    local allitemlist = {} 
    for _, category in ipairs(Config.Menu) do
        for _, item in ipairs(category.Items) do
            allitemlist[#allitemlist + 1] = item
        end
    end
    for _, itemname in pairs(allitemlist) do
        local hasItem = HasItemsCheck(itemname)
        if hasItem then
            foundIllegal = true  
            break  
        end
    end
    TriggerServerEvent('spy-frisk:server:sendstatus', foundIllegal, PlayerWhoWant,Category,true)
end)

RegisterNetEvent('spy-frisk:client:playanim',function(animDict,animName)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 51, 0, false, false, false)
    isInFrisk = true
    while isInFrisk do
        DisableControls()
        Wait(0)
    end
end)


RegisterNetEvent('spy-frisk:client:clearanim',function()
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    isInFrisk = false
end)

RegisterNetEvent('spy-frisk:client:atttrgt',function(FriskPed,TargetPed)
    local coords = GetOffsetFromEntityInWorldCoords(TargetPed, 0.0, -0.5, 0.0)
    SetEntityCoords(FriskPed, coords, true, false, false, false)
    SetEntityHeading(FriskPed,GetEntityHeading(TargetPed))
    AttachEntityToEntity(FriskPed, TargetPed, -1, 0.0, -0.5, 0.0, 0.0, 0.0,0.0, false, false, false, true, 1, true)
end)

----------------DEBUG COMMAND
-- RegisterCommand('spyfrisk',function()
--     TriggerEvent('spy-frisk:client:openMenu')
-- end)


function StartProgress(ped,targetId,targetPed,SearchAll,Category)
    if Config.Dependency.UseProgress == 'ox' then
        if lib.progressBar({
            duration = 9000,
            label = 'Frisking Person',
            useWhileDead = false,
            canCancel = true,
        }) then 
            TriggerServerEvent('spy-frisk:server:syncfriskend',ped,targetId,targetPed)
            TriggerServerEvent('spy-frisk:checkpersoninv',targetId,SearchAll,Category)
           else 
            TriggerServerEvent('spy-frisk:server:syncfriskend',ped,targetId,targetPed)
           end
    else
        Config.UseCore.Functions.Progressbar("frisk_player", "Frisking Person", 9000, false, true, {}, {}, {}, {}, 
        function() -- Done
            TriggerServerEvent('spy-frisk:server:syncfriskend',ped,targetId,targetPed)
            TriggerServerEvent('spy-frisk:checkpersoninv',targetId,SearchAll,Category)
        end, function() -- Cancel
            TriggerServerEvent('spy-frisk:server:syncfriskend',ped,targetId,targetPed)
        end)
    end
end

function DisableControls()
    DisableControlAction(0, 30, true) -- disable left/right
    DisableControlAction(0, 36, true) -- Left CTRL
    DisableControlAction(0, 31, true) -- disable forward/back
    DisableControlAction(0, 36, true) -- INPUT_DUCK
    DisableControlAction(0, 21, true) -- disable sprint
    DisableControlAction(0, 75, true)  -- Disable exit vehicle
    DisableControlAction(27, 75, true) -- Disable exit vehicle 
    DisableControlAction(0, 63, true) -- veh turn left
    DisableControlAction(0, 64, true) -- veh turn right
    DisableControlAction(0, 71, true) -- veh forward
    DisableControlAction(0, 72, true) -- veh backwards
    DisableControlAction(0, 75, true) -- disable exit vehicle
    DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
    DisableControlAction(0, 24, true) -- disable attack
    DisableControlAction(0, 25, true) -- disable aim
    DisableControlAction(1, 37, true) -- disable weapon select
    DisableControlAction(0, 47, true) -- disable weapon
    DisableControlAction(0, 58, true) -- disable weapon
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
end

function NotifyPlayer(msg,time,type)
    if Config.Dependency.UseNotify == 'ox' then
        lib.notify({
            title = '',
            description = msg,
            duration = time,
            type = type
        })        
    else
        Config.UseCore.Functions.Notify(msg,type,time)
    end
end

function HasItemsCheck(itemname)
    if Config.Dependency.UseInventory == 'qb' then
        return Config.UseCore.Functions.HasItem(itemname)
    elseif Config.Dependency.UseInventory == 'ox' then
        local chkItem = exports.ox_inventory:Search('count', itemname)
        if type(chkItem) == 'table' then
            for _, v in pairs(chkItem) do
                if v >= 1 then
                    return true
                end
            end
        else
            return chkItem >= 1
        end
    end
    return false
end
