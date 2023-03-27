
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;

--- the code shit
getgenv().partlol = "Head"
getgenv().partt = "Head"

local Prey = nil 
local Plr = nil

local Players, Client, Mouse, RS, Camera =
game:GetService("Players"),
game:GetService("Players").LocalPlayer,
game:GetService("Players").LocalPlayer:GetMouse(),
game:GetService("RunService"),
game.Workspace.CurrentCamera

local Circle = Drawing.new("Circle")
Circle.Color = Color3.new(1,1,1)
Circle.Thickness = 1

local UpdateFOV = function ()
if (not Circle) then
    return Circle
end
Circle.Visible = getgenv().ruhh.FOV["Visible"]
Circle.Radius = getgenv().ruhh.FOV["Radius"] * 3
Circle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
return Circle
end

RS.Heartbeat:Connect(UpdateFOV)


ClosestPlrFromMouse = function()
local Target, Closest = nil, 1/0

for _ ,v in pairs(Players:GetPlayers()) do
    if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
        local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
        local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

        if (Circle.Radius > Distance and Distance < Closest and OnScreen) then
            Closest = Distance
            Target = v
        end
    end
end
return Target
end

local WTS = function (Object)
local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local IsOnScreen = function (Object)
local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
return IsOnScreen
end

local FilterObjs = function (Object)
if string.find(Object.Name, "Gun") then
    return
end
if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
    return true
end
end

local GetClosestBodyPart = function (character)
local ClosestDistance = 1/0
local BodyPart = nil
if (character and character:GetChildren()) then
    for _,  x in next, character:GetChildren() do
        if FilterObjs(x) and IsOnScreen(x) then
            local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if (Circle.Radius > Distance and Distance < ClosestDistance) then
                ClosestDistance = Distance
                BodyPart = x
            end
        end
    end
end
return BodyPart
end

local Prey

task.spawn(function ()
while task.wait() do
    if Prey then
        if getgenv().ruhh.Silent.Enabled then
            getgenv().partlol = tostring(GetClosestBodyPart(Prey.Character))
        end
    end
end
end)

local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)

grmt.__index = newcclosure(function(self, v)
if (getgenv().ruhh.Silent.Enabled and Mouse and tostring(v) == "Hit") then

    Prey = ClosestPlrFromMouse()

    if Prey then
        local endpoint = game.Players[tostring(Prey)].Character[getgenv().partlol].CFrame + (
            game.Players[tostring(Prey)].Character[getgenv().partlol].Velocity * getgenv().ruhh.Silent.Prediction
        )
        return (tostring(v) == "Hit" and endpoint)
    end
end
return backupindex(self, v)
end)

local CC = game.Workspace.CurrentCamera
local Mouse = game.Players.LocalPlayer:GetMouse()
local Plr


Mouse.KeyDown:Connect(function(Key)
    local Keybind = getgenv().ruhh.Tracer.Key:lower()
    if (Key == Keybind) then
        if getgenv().ruhh.Tracer.Enabled == true then
            IsTargetting = not IsTargetting
            if IsTargetting then
                Plr = GetClosest()
            else
                if Plr ~= nil then
                    Plr = nil
                end
            end
        end
    end
end)

function GetClosest()
    local closestPlayer
    local shortestDistance = math.huge
    for i, v in pairs(game.Players:GetPlayers()) do
        pcall(function()

            if v ~= game.Players.LocalPlayer and v.Character and
                v.Character:FindFirstChild("Humanoid") then
                local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                local magnitude =
                (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                if (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end)
    end
    return closestPlayer
end

local function IsOnScreen(Object)
    local IsOnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
    return IsOnScreen
end

local function Filter(Object)
    if string.find(Object.Name, "Gun") then
        return
    end
    if Object:IsA("Part") or Object:IsA("MeshPart") then
        return true
    end
end

local function WTSPos(Position)
    local ObjectVector = game.Workspace.CurrentCamera:WorldToScreenPoint(Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local function WTS(Object)
    local ObjectVector = game.Workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

function GetNearestPartToCursorOnCharacter(character)
    local ClosestDistance = math.huge
    local BodyPart = nil

    if (character and character:GetChildren()) then
        for k,  x in next, character:GetChildren() do
            if Filter(x) and IsOnScreen(x) then
                local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
    
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end

    return BodyPart
end

Mouse.KeyDown:Connect(function(Key)
    local Keybind = getgenv().ruhh.Silent.Keybind:lower()
    if (Key == Keybind) then
            if getgenv().ruhh.Silent.Enabled == true then
				getgenv().ruhh.Silent.Enabled = false
                if getgenv().ruhh.Silent.Notifications == true then
                    Notify({
                        Description = "Silentaim Disabled";
                        Title = "ruhh";
                        Duration = 1.5;
                        });
                    
                
            else
				getgenv().ruhh.Silent.Enabled = true
                if getgenv().ruhh.Silent.Notifications == true then
                Notify({
                    Description = "Silentaim Enabled";
                    Title = "ruhh";
                    Duration = 1.5;
                    });
            end
            end
        end
            end
end)


RS.RenderStepped:Connect(function()
    if getgenv().ruhh.Checks.NoGroundShots == true and Prey.Character:FindFirstChild("Humanoid") == Enum.HumanoidStateType.Freefall then
        pcall(function()
            local TargetVelv5 = targ.Character[getgenv().partlol]
            TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 5), TargetVelv5.Velocity.Z)
            TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 5), TargetVelv5.Velocity.Z)
        end)
    end
    
