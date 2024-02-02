--  __ __       __ __   __   
-- (_ |__)\_/  |_ |__)|(_ |_/
-- __)|    |   |  | \ |__)| \
                          
Config = Config or {}

Config.UseCore = exports['qb-core']:GetCoreObject()    -- *[FOR QBCORE USERS ONLY!]

Config.Dependency = {
    UseInventory = 'ox',         -- qb | ox             *[ESX SUPPORT IS THROUGH ox-inv | ox-lib]
    UseProgress = 'ox',          -- qb | ox                     
    UseMenu = 'ox',              -- qb | ox 
    UseNotify = 'ox',            -- qb | ox
}


Config.Menu = {     -- Add as many category as you want.
    [1] = {
        Label = 'Metals',
        Desc = 'check players each and every pocket for metal objects',
        Icon = 'inbox',
        Notify = {
            Success = "Felt something suspicious!",
            Error = "You didn't felt anything!",
        },
        Items = {"metalscrap","iron"},
    },
    [2] = {
        Label = 'Sharp Objects',
        Desc = 'check players each and every pocket for sharp objects',
        Icon = 'utensils',
        Notify = {
            Success = "Felt something suspicious!",
            Error = "You didn't felt anything!",
        },
        Items = {"weapon_knife"},
    },
    [3] = {
        Label = 'Guns & Explosives',
        Desc = 'check players each and every pocket for gun and explosive objects',
        Icon = 'person-rifle',
        Notify = {
            Success = "Felt something suspicious!",
            Error = "You didn't felt anything!",
        },
        Items = {"weapon_pistol"},
    },
}

Config.SearchAll = {        -- Search all the items mentioned in above list at once.
    Enabled = true,
    Label = 'Search All',
    Desc = 'check players each and every pocket for everything.',
    Icon = 'magnifying-glass',
    Notify = {
        Success = "Felt something suspicious! (ALL)",
        Error = "You didn't felt anything! (ALL)",
    },
}

Config.Anim = {
    srcDict = 'custom@police',
    srcAnim = 'police',
    trgtDict = 'missfam5_yoga',
    trgtAnim = 'a2_pose',
}

