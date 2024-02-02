RegisterNetEvent('spy-frisk:checkpersoninv',function(playerId,SearchAll,Category)
    local PlayerWhoWant = source
    if not SearchAll then
        TriggerClientEvent("spy-frisk:client:getchecked",playerId,PlayerWhoWant,Category);
    else
        TriggerClientEvent("spy-frisk:client:getcheckedall",playerId,PlayerWhoWant);
    end
end)

RegisterNetEvent('spy-frisk:server:sendstatus',function(foundIllegal,PlayerWhoWant,Category,srchAll)
    if foundIllegal then
        if srchAll then
            NotifyPlayer(Config.SearchAll.Notify.Success,5000,'success',PlayerWhoWant)
        else
            NotifyPlayer(Config.Menu[Category].Notify.Success,5000,'success',PlayerWhoWant)
        end
    else
        if srchAll then
            NotifyPlayer(Config.SearchAll.Notify.Error,5000,'error',PlayerWhoWant)
        else
            NotifyPlayer(Config.Menu[Category].Notify.Error,5000,'error',PlayerWhoWant)
        end
    end
end)

RegisterNetEvent('spy-frisk:server:syncfriskstart',function(srcPed,targetSrc,targetPed)
    local src = source
    TriggerClientEvent('spy-frisk:client:atttrgt',src,srcPed,targetPed)
    Wait(300)
    TriggerClientEvent('spy-frisk:client:playanim',src,Config.Anim.srcDict,Config.Anim.srcAnim)
    TriggerClientEvent('spy-frisk:client:playanim',targetSrc,Config.Anim.trgtDict,Config.Anim.trgtAnim)
end)

RegisterNetEvent('spy-frisk:server:syncfriskend',function(srcPed,targetSrc,targetPed)
    local src = source
    TriggerClientEvent('spy-frisk:client:clearanim',src)
    TriggerClientEvent('spy-frisk:client:clearanim',targetSrc)
end)


function NotifyPlayer(msg,time,type,src)
    if Config.Dependency.UseNotify == 'ox' then
        TriggerClientEvent('ox_lib:notify', src, { type = type , title = '', description = msg, duration = time })      
    else
        TriggerClientEvent("QBCore:Notify", src, msg, type,time)
    end
end