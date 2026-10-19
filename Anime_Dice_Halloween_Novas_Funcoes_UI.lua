-- Halloween Route Farm (Delta/mobile)
-- Movement/UI scaffold; game rewards are not verified by this script.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local ROUTE_DATA = game:GetService("HttpService"):JSONDecode([=[
{"route":[{"y":-19.512765884399414,"x":-1953.4112548828125,"z":11339.7216796875},{"y":-19.512678146362305,"x":-1965.38330078125,"z":11338.037109375},{"y":-19.77237892150879,"x":-1989.718017578125,"z":11339.7568359375},{"y":-19.88234519958496,"x":-1993.9849853515625,"z":11346.5771484375},{"y":-18.824424743652344,"x":-1995.146728515625,"z":11360.646484375},{"y":-18.5582332611084,"x":-1995.100341796875,"z":11362.8095703125},{"y":-18.5582332611084,"x":-1995.06689453125,"z":11362.677734375},{"y":-19.867206573486328,"x":-1993.25341796875,"z":11346.7001953125},{"y":-19.773006439208984,"x":-2011.2193603515625,"z":11343.107421875},{"y":-19.772438049316406,"x":-2036.3748779296875,"z":11345.5078125},{"y":-19.772584915161133,"x":-2060.3203125,"z":11352.984375},{"y":-18.581565856933594,"x":-2081.037353515625,"z":11354.7998046875},{"y":-14.579819679260254,"x":-2080.766357421875,"z":11354.2744140625},{"y":-18.558223724365234,"x":-2080.722900390625,"z":11354.3037109375},{"y":-18.558223724365234,"x":-2080.722900390625,"z":11354.3037109375},{"y":-19.879230499267578,"x":-2069.6376953125,"z":11353.146484375},{"y":-19.772714614868164,"x":-2057.04931640625,"z":11351.6220703125},{"y":-19.776880264282227,"x":-2034.763916015625,"z":11340.37109375},{"y":-19.77207374572754,"x":-2011.418212890625,"z":11333.7587890625},{"y":-20.245845794677734,"x":-1991.3646240234375,"z":11317.986328125},{"y":-20.245845794677734,"x":-1969.2486572265625,"z":11304.1005859375},{"y":-20.261594772338867,"x":-1948.72998046875,"z":11290.7333984375},{"y":-19.880428314208984,"x":-1928.2479248046875,"z":11274.5439453125},{"y":-18.581289291381836,"x":-1913.62841796875,"z":11267.4130859375},{"y":-18.581289291381836,"x":-1913.62841796875,"z":11267.4130859375},{"y":-18.581289291381836,"x":-1913.62841796875,"z":11267.4130859375},{"y":-18.58126449584961,"x":-1919.1864013671875,"z":11269.5693359375},{"y":-19.8372802734375,"x":-1932.4527587890625,"z":11278.53515625},{"y":-20.2796630859375,"x":-1929.0931396484375,"z":11304.037109375},{"y":-20.292179107666016,"x":-1912.9444580078125,"z":11323.03515625},{"y":-20.24884605407715,"x":-1890.8360595703125,"z":11334.30859375},{"y":-19.794042587280273,"x":-1872.438720703125,"z":11334.0869140625},{"y":-19.160430908203125,"x":-1873.32177734375,"z":11324.7685546875},{"y":-18.37429428100586,"x":-1873.44677734375,"z":11314.2841796875},{"y":-18.372791290283203,"x":-1873.44677734375,"z":11314.2841796875},{"y":-18.58426856994629,"x":-1873.8997802734375,"z":11318.01953125},{"y":-19.794153213500977,"x":-1874.930419921875,"z":11342.7119140625},{"y":-19.79400062561035,"x":-1870.358154296875,"z":11342.41015625},{"y":-19.7939453125,"x":-1844.7440185546875,"z":11342.142578125},{"y":-19.79330825805664,"x":-1819.245849609375,"z":11342.798828125},{"y":-19.79315757751465,"x":-1808.84912109375,"z":11342.443359375},{"y":-19.793230056762695,"x":-1806.848388671875,"z":11340.173828125},{"y":-18.58176040649414,"x":-1806.712890625,"z":11320.34375},{"y":-18.57841682434082,"x":-1806.7130126953125,"z":11320.3447265625},{"y":-18.578411102294922,"x":-1806.5311279296875,"z":11323.548828125},{"y":-19.793113708496094,"x":-1806.3294677734375,"z":11342.8408203125},{"y":-19.791574478149414,"x":-1801.1080322265625,"z":11342.125},{"y":-19.788619995117188,"x":-1799.943115234375,"z":11346.037109375},{"y":-19.571359634399414,"x":-1799.8944091796875,"z":11358.552734375},{"y":-18.55823516845703,"x":-1799.33935546875,"z":11363.0126953125},{"y":-18.55823516845703,"x":-1799.33935546875,"z":11363.0126953125},{"y":-19.915058135986328,"x":-1799.9473876953125,"z":11351.8701171875},{"y":-19.791067123413086,"x":-1803.9620361328125,"z":11343.009765625},{"y":-19.79357147216797,"x":-1829.385009765625,"z":11341.0927734375},{"y":-19.79378890991211,"x":-1855.27392578125,"z":11340.67578125},{"y":-19.79399871826172,"x":-1872.8895263671875,"z":11340.6328125},{"y":-19.79400062561035,"x":-1873.5008544921875,"z":11341.4169921875},{"y":-18.593151092529297,"x":-1874.6103515625,"z":11363.9091796875},{"y":-18.370502471923828,"x":-1873.8341064453125,"z":11367.1611328125},{"y":-18.586000442504883,"x":-1873.7572021484375,"z":11365.470703125},{"y":-19.794721603393555,"x":-1874.4818115234375,"z":11340.5771484375},{"y":-19.794004440307617,"x":-1875.8497314453125,"z":11338.33203125},{"y":-19.794057846069336,"x":-1900.990234375,"z":11336.548828125},{"y":-19.590316772460938,"x":-1920.5845947265625,"z":11340.087890625},{"y":-19.51272964477539,"x":-1933.9732666015625,"z":11349.7314453125},{"y":-19.512622833251953,"x":-1957.128173828125,"z":11345.7470703125},{"y":-19.77243995666504,"x":-1979.587890625,"z":11335.1796875},{"y":-19.772340774536133,"x":-1988.8095703125,"z":11336.44921875},{"y":-19.867210388183594,"x":-1992.888427734375,"z":11349.0576171875},{"y":-18.56006622314453,"x":-1993.134765625,"z":11362.892578125},{"y":-18.5582332611084,"x":-1993.134765625,"z":11362.892578125},{"y":-19.02605628967285,"x":-1993.198486328125,"z":11356.4951171875},{"y":-19.77242088317871,"x":-1993.388427734375,"z":11339.7490234375},{"y":-19.772382736206055,"x":-2003.6142578125,"z":11340.1171875},{"y":-19.772438049316406,"x":-2028.850341796875,"z":11340.751953125},{"y":-19.77235221862793,"x":-2051.774658203125,"z":11350.916015625},{"y":-19.867477416992188,"x":-2070.649169921875,"z":11350.3193359375},{"y":-18.558307647705078,"x":-2080.71435546875,"z":11352.12890625},{"y":-18.558229446411133,"x":-2080.714599609375,"z":11352.12890625},{"y":-18.558223724365234,"x":-2078.364990234375,"z":11352.54296875},{"y":-19.772485733032227,"x":-2054.513427734375,"z":11355.904296875},{"y":-19.777788162231445,"x":-2045.1439208984375,"z":11349.9365234375},{"y":-19.772380828857422,"x":-2025.0980224609375,"z":11335.7734375},{"y":-19.77203369140625,"x":-2000.274658203125,"z":11337.4375},{"y":-19.77198028564453,"x":-1975.43212890625,"z":11333.0771484375},{"y":-19.51350212097168,"x":-1953.429443359375,"z":11321.8857421875},{"y":-19.83779525756836,"x":-1940.6112060546875,"z":11301.0673828125},{"y":-19.83701515197754,"x":-1936.66845703125,"z":11276.6875},{"y":-19.887374877929688,"x":-1929.779052734375,"z":11269.0029296875},{"y":-18.606557846069336,"x":-1920.49365234375,"z":11269.1640625},{"y":-18.581254959106445,"x":-1919.390380859375,"z":11268.7373046875},{"y":-19.837329864501953,"x":-1938.4844970703125,"z":11276.6943359375},{"y":-19.837305068969727,"x":-1937.12255859375,"z":11286.197265625},{"y":-19.837247848510742,"x":-1936.6654052734375,"z":11311.79296875},{"y":-19.512670516967773,"x":-1935.7799072265625,"z":11329.54296875},{"y":-19.512845993041992,"x":-1921.6993408203125,"z":11339.2490234375},{"y":-19.7939453125,"x":-1900.114501953125,"z":11339.7119140625},{"y":-19.794021606445312,"x":-1877.21435546875,"z":11336.63671875},{"y":-19.877450942993164,"x":-1876.4898681640625,"z":11327.5126953125},{"y":-18.583894729614258,"x":-1873.2969970703125,"z":11314.4365234375},{"y":-18.162004470825195,"x":-1873.558837890625,"z":11313.9501953125},{"y":-18.162004470825195,"x":-1873.5577392578125,"z":11314.1787109375},{"y":-19.829994201660156,"x":-1871.355224609375,"z":11335.1533203125},{"y":-19.794010162353516,"x":-1868.9625244140625,"z":11337.1005859375},{"y":-19.793975830078125,"x":-1843.7421875,"z":11339.2802734375},{"y":-19.79334831237793,"x":-1818.09228515625,"z":11339.2998046875},{"y":-19.793495178222656,"x":-1809.591064453125,"z":11336.681640625},{"y":-19.793743133544922,"x":-1807.2266845703125,"z":11326.01953125},{"y":-18.57841682434082,"x":-1806.6539306640625,"z":11320.451171875},{"y":-18.57841682434082,"x":-1806.6539306640625,"z":11320.451171875},{"y":-19.8309383392334,"x":-1811.0924072265625,"z":11331.154296875},{"y":-19.79344940185547,"x":-1807.8427734375,"z":11339.3203125},{"y":-18.63783836364746,"x":-1802.57421875,"z":11362.1484375},{"y":-18.55878448486328,"x":-1801.3614501953125,"z":11362.501953125},{"y":-18.558229446411133,"x":-1800.706787109375,"z":11362.04296875},{"y":-19.790555953979492,"x":-1801.99462890625,"z":11346.4384765625},{"y":-19.79315185546875,"x":-1817.80224609375,"z":11342.68359375},{"y":-19.793916702270508,"x":-1843.21484375,"z":11342.2744140625},{"y":-19.793916702270508,"x":-1868.037841796875,"z":11341.814453125},{"y":-19.79395294189453,"x":-1872.7127685546875,"z":11351.6015625},{"y":-18.581432342529297,"x":-1871.86962890625,"z":11366.740234375},{"y":-18.581300735473633,"x":-1871.916259765625,"z":11366.0849609375},{"y":-19.795652389526367,"x":-1873.991943359375,"z":11343.7041015625},{"y":-19.79400062561035,"x":-1884.1409912109375,"z":11341.322265625},{"y":-19.793964385986328,"x":-1908.9356689453125,"z":11342.2646484375},{"y":-19.512706756591797,"x":-1930.9080810546875,"z":11344.759765625},{"y":-19.512754440307617,"x":-1938.9967041015625,"z":11349.6982421875},{"y":-19.513322830200195,"x":-1949.6497802734375,"z":11345.72265625},{"y":-19.51268768310547,"x":-1949.6497802734375,"z":11345.72265625},{"y":-19.51268768310547,"x":-1949.6497802734375,"z":11345.72265625}],"doors":[{"y":-18.5582332611084,"x":-1995.100341796875,"z":11362.8095703125},{"y":-18.558223724365234,"x":-2080.722900390625,"z":11354.3037109375},{"y":-18.581289291381836,"x":-1913.62841796875,"z":11267.4130859375},{"y":-18.372791290283203,"x":-1873.44677734375,"z":11314.2841796875},{"y":-18.57841682434082,"x":-1806.7130126953125,"z":11320.3447265625},{"y":-18.55823516845703,"x":-1799.33935546875,"z":11363.0126953125},{"y":-18.370508193969727,"x":-1873.8341064453125,"z":11367.1611328125}]}
]=])

