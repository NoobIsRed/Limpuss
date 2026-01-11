-- =========================
-- SERVICES
-- =========================
local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

repeat task.wait() until char
    and char:FindFirstChild("Humanoid")
    and char:FindFirstChild("HumanoidRootPart")

local humanoid = char.Humanoid
local hrp = char.HumanoidRootPart

-- =========================
-- RAYFIELD LOAD
-- =========================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "M1 Combo Panel",
    LoadingTitle = "Combat UI",
    LoadingSubtitle = "Roland | Sinclair",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("M1", 4483362458)

-- =========================
-- MODULES
-- =========================

local RolandModules = {
    rs.src.Others.Roland["The Black Silence"].Moves.Base.M1.Combos["1"],
    rs.src.Others.Roland["The Black Silence"].Moves.Base.M1.Combos["2"],
    rs.src.Others.Roland["The Black Silence"].Moves.Base.M1.Combos["3"],
}

local SinclairModules = {
    rs.src.Identities.Sinclair["Dawn Office Fixer"].Moves.Xenprima.M1.Combos["1"],
    rs.src.Identities.Sinclair["Dawn Office Fixer"].Moves.Xenprima.M1.Combos["2"],
    rs.src.Identities.Sinclair["Dawn Office Fixer"].Moves.Xenprima.M1.Combos["3"],
}

-- =========================
-- STATE
-- =========================
local RolandOn = false
local SinclairOn = false

-- =========================
-- LOOP
-- =========================
task.spawn(function()
    while true do
        if RolandOn then
            for _, module in ipairs(RolandModules) do
                rs.Net.Character.Combat:FireServer({
                    Module = module,
                    Humanoid = humanoid,
                    Attempt = "M1",
                    HRP = hrp,
                    Char = char,
                })

                rs.Net.Main.EffectCombat:FireServer({
                    Module = module,
                    M1 = true,
                })
            end
        end

        if SinclairOn then
            for _, module in ipairs(SinclairModules) do
                rs.Net.Character.Combat:FireServer({
                    Module = module,
                    Humanoid = humanoid,
                    Attempt = "M1",
                    HRP = hrp,
                    Char = char,
                })

                rs.Net.Main.EffectCombat:FireServer({
                    Module = module,
                    M1 = true,
                })
            end
        end

        task.wait() -- KHÔNG delay đánh, chỉ nhường frame
    end
end)

-- =========================
-- TOGGLES
-- =========================

Tab:CreateToggle({
    Name = "Roland M1 Combo",
    CurrentValue = false,
    Callback = function(v)
        RolandOn = v
    end
})

Tab:CreateToggle({
    Name = "Sinclair M1 Combo",
    CurrentValue = false,
    Callback = function(v)
        SinclairOn = v
    end
})
