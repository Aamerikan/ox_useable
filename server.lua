local QBCore = exports['qb-core']:GetCoreObject()

-- Debug function
local function debugPrint(message)
    if CraftingConfig.debug then
        print(message)
    end
end

-- Ensure the config is loaded
if not CraftingConfig then
    print("[ox_useables:server] ERROR: CraftingConfig not loaded.")
else
    debugPrint("[ox_useables:server] CraftingConfig loaded successfully.")
end

-- Register the /test_craft command for testing
debugPrint("[ox_useables:server] Registering server command /test_craft")
RegisterCommand("test_craft", function(source, args)
    if source == 0 then
        print("[ox_useables:server] ERROR: /test_craft must be run by a player.")
        return
    end

    local itemName = args[1]
    if not itemName or not CraftingConfig[itemName] then
        print("[ox_useables:server] ERROR: Invalid item or item not in config.")
        return
    end

    debugPrint("[ox_useables:server] /test_craft called with item: " .. itemName .. " by source: " .. source)
    TriggerEvent("ox_useables:server:craftItem", source, itemName)
end, false)

-- Automatically register usable items from CraftingConfig
for mainItem, _ in pairs(CraftingConfig) do
    QBCore.Functions.CreateUseableItem(mainItem, function(source, item)
        debugPrint("[ox_useables:server] Item used: " .. mainItem .. " by source: " .. source)
        TriggerEvent("ox_useables:server:craftItem", source, mainItem)
    end)
    debugPrint("[ox_useables:server] Registered usable item: " .. mainItem)
end

-- Crafting logic
RegisterNetEvent("ox_useables:server:craftItem", function(source, itemName)
    debugPrint("[ox_useables:server] Source for crafting event: " .. source)

    if not source or source == 0 then
        debugPrint("[ox_useables:server] ERROR: Invalid source passed to the event.")
        return
    end

    local player = QBCore.Functions.GetPlayer(source)
    if not player then
        debugPrint("[ox_useables:server] ERROR: Player not found for source: " .. source)
        return
    end

    local crafting = CraftingConfig[itemName]
    if not crafting then
        debugPrint("[ox_useables:server] ERROR: No crafting recipes found for item: " .. itemName)
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'No recipes found for this item.'})
        return
    end

    for _, recipe in ipairs(crafting.recipes) do
        debugPrint("[ox_useables:server] Checking recipe for item: " .. itemName)
        local hasItems = true

        -- Check if player has the required items
        for _, req in ipairs(recipe.requiredItems) do
            local itemCount = exports.ox_inventory:Search(source, 'count', req.name)
            debugPrint(string.format("[ox_useables:server] Player has %d of item: %s (needed: %d)", itemCount, req.name, req.amount))
            if itemCount < req.amount then
                hasItems = false
                break
            end
        end

        if hasItems then
            debugPrint("[ox_useables:server] Crafting successful for item: " .. itemName)
            -- Remove required items
            for _, req in ipairs(recipe.requiredItems) do
                exports.ox_inventory:RemoveItem(source, req.name, req.amount)
            end

            -- Add result item
            exports.ox_inventory:AddItem(source, recipe.resultItem.name, recipe.resultItem.amount)
            debugPrint("[ox_useables:server] Result item added: " .. recipe.resultItem.name .. " x " .. recipe.resultItem.amount)

            -- Trigger client animation
            TriggerClientEvent("ox_useables:client:playAnimation", source, crafting.animation)
            TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = crafting.successMessage})
            return
        end
    end

    debugPrint("[ox_useables:server] ERROR: Player does not have required items.")
    TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = crafting.errorMessage})
end)