local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local running = false
local doorCount = 0
local visitedDoors = {}
local profileName = "Default"
local speed = 50
local currentIndex = 0
local antiAfkEnabled = false
local antiAfkConnection = nil
local autoRejoinEnabled = false
local rejoinConnection = nil
local page = "Farm"
local configFile = "HalloweenRouteFarm_Config.json"

local function characterParts()
    local char = player.Character or player.CharacterAdded:Wait()
    return char, char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
end

local gui = Instance.new("ScreenGui")
gui.Name = "HalloweenRouteFarm"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(270, 330)
frame.Position = UDim2.new(0, 25, 0.28, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 16, 29)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 30)
title.Position = UDim2.fromOffset(8, 3)
title.BackgroundTransparency = 1
title.Text = "Anime Dice [Halloween 🎃]"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(25, 25)
closeButton.Position = UDim2.new(1, -29, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(190, 55, 65)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 13
closeButton.Parent = frame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)
closeButton.MouseButton1Click:Connect(function() running = false; gui:Destroy() end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.fromOffset(25, 25)
minimizeButton.Position = UDim2.new(1, -57, 0, 4)
minimizeButton.BackgroundColor3 = Color3.fromRGB(111, 55, 173)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1,1,1)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.Parent = frame
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)
local floatingButton = Instance.new("TextButton")
floatingButton.Size = UDim2.fromOffset(110, 34)
floatingButton.Position = UDim2.new(0, 20, 0.7, 0)
floatingButton.BackgroundColor3 = Color3.fromRGB(111, 55, 173)
floatingButton.Text = "ANIME DICE 🎃"
floatingButton.TextColor3 = Color3.new(1,1,1)
floatingButton.Font = Enum.Font.GothamBold
floatingButton.TextSize = 11
floatingButton.Visible = false
floatingButton.Parent = gui
Instance.new("UICorner", floatingButton).CornerRadius = UDim.new(0, 8)
minimizeButton.MouseButton1Click:Connect(function() frame.Visible = false; floatingButton.Visible = true end)
floatingButton.MouseButton1Click:Connect(function() frame.Visible = true; floatingButton.Visible = false end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -16, 0, 30)
tabBar.Position = UDim2.fromOffset(8, 35)
tabBar.BackgroundTransparency = 1
tabBar.Parent = frame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -16, 1, -76)
content.Position = UDim2.fromOffset(8, 70)
content.BackgroundTransparency = 1
content.Parent = frame

