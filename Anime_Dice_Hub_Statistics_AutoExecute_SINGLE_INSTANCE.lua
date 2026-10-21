-- Halloween Route Farm (Delta/mobile)
-- Movement/UI scaffold; game rewards are not verified by this script.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local shutdownHub
local hubClosed = false

-- Localiza o ambiente compartilhado do executor para que uma nova execução
-- consiga pedir à instância anterior que desligue suas rotinas antes de substituí-la.
local function getSharedExecutorEnv()
    local ok, env = pcall(function()
        if type(getgenv) == "function" then return getgenv() end
        return shared
    end)
    if ok and type(env) == "table" then return env end
    return nil
end

local sharedExecutorEnv = getSharedExecutorEnv()
local function existingHalloweenHub()
    local coreGui = game:GetService("CoreGui")
    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    local existing = coreGui:FindFirstChild("HalloweenRouteFarm")
    if not existing and playerGui then
        existing = playerGui:FindFirstChild("HalloweenRouteFarm")
    end
    return existing
end

-- Se já existe uma cópia, tenta desligá-la de verdade. Se a cópia antiga não
-- registrou um desligamento compartilhado, ao menos remove a interface antiga.
if sharedExecutorEnv and type(sharedExecutorEnv.__HalloweenHubShutdown) == "function" then
    pcall(sharedExecutorEnv.__HalloweenHubShutdown)
end
local staleGui = existingHalloweenHub()
if staleGui then
    pcall(function() staleGui:Destroy() end)
end

-- Limpa a trava de encerramento somente quando uma nova execução manual/inicialização real começa.
pcall(function()
    if type(readfile) == "function" and type(delfile) == "function" then
        readfile("HalloweenHubClosed.flag")
        delfile("HalloweenHubClosed.flag")
    end
end)

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
local movementMode = nil
local farmButton = nil
local teleportModeButton = nil
local moveToModeButton = nil
local antiAfkEnabled = false
local antiAfkConnection = nil
local autoRejoinEnabled = false
local autoLoadEnabled = true
local autoLoadButton = nil
local autoExecuteAfterTeleportEnabled = false
local autoExecuteButton = nil
local autoExecuteSettingFile = "HalloweenAutoExecute.json"
local queueScriptAfterTeleport
local rejoinConnection = nil
local page = "Farm"
local scriptStartedAt = os.clock()
local farmStartedAt = nil
local totalFarmSeconds = 0
local initialCandy = nil
local initialPumpkin = nil
local latestRareItem = "Nenhum"
local collectedItems = {}
local visitedDoorNames = {}
local updateStatistics
local statsCandyLabel, statsPumpkinLabel, statsDoorsLabel, statsFarmTimeLabel, statsRateLabel, statsRareLabel, statsItemsLabel, statsDoorsListLabel
-- Armazenamento exclusivo das configurações do evento de Halloween.
local halloweenConfigPrefix = "HalloweenEventConfig_"
local halloweenAutoloadFile = "HalloweenEventAutoload.json"
local selectedHalloweenConfig = "Default"
local halloweenAutoloadEnabled = false

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
frame.Size = UDim2.fromOffset(270, 365)
frame.Position = UDim2.new(0, 25, 0.28, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 16, 29)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)

-- Decorative Halloween backdrop: kept behind the existing controls.
local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(154, 77, 255)
outline.Thickness = 1.5
outline.Transparency = 0.12
outline.Parent = frame

local decorLayer = Instance.new("Frame")
decorLayer.Name = "HalloweenDecor"
decorLayer.Size = UDim2.fromScale(1, 1)
decorLayer.BackgroundTransparency = 1
decorLayer.ClipsDescendants = true
decorLayer.ZIndex = 0
decorLayer.Parent = frame

