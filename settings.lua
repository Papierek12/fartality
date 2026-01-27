-- // Settings.lua
-- // 1. INITIALIZE EXUNYS CONFIG (Global table)
getgenv().ExunysDeveloperAimbot = {
    DeveloperSettings = {
        UpdateMode = "RenderStepped", -- Controls script refresh rate #
        TeamCheckOption = "TeamColor", -- Standard method for checking teams #
        RainbowSpeed = 1 -- Only matters if you use Rainbow colors @
    },

    Settings = {
        Enabled = false, -- Master toggle for the script !
        
        TeamCheck = false, -- Set to 'true' if you only want to target enemies @
        AliveCheck = true, -- Prevents locking onto dead bodies/corpses !
        WallCheck = true, -- Prevents aiming at people behind walls (keep true to stay safe) !

        OffsetToMoveDirection = false, -- Turn 'true' for games with bullet travel (Prediction) @
        OffsetIncrement = 15, -- Adjusts how far ahead the prediction aims @

        Sensitivity = 0.1, -- Set above 0 to make aim look "human" and not instant !
        Sensitivity2 = 3.5, -- Only affects LockMode 2 (mouse movement) #

        LockMode = 1, -- 1 = Direct Snap (CFrame); 2 = Smooth Mouse (Safer) !
        LockPart = "Head", -- Can be "Head", "UpperTorso", or "HumanoidRootPart" !

        TriggerKey = Enum.UserInputType.MouseButton2, -- The key you hold to aim !
        Toggle = false -- If true, you tap the key once instead of holding it @
    },

    FOVSettings = {
        Enabled = true, -- The script won't find targets if this is false !
        Visible = true, -- Shows you the circle where the aimbot works !

        Radius = 90, -- The size of your aiming zone on screen !
        NumSides = 60, -- # (Internal value, slider removed)

        Thickness = 1, -- Visual thickness of the circle @
        Transparency = 1, -- Visual see-throughness @
        Filled = false, -- Makes the circle a solid shape @

        RainbowColor = false, -- Rainbow effect @
        RainbowOutlineColor = false, -- Rainbow effect for the outline @
        Color = Color3.fromRGB(255, 255, 255), -- Color of the circle @
        OutlineColor = Color3.fromRGB(0, 0, 0), -- Color of the outline @
        LockedColor = Color3.fromRGB(255, 150, 150) -- Color when you find a target @
    }
}