local pages = {}
for _, name in ipairs({"Farm", "Utility", "Config"}) do
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = content
    pages[name] = p
end

local function makeButton(parent, text, y, callback, widthScale)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(widthScale or 1, widthScale and -4 or 0, 0, 30)
    b.Position = UDim2.fromOffset(0, y)
    b.BackgroundColor3 = Color3.fromRGB(111, 55, 173)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function makeLabel(parent, text, y, height)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, height or 38)
    label.Position = UDim2.fromOffset(0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = true
    label.Parent = parent
    return label
end

local status = makeLabel(pages.Farm, "Status: parado", 0, 54)
local function updateStatus()
    status.Text = (running and "Status: ON" or "Status: OFF")
        .. "\nPortas: " .. tostring(doorCount) .. "/" .. tostring(#ROUTE_DATA.doors)
end

local function checkNearbyDoors(root)
    for doorIndex, d in ipairs(ROUTE_DATA.doors) do
        if not visitedDoors[doorIndex] then
            local doorPos = Vector3.new(d.x, d.y, d.z)
            if (root.Position - doorPos).Magnitude <= 8 then
                visitedDoors[doorIndex] = true
                doorCount = doorCount + 1
            end
        end
    end
end

local function runRoute()
    if running then return end
    running = true
    currentIndex = 0
    doorCount = 0
    visitedDoors = {}
    updateStatus()
    task.spawn(function()
        local ok, err = pcall(function()
            local char, humanoid, root = characterParts()
            humanoid.WalkSpeed = speed
            while running do
                for i, p in ipairs(ROUTE_DATA.route) do
                    if not running then break end
                    if not char.Parent or not humanoid.Parent or not root.Parent then
                        char, humanoid, root = characterParts()
                        humanoid.WalkSpeed = speed
                    end
                    humanoid.WalkSpeed = speed
                    currentIndex = i
                    local target = Vector3.new(p.x, p.y, p.z)
                    if (root.Position - target).Magnitude >= 4 then
                        local moveFinished = false
                        local conn = humanoid.MoveToFinished:Connect(function()
                            moveFinished = true
                        end)
                        humanoid:MoveTo(target)
                        local started = os.clock()
                        while running and os.clock() - started < 10 do
                            if not root.Parent then break end
                            checkNearbyDoors(root)
                            if (root.Position - target).Magnitude < 4 or moveFinished then break end
                            task.wait(0.1)
                        end
                        conn:Disconnect()
                    end
                    if root.Parent then checkNearbyDoors(root) end
                    updateStatus()
                    task.wait(0.1)
                end
                if running then
                    currentIndex = 0
                    doorCount = 0
                    visitedDoors = {}
                    updateStatus()
                    task.wait(0.25)
                end
            end
            updateStatus()
        end)
        if not ok then
            running = false
            status.Text = "Erro no farm:\n" .. tostring(err):sub(1, 120)
        end
    end)
end

-- Novos controles da aba Farm (interface).
local movementMode = "MoveTo"
local autoFarmEnabled = false

local modeLabel = makeLabel(pages.Farm, "Modo de movimento: MoveTo", 58, 28)
local teleportModeButton = makeButton(pages.Farm, "⚡ Teleporte", 88, function()
    movementMode = "Teleporte"
    modeLabel.Text = "Modo de movimento: " .. movementMode
    status.Text = "Modo selecionado: Teleporte\nAutomação não conectada"
end, 0.5)
local moveToModeButton = makeButton(pages.Farm, "🏃 MoveTo", 88, function()
    movementMode = "MoveTo"
    modeLabel.Text = "Modo de movimento: " .. movementMode
    status.Text = "Modo selecionado: MoveTo\nAutomação não conectada"
end, 0.5)
moveToModeButton.Position = UDim2.new(0.5, 2, 0, 88)

local autoFarmButton
local function setAutoFarm(enabled)
    autoFarmEnabled = enabled
    autoFarmButton.Text = autoFarmEnabled and "✅ Auto Farm: Ligado" or "❌ Auto Farm: Desligado"
    status.Text = autoFarmEnabled
        and ("Auto Farm: Ligado\nModo: " .. movementMode .. " (interface apenas)")
        or "Auto Farm: Desligado"
end

autoFarmButton = makeButton(pages.Farm, "❌ Auto Farm: Desligado", 126, function()
    setAutoFarm(not autoFarmEnabled)
end)
makeLabel(pages.Farm, "Controles visuais adicionados. A movimentação automática não está conectada nesta versão.", 164, 48)

local antiAfkButton
local function setAntiAfk(enabled)
    antiAfkEnabled = enabled
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    if enabled then
        local ok = pcall(function()
            local vu = game:GetService("VirtualUser")
            antiAfkConnection = player.Idled:Connect(function()
                if antiAfkEnabled then
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end
            end)
        end)
        if not ok or not antiAfkConnection then
            antiAfkEnabled = false
        end
    end
    if antiAfkButton then
        antiAfkButton.Text = antiAfkEnabled and "Anti-AFK: ON" or "Anti-AFK: OFF"
    end
end

antiAfkButton = makeButton(pages.Utility, "Anti-AFK: OFF", 0, function()
    setAntiAfk(not antiAfkEnabled)
end)
local rejoinButton
local function setAutoRejoin(enabled)
    autoRejoinEnabled = enabled
    if rejoinConnection then
        rejoinConnection:Disconnect()
        rejoinConnection = nil
    end
    if enabled then
        rejoinConnection = TeleportService.TeleportInitFailed:Connect(function(plr, result, message)
            if plr == player and autoRejoinEnabled then
                task.wait(3)
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, player)
                end)
            end
        end)
    end
    if rejoinButton then
        rejoinButton.Text = autoRejoinEnabled and "Auto-Rejoin: ON" or "Auto-Rejoin: OFF"
    end
