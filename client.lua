-- Debug: Register the animation command
--print("[ox_useables:client] Registering client command /test_anim")
--RegisterCommand("test_anim", function()
  --  print("[ox_useables:client] /test_anim called. Triggering animation.")
  --  TriggerEvent("ox_useables:client:playAnimation", {dict = "mp_arresting", anim = "a_uncuff", duration = 4000})
--end, false)

-- Handle animations
RegisterNetEvent("ox_useables:client:playAnimation", function(animation)
    print(string.format("[ox_useables:client] Playing animation: Dict = %s, Anim = %s, Duration = %d",
        animation.dict, animation.anim, animation.duration))

    local playerPed = PlayerPedId()

    -- Validate animation data
    if not animation.dict or not animation.anim or not animation.duration then
        print("[ox_useables:client] ERROR: Invalid animation data.")
        return
    end

    -- Load and play animation
    RequestAnimDict(animation.dict)
    while not HasAnimDictLoaded(animation.dict) do
        Wait(10)
    end
    TaskPlayAnim(playerPed, animation.dict, animation.anim, 8.0, -8.0, animation.duration / 1000, 49, 0, false, false, false)

    -- Wait for animation to complete
    Wait(animation.duration)
    ClearPedTasks(playerPed)
    print("[ox_useables:client] Animation completed.")
end)