local decor = {
    {text = "👻", x = 8, y = 42, size = 25, color = Color3.fromRGB(211, 190, 255)},
    {text = "🦇", x = 216, y = 40, size = 23, color = Color3.fromRGB(181, 117, 255)},
    {text = "🎃", x = 8, y = 320, size = 25, color = Color3.fromRGB(255, 151, 48)},
    {text = "🕸", x = 224, y = 315, size = 27, color = Color3.fromRGB(190, 143, 255)},
    {text = "✦", x = 238, y = 88, size = 17, color = Color3.fromRGB(255, 151, 48)},
    {text = "·  ✧  ·", x = 80, y = 335, size = 17, color = Color3.fromRGB(161, 104, 255)},
}
for _, d in ipairs(decor) do
    local label = Instance.new("TextLabel")
    label.Name = "HalloweenDecoration"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromOffset(38, 30)
    label.Position = UDim2.fromOffset(d.x, d.y)
    label.Text = d.text
    label.TextColor3 = d.color
    label.TextTransparency = 0.18
    label.TextSize = d.size
    label.Font = Enum.Font.GothamBold
    label.ZIndex = 0
    label.Parent = decorLayer
end

local topGlow = Instance.new("Frame")
topGlow.Name = "OrangeAccent"
topGlow.BorderSizePixel = 0
topGlow.BackgroundColor3 = Color3.fromRGB(255, 132, 38)
topGlow.BackgroundTransparency = 0.1
topGlow.Size = UDim2.new(1, 0, 0, 3)
topGlow.Position = UDim2.new(0, 0, 0, 0)
topGlow.ZIndex = 2
topGlow.Parent = frame
Instance.new("UICorner", topGlow).CornerRadius = UDim.new(0, 9)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -42, 0, 30)
title.Position = UDim2.fromOffset(8, 3)
title.BackgroundTransparency = 1
title.Text = "Anime Dice [Halloween 🎃]"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

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

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseHubButton"
closeButton.Size = UDim2.fromOffset(25, 25)
closeButton.Position = UDim2.new(1, -29, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(190, 55, 65)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 13
closeButton.Parent = frame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

local confirmClose = Instance.new("Frame")
confirmClose.Name = "ConfirmCloseDialog"
confirmClose.Size = UDim2.fromOffset(220, 112)
confirmClose.Position = UDim2.new(0.5, -110, 0.5, -56)
confirmClose.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
confirmClose.BorderSizePixel = 0
confirmClose.Visible = false
confirmClose.ZIndex = 20
confirmClose.Parent = frame
Instance.new("UICorner", confirmClose).CornerRadius = UDim.new(0, 8)
local confirmStroke = Instance.new("UIStroke")
confirmStroke.Color = Color3.fromRGB(255, 132, 38)
confirmStroke.Thickness = 1.5
confirmStroke.Parent = confirmClose

local confirmText = Instance.new("TextLabel")
confirmText.Size = UDim2.new(1, -16, 0, 52)
confirmText.Position = UDim2.fromOffset(8, 5)
confirmText.BackgroundTransparency = 1
confirmText.Text = "Quer encerrar o script?\nO Auto Farm e as funções serão desligados."
confirmText.TextColor3 = Color3.new(1, 1, 1)
confirmText.TextWrapped = true
confirmText.Font = Enum.Font.GothamSemibold
confirmText.TextSize = 11
confirmText.ZIndex = 21
confirmText.Parent = confirmClose

local confirmYes = Instance.new("TextButton")
confirmYes.Size = UDim2.new(0.5, -12, 0, 30)
confirmYes.Position = UDim2.new(0, 8, 1, -38)
confirmYes.BackgroundColor3 = Color3.fromRGB(190, 55, 65)
confirmYes.Text = "Sim"
confirmYes.TextColor3 = Color3.new(1, 1, 1)
confirmYes.Font = Enum.Font.GothamBold
confirmYes.TextSize = 12
confirmYes.ZIndex = 21
confirmYes.Parent = confirmClose
Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0, 6)

local confirmNo = Instance.new("TextButton")
confirmNo.Size = UDim2.new(0.5, -12, 0, 30)
confirmNo.Position = UDim2.new(0.5, 4, 1, -38)
confirmNo.BackgroundColor3 = Color3.fromRGB(80, 125, 90)
confirmNo.Text = "Não"
confirmNo.TextColor3 = Color3.new(1, 1, 1)
confirmNo.Font = Enum.Font.GothamBold
confirmNo.TextSize = 12
confirmNo.ZIndex = 21
confirmNo.Parent = confirmClose
Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0, 6)

