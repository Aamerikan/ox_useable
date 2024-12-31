
CraftingConfig = {
    debug = true,
    ["grinder"] = {--example item, change this to the item that gets used in the inventory
        recipes = {
            {
                requiredItems = { {name = "runtz_og", amount = 1}, {name = "backwoods_honey", amount = 1} },--recipe 1 
                resultItem = {name = "runtz_og_blunt", amount = 5}
            },
            {
                requiredItems = { {name = "runtz_og", amount = 1}, {name = "banana_backwoods", amount = 1} },--recipe 2, can add as many as you want
                resultItem = {name = "runtz_og_blunt", amount = 5}
            },
        },
        animation = {dict = "mp_arresting", anim = "a_uncuff", duration = 4000},
        successMessage = "Rolled yourself a blunt there!",
        errorMessage = "You might need to learn to roll better."
    },
    ["diamond"] = {--second useable item 
        recipes = {
            {
                requiredItems = { {name = "ammo-9", amount = 1}, {name = "white_runtz_blunt", amount = 1} },
                resultItem = {name = "runtz_og_blunt", amount = 5}
            },
        },
        animation = {dict = "mp_arresting", anim = "a_uncuff", duration = 4000},
        successMessage = "Rolled yourself a blunt there!",
        errorMessage = "You might need to learn to roll better."
    },
}