if getgenv().ruhh.Checks.Death == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
			if Plr.Character.Humanoid.health < 2 then
				Plr = nil
				IsTargetting = false
			end
		end
		if getgenv().ruhh.Checks.Death == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
			if Client.Character.Humanoid.health < 2 then
				Plr = nil
				IsTargetting = false
			end
end
        if getgenv().ruhh.Checks.Knocked == true and Prey and Prey.Character then 
            local KOd = Prey.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = Prey.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                Prey = nil
            end
	end
        if getgenv().ruhh.Checks.Knocked == true and Plr and Plr.Character then 
            local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                Plr = nil
                IsTargetting = false
            end
        end
end)


game.RunService.Heartbeat:Connect(function()
        if getgenv().ruhh.Misc.Shake then
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().partt].Position + Plr.Character[getgenv().partt].Velocity * getgenv().ruhh.Tracer.Prediction +
            Vector3.new(
                math.random(-getgenv().ruhh.Misc.ShakeValue, getgenv().ruhh.Misc.ShakeValue),
                math.random(-getgenv().ruhh.Misc.ShakeValue, getgenv().ruhh.Misc.ShakeValue),
                math.random(-getgenv().ruhh.Misc.ShakeValue, getgenv().ruhh.Misc.ShakeValue)
            ) * 0.1)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().ruhh.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        else
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().partt].Position + Plr.Character[getgenv().partt].Velocity * getgenv().ruhh.Tracer.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().ruhh.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
end)

task.spawn(function()
    while task.wait() do
        if getgenv().ruhh.Tracer.Enabled and Plr ~= nil and (Plr.Character) then
            getgenv().partt = tostring(GetNearestPartToCursorOnCharacter(Plr.Character))
        end
    end
end)


local Player = game:GetService("Players").LocalPlayer
            local Mouse = Player:GetMouse()
            local SpeedGlitch = false
            Mouse.KeyDown:Connect(function(Key)
                if getgenv().ruhh.Macro.Enabled == true and Key == getgenv().ruhh.Macro.Keybind then
                    SpeedGlitch = not SpeedGlitch
                    if SpeedGlitch == true then
                        repeat game:GetService("RunService").Heartbeat:wait()
                            keypress(0x49)
                            game:GetService("RunService").Heartbeat:wait()

                            keypress(0x4F)
                            game:GetService("RunService").Heartbeat:wait()

                            keyrelease(0x49)
                            game:GetService("RunService").Heartbeat:wait()

                            keyrelease(0x4F)
                            game:GetService("RunService").Heartbeat:wait()

                        until SpeedGlitch == false
                    end
                end
            end)
            


while getgenv().ruhh.Silent.AutoPrediction == true do
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local pingValue = string.split(ping, " ")[1]
    local pingNumber = tonumber(pingValue)
   
    if pingNumber < 30 then
        ruhh.Silent.Prediction = 0.12588
    elseif pingNumber < 40 then
        ruhh.Silent.Prediction = 0.119
    elseif pingNumber < 50 then
        ruhh.Silent.Prediction = 0.1247
    elseif pingNumber < 60 then
        ruhh.Silent.Prediction = 0.127668
    elseif pingNumber < 70 then
        ruhh.Silent.Prediction = 0.12731
    elseif pingNumber < 80 then
        ruhh.Silent.Prediction = 0.12951
    elseif pingNumber < 90 then
        ruhh.Silent.Prediction = 0.1318
    elseif pingNumber < 100 then
        ruhh.Silent.Prediction = 0.1357
    elseif pingNumber < 110 then
        ruhh.Silent.Prediction = 0.133340
         elseif pingNumber < 120 then
        ruhh.Silent.Prediction = 0.1455
         elseif pingNumber < 130 then
        ruhh.Silent.Prediction = 0.143765
         elseif pingNumber < 140 then
        ruhh.Silent.Prediction = 0.156692
         elseif pingNumber < 150 then
        ruhh.Silent.Prediction = 0.1223333
         elseif pingNumber < 160 then
        ruhh.Silent.Prediction = 0.1521
        elseif pingNumber < 170 then
        ruhh.Silent.Prediction = 0.1626
        elseif pingNumber < 180 then
        ruhh.Silent.Prediction = 0.1923111
        elseif pingNumber < 190 then
        ruhh.Silent.Prediction = 0.19284
        elseif pingNumber < 200 then
        ruhh.Silent.Prediction = 0.166547
        elseif pingNumber < 210 then
        ruhh.Silent.Prediction = 0.16942
        elseif pingNumber < 260 then
        ruhh.Silent.Prediction = 0.1651
        elseif pingNumber < 310 then
        ruhh.Silent.Prediction = 0.16780
	end
 
    wait(0.1)
end