closeButton.MouseButton1Click:Connect(function()
    if not hubClosed then confirmClose.Visible = true end
end)
confirmNo.MouseButton1Click:Connect(function()
    confirmClose.Visible = false
end)
confirmYes.MouseButton1Click:Connect(function()
    confirmClose.Visible = false
    if shutdownHub then shutdownHub() end
end)

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
for _, name in ipairs({"Farm", "Utility", "Config", "Tempo", "Statistics"}) do
    -- Cada aba funciona como uma página rolável, compatível com toque no celular.
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.Visible = false
    p.Active = true
    p.ScrollingDirection = Enum.ScrollingDirection.Y
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(145, 100, 205)
    p.CanvasSize = UDim2.new(0, 0, 0, 700)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
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

local status = makeLabel(pages.Farm, "Status: Off\nModo: nenhum modo selecionado", 0, 64)
local candyLabel = makeLabel(pages.Farm, "Candy: carregando...", 150, 24)
local pumpkinLabel = makeLabel(pages.Farm, "Pumpkin: carregando...", 176, 24)

local function findCurrencyValue(currencyName)
    local containers = {player:FindFirstChild("leaderstats"), player}
    for _, container in ipairs(containers) do
        if container then
            local found = container:FindFirstChild(currencyName, true)
            if found and (found:IsA("IntValue") or found:IsA("NumberValue") or found:IsA("StringValue")) then
                return found
            end
        end
    end
    return nil
end

local function updateCurrencies()
    local candy = findCurrencyValue("Candy") or findCurrencyValue("Candies")
    local pumpkin = findCurrencyValue("Pumpkin") or findCurrencyValue("Pumpkins")
    candyLabel.Text = "Candy: " .. (candy and tostring(candy.Value) or "não encontrado")
    pumpkinLabel.Text = "Pumpkin: " .. (pumpkin and tostring(pumpkin.Value) or "não encontrado")
    if candy and tonumber(candy.Value) then
        initialCandy = initialCandy or tonumber(candy.Value)
    end
    if pumpkin and tonumber(pumpkin.Value) then
        initialPumpkin = initialPumpkin or tonumber(pumpkin.Value)
    end
    if statsCandyLabel then
        statsCandyLabel.Text = "Candy coletados: " .. tostring(math.max(0, (tonumber(candy and candy.Value) or 0) - (initialCandy or tonumber(candy and candy.Value) or 0)))
        statsPumpkinLabel.Text = "Pumpkins coletadas: " .. tostring(math.max(0, (tonumber(pumpkin and pumpkin.Value) or 0) - (initialPumpkin or tonumber(pumpkin and pumpkin.Value) or 0)))
    end
end

