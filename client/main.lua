local QBCore = exports['qb-core']:GetCoreObject()
local hunger = 0
local thirst = 0
local stress = 0

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)-- Triggered in qb-core
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)-- Add this event with adding stress elsewhere
    stress = newStress
end)

-- Player Hud
CreateThread(function()
    while true do
        Wait(500)
        if LocalPlayer.state['isLoggedIn'] then
            local show = true
            local player = PlayerPedId()
            local talking = NetworkIsPlayerTalking(PlayerId())
            local health = GetEntityHealth(player)
            
            if LocalPlayer.state['proximity'] ~= nil then
                voice = LocalPlayer.state['proximity'].distance
            end
            SendNUIMessage({
                action = 'hudtick',
                show = show,
                health = health / 100,
                armor = GetPedArmour(player) / 100,
                hunger = hunger / 100,
                thirst = thirst / 100,
                stress = stress / 100,
                voice = voice / 5,
                talking = talking
            })
            DisplayRadar(true)
        else
            SendNUIMessage({
                action = 'hudtick',
                show = false
            })
            DisplayRadar(false)
        end
    end
end)

-- Raise Minimap
CreateThread(function()
    local minimap = RequestScaleformMovie('minimap')
    while not HasScaleformMovieLoaded(minimap) do
        Wait(0)
    end
    
    Wait(0)
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)



-- Stress Gain
CreateThread(function()-- Speeding
    while true do
        if QBCore then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * 2.236936 --mph
                if speed >= Config.MinimumSpeed then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
            end
        end
        Wait(20000)
    end
end)

CreateThread(function()-- Shooting
    while true do
        if QBCore then
            if IsPedShooting(PlayerPedId()) and not IsWhitelistedWeapon() then
                if math.random() < Config.StressChance then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
            end
        end
        Wait(6)
    end
end)

function IsWhitelistedWeapon()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= nil then
        for _, v in pairs(Config.WhitelistedWeapons) do
            if weapon == GetHashKey(v) then
                return true
            end
        end
    end
    return false
end

-- Stress Screen Effects
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local wait = GetEffectInterval(stress)
        if stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 3000, 500)
            
            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                local player = PlayerPedId()
                SetPedToRagdollWithFall(player, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end
            
            Wait(500)
            for i = 1, FallRepeat, 1 do
                Wait(750)
                DoScreenFadeOut(200)
                Wait(1000)
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                SetFlash(0, 0, 200, 750, 200)
            end
        elseif stress >= Config.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 2500, 500)
        end
        Wait(wait)
    end
end)

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(Config.Intensity['shake']) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end
