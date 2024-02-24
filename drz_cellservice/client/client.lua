local function createMenu(locationID)
    local options = {}
    local location = DRZ.Location[locationID]

    if location and location.menu then
        for _, menuItem in ipairs(location.menu) do
            table.insert(options, {
                title = menuItem.label,
                icon = menuItem.icon,
                onSelect = function()
                    if menuItem.value == "hunger" or "thirst" then
                        TriggerEvent("drz_cellservice:kontrolaHunger", menuItem.value)
                    elseif menuItem.value == "dispatch" then
                        TriggerEvent("drz_cellservice:kontrolaHunger", menuItem.value)
                    end
                end,
            })
        end

        lib.registerContext({
            id = 'menu_cpz',
            icon = 'signal-bars-good',
            title = "Cell Service",
            options = options,
        })

        lib.showContext('menu_cpz')
    end
end

RegisterNetEvent("drz_cellservice:kontrolaHunger")
AddEventHandler("drz_cellservice:kontrolaHunger", function(hodnota)
    TriggerEvent('esx_status:getStatus', hodnota, function(status)
        if status.val < DRZ.MinimumAmountCheck then
            TriggerServerEvent("drz_cellservice:pridani", hodnota)
            if hodnota == "hunger" then
                exports['okokNotify']:Alert("Notification", "You got some food", 3000, 'info')
            elseif hodnota == "thirst" then
                exports['okokNotify']:Alert("Notification", "You got some drink", 3000, 'info')
            end
        else
            exports['okokNotify']:Alert("Notification", "You are not entitled to refreshments yet", 3000, 'info')
        end
    end)
    if hodnota == "dispatch" then
        exports['okokNotify']:Alert("Notification", "The police were called", 3000, 'info')
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police', 'sheriff'}, 
            coords = data.coords,
            title = 'Assistance in cell',
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Assistance Needed',
                time = 5,
                radius = 0,
            }
        })
    end
end)

for ID, locationData in pairs(DRZ.Location) do
    local LD = locationData
    RequestModel(LD.model)

    while not HasModelLoaded(LD.model) do
        Wait(500)
    end

    npc = CreatePed(4, LD.model, LD.coords.x, LD.coords.y, LD.coords.z - 1, LD.coords.w, false, false)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetPedDiesWhenInjured(npc, false)
    SetPedCanPlayAmbientAnims(npc, true)
    SetPedCanRagdollFromPlayerImpact(npc, false)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    TaskStartScenarioInPlace(npc, LD.scenario, -1, true)
    

    exports.ox_target:addBoxZone({
        coords = DRZ.Location[ID].coords,
        size = vec3(0.85, 0.6, 1.8),
        rotation = DRZ.Location[ID].coords.w,
        debug = false,
        options = {
            {
                name = 'target_menu_cpz',
                onSelect = function ()
                    createMenu(ID)
                end,
                icon = 'fa-solid fa-home',
                label = 'Open the menu',
            },
        }
    })
end