local function updateStatus()
    status.Text = (running and "Status: On" or "Status: Off")
        .. "\nModo: " .. (movementMode or "nenhum modo selecionado")
        .. "\nPortas: " .. tostring(doorCount) .. "/" .. tostring(#ROUTE_DATA.doors)
    updateCurrencies()
end

local function checkNearbyDoors(root)
    for doorIndex, d in ipairs(ROUTE_DATA.doors) do
        if not visitedDoors[doorIndex] then
            local doorPos = Vector3.new(d.x, d.y, d.z)
            if (root.Position - doorPos).Magnitude <= 8 then
                visitedDoors[doorIndex] = true
                doorCount = doorCount + 1
                table.insert(visitedDoorNames, "Porta " .. tostring(doorIndex))
                if #visitedDoorNames > 20 then table.remove(visitedDoorNames, 1) end
                updateStatistics()
            end
        end
    end
end

local TELEPORT_POINTS = {
    Vector3.new(-2080.54, -18.56, 11352.16),
    Vector3.new(-1925.69, -20.12, 11271.36),
    Vector3.new(-1873.18, -18.41, 11314.41),
    Vector3.new(-1806.62, -18.59, 11320.29),
    Vector3.new(-1802.58, -18.56, 11361.79),
    Vector3.new(-1871.87, -18.58, 11366.80),
    Vector3.new(-1994.86, -18.56, 11358.77),
}

local function updateFarmButton()
    if farmButton then
        farmButton.Text = running and "❌ Desligar Auto Farm" or "✅ Ligar Auto Farm"
        farmButton.BackgroundColor3 = running and Color3.fromRGB(190, 65, 70) or Color3.fromRGB(70, 145, 90)
    end
end

local function setMovementMode(mode)
    movementMode = mode
    if teleportModeButton then
        teleportModeButton.BackgroundColor3 = mode == "Teleporte" and Color3.fromRGB(255, 132, 38) or Color3.fromRGB(111, 55, 173)
    end
    if moveToModeButton then
        moveToModeButton.BackgroundColor3 = mode == "MoveTo" and Color3.fromRGB(255, 132, 38) or Color3.fromRGB(111, 55, 173)
    end
    updateStatus()
end

local function stopFarm()
    if running and farmStartedAt then
        totalFarmSeconds += os.clock() - farmStartedAt
        farmStartedAt = nil
    end
    running = false
    updateStatistics()
    pcall(function()
        local _, humanoid, root = characterParts()
        humanoid:MoveTo(root.Position)
    end)
    updateFarmButton()
    updateStatus()
end

local function runRoute()
    if not movementMode then
        status.Text = "Status: Off\nModo: nenhum modo selecionado\nEscolha Teleporte ou MoveTo primeiro."
        return
    end
    if running then
        stopFarm()
        return
    end
    running = true
    currentIndex = 0
    doorCount = 0
    visitedDoors = {}
    updateFarmButton()
    updateStatus()
    task.spawn(function()
        local ok, err = pcall(function()
            local char, humanoid, root = characterParts()
            humanoid.WalkSpeed = speed
            while running do
                if movementMode == "Teleporte" then
                    for i, target in ipairs(TELEPORT_POINTS) do
                        if not running then break end
                        if not char.Parent or not humanoid.Parent or not root.Parent then
                            char, humanoid, root = characterParts()
                        end
                        currentIndex = i
                        root.CFrame = CFrame.new(target)
                        checkNearbyDoors(root)
                        updateStatus()
                        task.wait(0.35)
                    end
                else
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
                            while running and movementMode == "MoveTo" and os.clock() - started < 10 do
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
            updateFarmButton()
            status.Text = "Erro no farm:\n" .. tostring(err):sub(1, 120)
        end
    end)
end

teleportModeButton = makeButton(pages.Farm, "Teleporte", 72, function()
    setMovementMode("Teleporte")
end, 0.5)
moveToModeButton = makeButton(pages.Farm, "MoveTo", 72, function()
    setMovementMode("MoveTo")
end, 0.5)
moveToModeButton.Position = UDim2.new(0.5, 2, 0, 72)
farmButton = makeButton(pages.Farm, "Ligar / Desligar Auto Farm", 108, runRoute)

-- Texto explicativo removido conforme solicitado.

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
                queueScriptAfterTeleport()
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
local playersInServerLabel = makeLabel(pages.Utility, "Players in server: " .. tostring(#Players:GetPlayers()) .. "/9", 76, 30)
task.spawn(function()
    while gui.Parent do
        if playersInServerLabel then playersInServerLabel.Text = "Players in server: " .. tostring(#Players:GetPlayers()) .. "/9" end
        task.wait(2)
    end
end)
-- Texto explicativo removido conforme solicitado.
autoLoadButton = makeButton(pages.Utility, "Auto Load: ON", 112, function()
    autoLoadEnabled = not autoLoadEnabled
    autoLoadButton.Text = autoLoadEnabled and "Auto Load: ON" or "Auto Load: OFF"
end)

-- Enfileira no máximo uma execução por sessão; a trava no início também evita UI duplicada.
local teleportScriptQueued = false
queueScriptAfterTeleport = function()
    if not autoExecuteAfterTeleportEnabled or teleportScriptQueued then return end
    local queueFn = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if type(queueFn) ~= "function" then return end
    local sourceUrl = "https://raw.githubusercontent.com/mrldfr3-dot/Halouin-anime-dicd/refs/heads/main/Anime_Dice_Hub_Statistics_AutoExecute_CLOSE_CONFIRM.lua"
    local queuedCode = 'local blocked=pcall(function() return readfile("HalloweenHubClosed.flag") end); if not blocked then loadstring(game:HttpGet("' .. sourceUrl .. '"))() end'
    local ok = pcall(function() queueFn(queuedCode) end)
    if ok then teleportScriptQueued = true end
end

local function persistAutoExecuteSetting()
    pcall(function()
        if type(writefile) == "function" then
            writefile(autoExecuteSettingFile, HttpService:JSONEncode({enabled = autoExecuteAfterTeleportEnabled}))
        end
    end)
end

shutdownHub = function()
    if hubClosed then return end
    hubClosed = true

    -- Desliga os loops e conexões que poderiam continuar agindo sem a interface.
    pcall(stopFarm)
    pcall(function() setAntiAfk(false) end)
    pcall(function() setAutoRejoin(false) end)
    autoExecuteAfterTeleportEnabled = false
    pcall(persistAutoExecuteSetting)

    -- Bloqueia códigos de teleporte que ainda estejam na fila, quando o executor
    -- disponibiliza readfile/isfile. Uma nova execução do hub remove essa trava.
    pcall(function()
        if type(writefile) == "function" then
            writefile("HalloweenHubClosed.flag", "closed")
        end
    end)

    pcall(function() gui:Destroy() end)

    -- Remove o callback compartilhado apenas se ainda pertencer a esta instância.
    pcall(function()
        local env = getSharedExecutorEnv()
        if env and env.__HalloweenHubShutdown == shutdownHub then
            env.__HalloweenHubShutdown = nil
        end
    end)
end

-- Registra o desligamento desta instância para que a próxima execução possa
-- interromper farm/anti-AFK/rejoin anteriores antes de abrir a nova interface.
pcall(function()
    local env = getSharedExecutorEnv()
    if env then env.__HalloweenHubShutdown = shutdownHub end
end)

autoExecuteButton = makeButton(pages.Utility, "Autoexecute após teleporte: OFF", 150, function()
    autoExecuteAfterTeleportEnabled = not autoExecuteAfterTeleportEnabled
    autoExecuteButton.Text = autoExecuteAfterTeleportEnabled and "Autoexecute após teleporte: ON" or "Autoexecute após teleporte: OFF"
    persistAutoExecuteSetting()
    if autoExecuteAfterTeleportEnabled then
        queueScriptAfterTeleport()
    end
end)
autoExecuteButton.TextSize = 9

-- Recupera a preferência salva e arma o próximo teleporte quando possível.
task.spawn(function()
    task.wait(1)
    pcall(function()
        if type(readfile) == "function" and (type(isfile) ~= "function" or isfile(autoExecuteSettingFile)) then
            local saved = HttpService:JSONDecode(readfile(autoExecuteSettingFile))
            if type(saved) == "table" then autoExecuteAfterTeleportEnabled = saved.enabled == true end
        end
    end)
    if autoExecuteButton then
        autoExecuteButton.Text = autoExecuteAfterTeleportEnabled and "Autoexecute após teleporte: ON" or "Autoexecute após teleporte: OFF"
    end
    if autoExecuteAfterTeleportEnabled then queueScriptAfterTeleport() end
end)

-- Gerenciador exclusivo do evento de Halloween. Não salva Utility nem opções gerais.
local configNameLabel = makeLabel(pages.Config, "Nome da Config:", 0, 20)
local configNameBox = Instance.new("TextBox")
configNameBox.Name = "HalloweenConfigName"
configNameBox.Size = UDim2.new(1, 0, 0, 28)
configNameBox.Position = UDim2.fromOffset(0, 20)
configNameBox.BackgroundColor3 = Color3.fromRGB(38, 29, 49)
configNameBox.BorderSizePixel = 0
configNameBox.TextColor3 = Color3.new(1, 1, 1)
configNameBox.PlaceholderColor3 = Color3.fromRGB(175, 165, 185)
configNameBox.PlaceholderText = "Digite o nome da configuração"
configNameBox.Text = "Default"
configNameBox.ClearTextOnFocus = false
configNameBox.Font = Enum.Font.Gotham
configNameBox.TextSize = 12
configNameBox.Parent = pages.Config
Instance.new("UICorner", configNameBox).CornerRadius = UDim.new(0, 5)

local selectConfigButton = makeButton(pages.Config, "Select Config: Default", 162, function() end)
local halloweenConfigStatus = makeLabel(pages.Config, "Configuração de Halloween: pronta", 198, 42)
local autoloadButton

local function safeConfigName(name)
    name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    name = name:gsub("[^%w_%- ]", ""):gsub("%s+", "_"):sub(1, 40)
    return name
end

local function configPath(name)
    return halloweenConfigPrefix .. safeConfigName(name) .. ".json"
end

local function halloweenNotice(message)
    halloweenConfigStatus.Text = tostring(message):sub(1, 180)
end

local function writeAutoloadChoice()
    local ok, err = pcall(function()
        assert(type(writefile) == "function", "armazenamento de arquivos indisponível")
        writefile(halloweenAutoloadFile, HttpService:JSONEncode({
            enabled = halloweenAutoloadEnabled,
            name = selectedHalloweenConfig
        }))
    end)
    if not ok then halloweenNotice("Aviso: não foi possível salvar autoload: " .. tostring(err)) end
    return ok
end

local function saveHalloweenConfig()
    local name = safeConfigName(configNameBox.Text)
    if name == "" then halloweenNotice("Aviso: digite um nome válido."); return end
    local data = {
        schema = 1,
        name = name,
        -- Somente opções pertencentes ao farm/rota do evento de Halloween:
        movementMode = movementMode,
        speed = speed,
        autoFarm = running,
        antiAfk = antiAfkEnabled,
        autoRejoin = autoRejoinEnabled,
        autoLoad = autoLoadEnabled,
        autoExecuteAfterTeleport = autoExecuteAfterTeleportEnabled,
    }
    local ok, err = pcall(function()
        assert(type(writefile) == "function", "writefile indisponível neste executor")
        writefile(configPath(name), HttpService:JSONEncode(data))
    end)
    if ok then
        selectedHalloweenConfig = name
        configNameBox.Text = name
        writeAutoloadChoice()
        halloweenNotice("Config de Halloween salva: " .. name)
    else
        halloweenNotice("Aviso ao salvar: " .. tostring(err))
    end
end

local function loadHalloweenConfig(silent)
    local name = safeConfigName(configNameBox.Text)
    if name == "" then halloweenNotice("Aviso: digite o nome da configuração para carregar."); return false end
    local ok, dataOrErr = pcall(function()
        assert(type(readfile) == "function", "readfile indisponível neste executor")
        local path = configPath(name)
        assert(type(isfile) ~= "function" or isfile(path), "configuração não encontrada: " .. name)
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok then
        if not silent then halloweenNotice("Aviso ao carregar: " .. tostring(dataOrErr)) end
        return false
    end
    local data = dataOrErr
    if type(data) ~= "table" then
        if not silent then halloweenNotice("Aviso: arquivo de configuração inválido.") end
        return false
    end
    -- Validar individualmente para que um campo incorreto não interrompa o script.
    if data.movementMode == "Teleporte" or data.movementMode == "MoveTo" then
        setMovementMode(data.movementMode)
    end
    if type(data.speed) == "number" then
        speed = math.clamp(data.speed, 8, 200)
        pcall(function() local _, humanoid = characterParts(); humanoid.WalkSpeed = speed end)
    end
    if type(data.antiAfk) == "boolean" then setAntiAfk(data.antiAfk) end
    if type(data.autoRejoin) == "boolean" then setAutoRejoin(data.autoRejoin) end
    if type(data.autoLoad) == "boolean" then
        autoLoadEnabled = data.autoLoad
        if autoLoadButton then autoLoadButton.Text = autoLoadEnabled and "Auto Load: ON" or "Auto Load: OFF" end
    end
    if type(data.autoExecuteAfterTeleport) == "boolean" then
        autoExecuteAfterTeleportEnabled = data.autoExecuteAfterTeleport
        if autoExecuteButton then autoExecuteButton.Text = autoExecuteAfterTeleportEnabled and "Autoexecute após teleporte: ON" or "Autoexecute após teleporte: OFF" end
        pcall(function()
            if type(writefile) == "function" then writefile(autoExecuteSettingFile, HttpService:JSONEncode({enabled = autoExecuteAfterTeleportEnabled})) end
        end)
    end
    if data.autoFarm == true and not running then task.spawn(runRoute)
    elseif data.autoFarm == false and running then stopFarm() end
    selectedHalloweenConfig = name
    configNameBox.Text = name
    if selectConfigButton then selectConfigButton.Text = "Select Config: " .. name end
    halloweenNotice("Config de Halloween carregada: " .. name)
    updateStatus()
    return true
end

local function deleteHalloweenConfig()
    local name = safeConfigName(configNameBox.Text)
    if name == "" then halloweenNotice("Aviso: digite o nome da configuração para excluir."); return end
    local ok, err = pcall(function()
        assert(type(delfile) == "function", "delfile indisponível neste executor")
        local path = configPath(name)
        assert(type(isfile) ~= "function" or isfile(path), "configuração não encontrada: " .. name)
        delfile(path)
    end)
    if ok then
        if selectedHalloweenConfig == name then
            selectedHalloweenConfig = "Default"
            if halloweenAutoloadEnabled then halloweenAutoloadEnabled = false; writeAutoloadChoice() end
        end
        halloweenNotice("Config de Halloween excluída: " .. name)
    else
        halloweenNotice("Aviso ao excluir: " .. tostring(err))
    end
end

makeButton(pages.Config, "💾 Save Config", 54, saveHalloweenConfig)
makeButton(pages.Config, "📂 Load Config", 90, function() loadHalloweenConfig(false) end, 0.5)
local deleteConfigButton = makeButton(pages.Config, "🗑 Delete Config", 90, deleteHalloweenConfig, 0.5)
deleteConfigButton.Position = UDim2.new(0.5, 2, 0, 90)
local function listHalloweenConfigs()
    local names = {}
    local ok, files = pcall(function()
        assert(type(listfiles) == "function", "listfiles indisponível neste executor")
        return listfiles(".")
    end)
    if ok and type(files) == "table" then
        for _, file in ipairs(files) do
            local base = tostring(file):match("([^/\\]+)$") or tostring(file)
            local name = base:match("^" .. halloweenConfigPrefix .. "(.+)%.json$")
            if name then table.insert(names, name) end
        end
    end
    table.sort(names)
    return names
end

selectConfigButton.MouseButton1Click:Connect(function()
    local names = listHalloweenConfigs()
    if #names == 0 then
        halloweenNotice("Nenhuma config encontrada; salve uma primeiro.")
        return
    end
    local current = safeConfigName(configNameBox.Text)
    local idx = table.find(names, current) or 0
    idx = (idx % #names) + 1
    selectedHalloweenConfig = names[idx]
    configNameBox.Text = selectedHalloweenConfig
    selectConfigButton.Text = "Select Config: " .. selectedHalloweenConfig
    halloweenNotice("Selecionada: " .. selectedHalloweenConfig .. " (toque para alternar)")
end)
autoloadButton = makeButton(pages.Config, "Autoload Config After Join Game: OFF", 126, function()
    local name = safeConfigName(configNameBox.Text)
    if name == "" then halloweenNotice("Aviso: digite o nome da config de autoload."); return end
    selectedHalloweenConfig = name
    halloweenAutoloadEnabled = not halloweenAutoloadEnabled
    autoloadButton.Text = halloweenAutoloadEnabled and "Autoload Config After Join Game: ON" or "Autoload Config After Join Game: OFF"
    if writeAutoloadChoice() then
        halloweenNotice(halloweenAutoloadEnabled and ("Autoload definido para: " .. name) or "Autoload desativado.")
    end
end)
autoloadButton.TextSize = 9

-- Recupera apenas a escolha de autoload do evento, sem carregar configurações gerais.
task.spawn(function()
    local ok, saved = pcall(function()
        if type(readfile) ~= "function" then error("readfile indisponível") end
        if type(isfile) == "function" and not isfile(halloweenAutoloadFile) then return nil end
        return HttpService:JSONDecode(readfile(halloweenAutoloadFile))
    end)
    if ok and type(saved) == "table" then
        halloweenAutoloadEnabled = saved.enabled == true
        if type(saved.name) == "string" and safeConfigName(saved.name) ~= "" then
            selectedHalloweenConfig = safeConfigName(saved.name)
            configNameBox.Text = selectedHalloweenConfig
            if selectConfigButton then selectConfigButton.Text = "Select Config: " .. selectedHalloweenConfig end
        end
    end
    if autoloadButton then
        autoloadButton.Text = halloweenAutoloadEnabled and "Autoload Config After Join Game: ON" or "Autoload Config After Join Game: OFF"
    end
    if halloweenAutoloadEnabled then
        task.wait(1) -- aguarda a interface/script terminar de inicializar
        loadHalloweenConfig(true)
    end
end)

-- Statistics: somente tempo da sessão e informações do farm, sem itens.
local statsHeader = makeLabel(pages.Statistics, "📊 STATISTICS", 0, 38)
statsHeader.Font = Enum.Font.GothamBold
statsHeader.TextSize = 14
local statsSessionTimeLabel = makeLabel(pages.Statistics, "Tempo da sessão: 00:00:00", 44, 34)
local statsDoorsLabel = makeLabel(pages.Statistics, "Portas visitadas: 0/7", 82, 34)
local statsFarmStatusLabel = makeLabel(pages.Statistics, "Auto Farm: OFF", 120, 34)
local statsMovementLabel = makeLabel(pages.Statistics, "Modo de movimento: " .. tostring(movementMode), 158, 42)
local statsHintLabel = makeLabel(pages.Statistics, "O tempo reinicia somente quando o script é executado novamente.", 210, 54)

local function formatDuration(seconds)
    seconds = math.max(0, math.floor(seconds))
    return string.format("%02d:%02d:%02d", math.floor(seconds/3600), math.floor((seconds%3600)/60), seconds%60)
end

updateStatistics = function()
    statsSessionTimeLabel.Text = "Tempo da sessão: " .. formatDuration(os.clock() - scriptStartedAt)
    statsDoorsLabel.Text = "Portas visitadas: " .. tostring(doorCount) .. "/" .. tostring(#ROUTE_DATA.doors)
    statsFarmStatusLabel.Text = running and "Auto Farm: ON" or "Auto Farm: OFF"
    statsMovementLabel.Text = "Modo de movimento: " .. tostring(movementMode)
end

local timerTitle = makeLabel(pages.Tempo, "TEMPO DE EXECUÇÃO", 28, 32)
timerTitle.TextSize = 15
timerTitle.Font = Enum.Font.GothamBold
local timerValue = makeLabel(pages.Tempo, "00:00:00", 68, 52)
timerValue.TextSize = 24
timerValue.Font = Enum.Font.GothamBold
timerValue.TextColor3 = Color3.fromRGB(255, 160, 70)
local timerHint = makeLabel(pages.Tempo, "O cronômetro começa quando o script é executado.", 125, 42)

task.spawn(function()
    while gui.Parent do
        local elapsed = math.max(0, math.floor(os.clock() - scriptStartedAt))
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        timerValue.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        task.wait(1)
    end
end)

local credits = Instance.new("TextLabel")
credits.Name = "Credits"
credits.BackgroundTransparency = 1
credits.Size = UDim2.new(1, -12, 0, 16)
credits.Position = UDim2.new(0, 6, 1, -18)
credits.Text = "CRÉDITOS: Biel"
credits.TextColor3 = Color3.fromRGB(255, 160, 70)
credits.Font = Enum.Font.GothamBold
credits.TextSize = 10
credits.TextXAlignment = Enum.TextXAlignment.Center
credits.ZIndex = 5
credits.Parent = frame

local function showPage(name)
    page = name
    for pageName, p in pairs(pages) do p.Visible = pageName == name end
    for _, child in ipairs(tabBar:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = child.Name == name and Color3.fromRGB(100, 115, 170) or Color3.fromRGB(55, 58, 72)
        end
    end
end

local tabNames = {"Farm", "Utility", "Config", "Tempo", "Statistics"}
for index, name in ipairs(tabNames) do
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1/#tabNames, -3, 1, 0)
    b.Position = UDim2.new((index - 1)/#tabNames, (index - 1) * 2, 0, 0)
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
    if hubClosed then return end
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

showPage("Farm")
updateStatus()
task.spawn(function()
    while gui.Parent do
        updateCurrencies()
        updateStatistics()
        task.wait(2)
    end
end)
