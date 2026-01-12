local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- =====================================================
-- CHARACTER BIND (ANTI RESPAWN BUG)
-- =====================================================
local char, hrp, humanoid

local function bindCharacter(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    humanoid = c:FindFirstChildOfClass("Humanoid")
end

if lp.Character then
    bindCharacter(lp.Character)
end

lp.CharacterAdded:Connect(bindCharacter)

-- =====================================================
-- RAYFIELD UI
-- =====================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Combat Controller (NO FELL)",
    LoadingTitle = "Separated System",
    LoadingSubtitle = "Roland | Sinclair",
    ConfigurationSaving = { Enabled = false }
})

local TabCombat = Window:CreateTab("Combat", 4483362458)
local TabClean  = Window:CreateTab("Cleaner", 4483362458)

-- =====================================================
-- MODULES
-- =====================================================
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

-- =====================================================
-- STATE
-- =====================================================
local RolandOn   = false
local SinclairOn = false

local DeleteDMG    = false
local DeleteEffect = false

local LockFOV  = false
local FOVValue = 70

-- =====================================================
-- ROLAND LOOP
-- =====================================================
task.spawn(function()
    while task.wait() do
        if not RolandOn or not char then continue end
        for _, module in ipairs(RolandModules) do
            if not RolandOn then break end
            rs.Net.Character.Combat:FireServer({
                Attempt = "M1",
                Module = module,
                HRP = hrp,
                Char = char,
                Humanoid = humanoid
            })
            rs.Net.Main.EffectCombat:FireServer({
                Module = module,
                M1 = true,
            })
        end
    end
end)

-- =====================================================
-- SINCLAIR LOOP
-- =====================================================
task.spawn(function()
    while task.wait() do
        if not SinclairOn or not char then continue end
        for _, module in ipairs(SinclairModules) do
            if not SinclairOn then break end
            rs.Net.Character.Combat:FireServer({
                Attempt = "M1",
                Module = module,
                HRP = hrp,
                Char = char,
                Humanoid = humanoid
            })
            rs.Net.Main.EffectCombat:FireServer({
                Module = module,
                M1 = true,
            })
        end
    end
end)

-- =====================================================
-- LOCK FOV
-- =====================================================
task.spawn(function()
    while task.wait() do
        if LockFOV and cam then
            cam.FieldOfView = FOVValue
        end
    end
end)

-- =====================================================
-- CLEANER SYSTEM
-- =====================================================
local function isDamageText(txt)
    return tonumber(txt:match("%d+")) ~= nil
end

local function handleObj(obj)
    if DeleteDMG then
        if obj:IsA("TextLabel") and isDamageText(obj.Text) then
            obj:Destroy()
            return
        end
        if obj:IsA("BillboardGui") then
            for _, v in ipairs(obj:GetDescendants()) do
                if v:IsA("TextLabel") and isDamageText(v.Text) then
                    obj:Destroy()
                    return
                end
            end
        end
    end

    if DeleteEffect then
        if obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam")
        or obj:IsA("Explosion")
        or obj:IsA("Smoke")
        or obj:IsA("Fire") then
            obj:Destroy()
        end
    end
end

local function hook(root)
    for _, v in ipairs(root:GetDescendants()) do
        handleObj(v)
    end
    root.DescendantAdded:Connect(handleObj)
end

hook(workspace)

for _, p in ipairs(Players:GetPlayers()) do
    if p.Character then hook(p.Character) end
    if p:FindFirstChild("PlayerGui") then hook(p.PlayerGui) end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(hook)
end)

-- =====================================================
-- UI TOGGLES (FIXED)
-- =====================================================
TabCombat:CreateToggle({
    Name = "Roland M1",
    CurrentValue = false,
    Callback = function(v)
        RolandOn = v
    end
})

TabCombat:CreateToggle({
    Name = "Sinclair M1",
    CurrentValue = false,
    Callback = function(v)
        SinclairOn = v
    end
})

TabCombat:CreateToggle({
    Name = "Lock FOV (70)",
    CurrentValue = false,
    Callback = function(v)
        LockFOV = v
    end
})

TabClean:CreateToggle({
    Name = "Delete Damage Numbers",
    CurrentValue = false,
    Callback = function(v)
        DeleteDMG = v
    end
})

TabClean:CreateToggle({
    Name = "Delete Effects",
    CurrentValue = false,
    Callback = function(v)
        DeleteEffect = v
    end
})