end

rejoinButton = makeButton(pages.Utility, "Auto-Rejoin: OFF", 38, function()
    setAutoRejoin(not autoRejoinEnabled)
end)
makeLabel(pages.Utility, "Auto-Rejoin tenta novamente se uma inicialização de teleporte falhar. Não consegue recuperar toda desconexão.", 78, 62)
makeButton(pages.Utility, "Fechar interface", 150, function()
    running = false
    setAntiAfk(false)
    setAutoRejoin(false)
    gui:Destroy()
end)

local profileLabel = makeLabel(pages.Config, "Perfil: Default", 0, 26)
local speedLabel = makeLabel(pages.Config, "Velocidade de caminhada: 50", 32, 26)
local function saveConfig()
    local data = {
        profileName = profileName,
        speed = speed,
        antiAfkEnabled = antiAfkEnabled,
        autoRejoinEnabled = autoRejoinEnabled
    }
    local ok, err = pcall(function()
        assert(type(writefile) == "function", "writefile indisponível neste executor")
        writefile(configFile, HttpService:JSONEncode(data))
    end)
    status.Text = ok and ("Configuração salva em " .. configFile) or ("Falha ao salvar: " .. tostring(err):sub(1, 90))
end

local function loadConfig(silent)
    -- Autoload robusto: valida suporte do executor, existência e formato do JSON.
    local ok, dataOrErr = pcall(function()
        assert(type(readfile) == "function", "este executor não oferece readfile")
        if type(isfile) == "function" and not isfile(configFile) then
            return nil -- Primeira execução: ainda não existe configuração salva.
        end
        local raw = readfile(configFile)
        assert(type(raw) == "string" and #raw > 0, "arquivo de configuração vazio")
        local decoded = HttpService:JSONDecode(raw)
        assert(type(decoded) == "table", "formato de configuração inválido")
        return decoded
    end)

    if not ok then
        if not silent then
            status.Text = "Falha ao carregar: " .. tostring(dataOrErr):sub(1, 100)
        end
        return false
    end

    local data = dataOrErr
    if data == nil then
        if not silent then status.Text = "Nenhuma configuração salva ainda" end
        return false
    end

    if type(data.speed) == "number" then speed = math.clamp(data.speed, 8, 200) end
    if type(data.profileName) == "string" then profileName = data.profileName:sub(1, 30) end
    setAntiAfk(data.antiAfkEnabled == true)
    setAutoRejoin(data.autoRejoinEnabled == true)
    profileLabel.Text = "Perfil: " .. profileName
    speedLabel.Text = "Velocidade de caminhada: " .. tostring(speed)
    pcall(function()
        local _, humanoid = characterParts()
        humanoid.WalkSpeed = speed
    end)
    if not silent then status.Text = "Configuração carregada" end
    return true
end

makeButton(pages.Config, "Salvar configuração", 66, saveConfig)
makeButton(pages.Config, "Carregar configuração", 104, loadConfig)
makeButton(pages.Config, "Velocidade -", 142, function()
    speed = math.max(8, speed - 10)
    speedLabel.Text = "Velocidade de caminhada: " .. tostring(speed)
end, 0.5)
local speedPlus = makeButton(pages.Config, "Velocidade +", 142, function()
    speed = math.min(200, speed + 10)
    speedLabel.Text = "Velocidade de caminhada: " .. tostring(speed)
end, 0.5)
speedPlus.Position = UDim2.new(0.5, 2, 0, 142)
makeLabel(pages.Config, "Salvar/carregar depende de writefile/readfile no executor. A velocidade é aplicada durante a rota; o limite alto pode ser reduzido pelo próprio jogo.", 182, 58)

local function showPage(name)
    page = name
    for pageName, p in pairs(pages) do p.Visible = pageName == name end
    for _, child in ipairs(tabBar:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = child.Name == name and Color3.fromRGB(100, 115, 170) or Color3.fromRGB(55, 58, 72)
        end
    end
end

for index, name in ipairs({"Farm", "Utility", "Config"}) do
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1/3, -4, 1, 0)
    b.Position = UDim2.new((index - 1)/3, (index - 1) * 2, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(55, 58, 72)
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 11
    b.Parent = tabBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

-- Arrastar a interface com toque ou mouse.
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

showPage("Farm")
task.defer(function()
    -- Aguarda a interface terminar de montar antes de aplicar a configuração.
    loadConfig(true)
end) -- Autoload: restaura as configurações salvas ao iniciar
updateStatus()
