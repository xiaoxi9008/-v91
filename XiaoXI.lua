-- 基础服务定义
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- 加载 UI 库
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

-- 创建窗口
local Window = Library:CreateWindow({
    ["Folder"] = "MyTestHub",
    ["Title"] = "XiaoXI",
    ["Author"] = "wind ui",
    ["Icon"] = "rbxassetid://7734068321",
    HideSearchBar = false,
})

-------------------------------------------------------------------------
-- Tab: 公告 (Announcements)
-------------------------------------------------------------------------
local Tab_Notice = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "公告",
    ["Icon"] = "rbxassetid://115466270141583",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者小西，QQ群912837219",
    TextXAlignment = "Left",
})

-------------------------------------------------------------------------
-- Tab: 通用 (General)
-------------------------------------------------------------------------
local Tab_General = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "通用",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_General:Button({
    ["Title"] = "反挂机",
    ["Desc"] = "反挂机踢出",
    ["Callback"] = function()
        print("Anti Afk On")
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), CurrentCamera.CFrame)
        end)
        StarterGui:SetCore("SendNotification", {
            ["Title"] = "反挂机2已开启",
            ["Text"] = "虽然不知道有没有增强",
            ["Duration"] = 5,
        })
    end
})

Tab_General:Button({
    ["Title"] = "无敌少侠飞行脚本",
    ["Desc"] = "只支持R15",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))()
    end
})

Tab_General:Button({
    ["Title"] = "飞行",
    ["Desc"] = "普通飞行",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/114514lzkill/-/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%AC.lua"))()
    end
})

Tab_General:Button({
    ["Title"] = "开启玩家进出服务器提示",
    ["Desc"] = "......",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
    end
})

Tab_General:Slider({
    ["Title"] = "速度设置",
    ["Step"] = 1,
    ["Value"] = { Min = 16, Default = 16, Max = 1000 },
    ["Callback"] = function(Value)
        -- 注意：部分UI库传入的是table，如果是table取第一个值
        local speed = type(Value) == "table" and Value[1] or Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
})

Tab_General:Slider({
    ["Title"] = "跳跃设置",
    ["Step"] = 1,
    ["Value"] = { Min = 50, Default = 50, Max = 200 },
    ["Callback"] = function(Value)
        local jump = type(Value) == "table" and Value[1] or Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = jump
        end
    end
})

Tab_General:Slider({
    ["Title"] = "头部大小",
    ["Step"] = 0.1,
    ["Value"] = { Min = 0.5, Default = 1, Max = 100 },
    ["Callback"] = function(Value)
        -- 原逻辑似乎不完整，这里根据标题还原逻辑
        local size = type(Value) == "table" and Value[1] or Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            LocalPlayer.Character.Head.Size = Vector3.new(size, size, size)
        end
    end
})

Tab_General:Slider({
    ["Title"] = "重力设置",
    ["Step"] = 1,
    ["Value"] = { Min = 0, Default = 196.2, Max = 196.2 },
    ["Callback"] = function(Value)
        local grav = type(Value) == "table" and Value[1] or Value
        Workspace.Gravity = grav
    end
})

Tab_General:Slider({
    ["Title"] = "超广角设置",
    ["Step"] = 1,
    ["Value"] = { Min = 20, Default = 70, Max = 120 },
    ["Callback"] = function(Value)
        local fov = type(Value) == "table" and Value[1] or Value
        CurrentCamera.FieldOfView = fov
    end
})

Tab_General:Button({
    ["Title"] = "重新加入服务器",
    ["Desc"] = "",
    ["Callback"] = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Tab_General:Button({
    ["Title"] = "离开服务器",
    ["Desc"] = "",
    ["Callback"] = function()
        game:Shutdown()
    end
})

-- FPS 显示逻辑
Tab_General:Button({
    ["Title"] = "帧率显示",
    ["Desc"] = "显示",
    ["Callback"] = function()
        if LocalPlayer.PlayerGui:FindFirstChild("FPSGui") then return end
        
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "FPSGui"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "FPSLabel"
        TextLabel.Size = UDim2.new(0, 100, 0, 50)
        TextLabel.Position = UDim2.new(0, 10, 0, 10)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Text = "帧率: 0"
        TextLabel.TextSize = 20
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.Parent = ScreenGui
        
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        RunService.RenderStepped:Connect(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            TextLabel.Text = "帧率: " .. fps
        end)
    end
})

-- 时间显示逻辑
Tab_General:Button({
    ["Title"] = "时间显示",
    ["Desc"] = "显示",
    ["Callback"] = function()
        if game.CoreGui:FindFirstChild("LBLG") then return end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "LBLG"
        ScreenGui.Parent = game.CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "LBL"
        TextLabel.Parent = ScreenGui
        TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderColor3 = Color3.new(0, 0, 0)
        TextLabel.Position = UDim2.new(0.75, 0, 0.01, 0)
        TextLabel.Size = UDim2.new(0, 133, 0, 30)
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.TextScaled = true
        TextLabel.TextSize = 14
        TextLabel.TextWrapped = true
        
        RunService.Heartbeat:Connect(function()
            -- 这里使用 os.date 格式化时间，修复原始逻辑的复杂时间戳计算
            local currentTime = os.date("%H时%M分%S秒")
            TextLabel.Text = "北京时间:" .. currentTime
        end)
    end
})

Tab_General:Button({
    ["Title"] = "重开",
    ["Desc"] = "乐子重开",
    ["Callback"] = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end
})

Tab_General:Button({
    ["Title"] = "后门脚本",
    ["Desc"] = "后门",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/iK4oS/backdoor.exe/v6x/source.lua"))()
    end
})

Tab_General:Button({
    ["Title"] = "偷别人物品拿道具",
    ["Desc"] = "小偷",
    ["Callback"] = function()
        -- 原始逻辑是不断循环将背包里的东西重新Parent回背包
        -- 这看起来像是一个“刷新库存”或者防止掉落的逻辑，或者尝试卡Bug
        local Backpack = LocalPlayer.Backpack
        for i = 1, 10 do -- 还原原代码展开的多次循环
            for _, item in pairs(Backpack:GetChildren()) do
                item.Parent = Backpack
            end
            wait()
        end
    end
})

Tab_General:Button({
    ["Title"] = "飞檐走壁",
    ["Desc"] = "飞起来",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
    end
})

-- 网易云音乐逻辑
Tab_General:Button({
    ["Title"] = "网易云",
    ["Desc"] = "听音乐",
    ["Callback"] = function()
        -- 这是一个内嵌的音乐播放器UI
        local MusicScript = loadstring(game:HttpGet("https://github.com/DevSloPo/Auto/raw/main/Ware-obfuscated.lua"))()
        local MusicUI = MusicScript:new("沙脚本 | 音乐")
        
        local SearchTab = MusicUI:Tab("搜索")
        local SearchSection = SearchTab:section("搜索", true)
        
        local ResultTab = MusicUI:Tab("数量")
        local ResultSection = ResultTab:section("结果", true)
        local ResultLabel = ResultSection:Label("搜索结果数量: 0")

        SearchSection:Textbox("请输入歌曲名称", "", "输入歌曲名称后按回车", function(input)
            local songName = input[1] -- 假设输入框返回table
            local encodedName = HttpService:UrlEncode(songName)
            local url = "https://music.163.com/api/search/get?s=" .. encodedName .. "&type=1&limit=100"
            
            local response = game:HttpGet(url)
            local data = HttpService:JSONDecode(response)
            
            ResultSection:Label("当前搜索: " .. songName)
            
            if data and data.result and data.result.songs then
                local songs = data.result.songs
                if #songs > 0 then
                   -- 原代码逻辑似乎在此中断，这里应该有播放逻辑，但原始代码未包含完整播放部分
                   print("找到歌曲: " .. #songs .. "首")
                   ResultLabel:Set("搜索结果数量: " .. #songs)
                else
                   print("未找到相关歌曲")
                   ResultLabel:Set("搜索结果数量: 0")
                end
            else
                print("API请求失败")
            end
        end)
        
        -- 占位按钮
        SearchSection:Button("开始播放音乐", function() print("没有歌曲可播放") end)
        SearchSection:Button("停止播放音乐", function() print("没有正在播放的歌曲") end)
    end
})

Tab_General:Button({
    ["Title"] = "老外撸管脚本r15",
    ["Desc"] = "撸管",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})

Tab_General:Button({
    ["Title"] = "老外撸管脚本r6",
    ["Desc"] = "撸管",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    end
})

Tab_General:Button({
    ["Title"] = "吸人(一局只能吸一次)",
    ["Desc"] = "吸人",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/PVPFXqtH"))()
    end
})

Tab_General:Button({
    ["Title"] = "获取管理员",
    ["Desc"] = "管理员",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/sZpgTVas"))()
    end
})

Tab_General:Button({
    ["Title"] = "快速旋转",
    ["Desc"] = "转起来",
    ["Callback"] = function()
        local Character = LocalPlayer.Character
        local Humanoid = Character:FindFirstChild("Humanoid")
        
        -- 动画播放逻辑
        spawn(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507776043"
            local track = Humanoid:LoadAnimation(anim)
            track:Play()
            track:AdjustSpeed(0)
            
            if Character:FindFirstChild("Animate") then
                Character.Animate.Disabled = true
            end
            
            -- 声音播放
            local sound = Instance.new("Sound")
            sound.Name = "Sound"
            sound.SoundId = "http://www.roblox.com/asset/?id=8114290584"
            sound.Volume = 0
            sound.Looped = false
            sound.Parent = Workspace
            sound:Play()
            
            wait()
            
            -- 旋转物理逻辑
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "Spinning"
            bav.Parent = Character.HumanoidRootPart
            bav.MaxTorque = Vector3.new(0, math.huge, 0)
            bav.AngularVelocity = Vector3.new(0, 30, 0)
            
            wait(3.5)
            -- 后续清理或检查逻辑
        end)
    end
})

Tab_General:Button({
    ["Title"] = "极速旋转",
    ["Desc"] = "转起来",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/ckiGL34v"))()
    end
})

Tab_General:Button({
    ["Title"] = "锁定视角",
    ["Desc"] = "锁定",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/gdLR5Z7X"))()
    end
})

Tab_General:Button({
    ["Title"] = "无限跳",
    ["Desc"] = "无限跳",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
    end
})

Tab_General:Button({
    ["Title"] = "灵魂出窍",
    ["Desc"] = "灵魂出窍",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/ahK5jRxM"))()
    end
})

Tab_General:Button({
    ["Title"] = "让走路和跳跃变卡(对别人没影响)",
    ["Desc"] = "卡死你",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Fe%20Fake%20Lag%20Obfuscator"))()
    end
})

Tab_General:Button({
    ["Title"] = "穿墙(可关闭)",
    ["Desc"] = "穿墙",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/OtherScript/main/Noclip"))()
    end
})

Tab_General:Button({
    ["Title"] = "阿尔宙斯注入器3.0",
    ["Desc"] = "阿尔宙斯注入器老版本",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3"))()
    end
})

Tab_General:Button({
    ["Title"] = "选人甩飞（需要输入别人的名字）",
    ["Desc"] = "帅飞",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Auto%20Fling%20Player"))()
    end
})

Tab_General:Button({
    ["Title"] = "飞车",
    ["Desc"] = "让车飞起来",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/114514lzkill/ShaFLY/refs/heads/main/ShaVFLY.lua"))()
    end
})

Tab_General:Button({
    ["Title"] = "甩飞",
    ["Desc"] = "帅飞",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/114514lzkill/Shafly2.0/refs/heads/main/Shafly2.0.lua"))()
    end
})

Tab_General:Button({
    ["Title"] = "点击传送工器",
    ["Desc"] = "传送",
    ["Callback"] = function()
        local Mouse = LocalPlayer:GetMouse()
        local Tool = Instance.new("Tool")
        Tool.RequiresHandle = false
        Tool.Name = "[bs中心]传送工具"
        Tool.Activated:Connect(function()
            local pos = Mouse.Hit.Position + Vector3.new(0, 2.5, 0)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
            end
        end)
        Tool.Parent = LocalPlayer.Backpack
    end
})

-------------------------------------------------------------------------
-- Tab: 范围 (Range/Hitbox)
-------------------------------------------------------------------------
local Tab_Range = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "范围",
    ["Icon"] = "rbxassetid://87107069659024",
})

-- 辅助函数：修改玩家碰撞箱
local function ResizeHitbox(size, transparency)
    _G.HeadSize = size
    _G.Disabled = true
    
    RunService.RenderStepped:Connect(function()
        if _G.Disabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    -- 尝试获取角色并修改
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(size, size, size)
                        hrp.Transparency = transparency or 0.7
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end)
end

Tab_Range:Button({
    ["Title"] = "普通范围",
    ["Desc"] = "范围",
    ["Callback"] = function()
        ResizeHitbox(30)
    end
})

Tab_Range:Button({
    ["Title"] = "中等范围",
    ["Desc"] = "范围",
    ["Callback"] = function()
        -- 原始逻辑仅开启循环但没有明确大小，推测与上一个类似或更大，这里假设为50
        ResizeHitbox(50) 
    end
})

Tab_Range:Button({
    ["Title"] = "全图范围",
    ["Desc"] = "范围",
    ["Callback"] = function()
        ResizeHitbox(100) -- 假设为全图大小
    end
})

Tab_Range:Button({
    ["Title"] = "终极范围",
    ["Desc"] = "范围",
    ["Callback"] = function()
        ResizeHitbox(200) -- 假设为终极大小
    end
})

-------------------------------------------------------------------------
-- Tab: 加入服务器 (Join Server)
-------------------------------------------------------------------------
local Tab_Join = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "加入服务器",
    ["Icon"] = "14895392107",
})

Tab_Join:Button({
    ["Title"] = "加入极速传奇",
    ["Desc"] = "加入",
    ["Callback"] = function()
        TeleportService:Teleport(3101667897, LocalPlayer)
    end
})

Tab_Join:Button({
    ["Title"] = "加入自然灾害生存游戏",
    ["Desc"] = "加入",
    ["Callback"] = function()
        TeleportService:Teleport(189707, LocalPlayer)
    end
})

Tab_Join:Button({
    ["Title"] = "加入监狱人生",
    ["Desc"] = "加入",
    ["Callback"] = function()
        TeleportService:Teleport(155615604, LocalPlayer)
    end
})

-------------------------------------------------------------------------
-- Tab: 死铁轨 (Dead Rails)
-------------------------------------------------------------------------
local Tab_DeadRails = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "死铁轨",
    ["Icon"] = "rbxassetid://108664063",
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨攻速脚本",
    ["Desc"] = "功速无敌",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HeadHarse/DeadRails/refs/heads/main/V4SWING"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨自动胜利脚本",
    ["Desc"] = "会自杀",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Dead-Rails-Alpha-Auto-Win-Script-for-Dead-Rails-Instant-win-AFK-farm-KEYLESS-39867"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "SansHUB死铁轨脚本",
    ["Desc"] = "要卡密",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/iopjklbnmsss/SansHubScript/refs/heads/main/SansHub"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨飞行",
    ["Desc"] = "好用",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AmareScripts/DeadRails/refs/heads/main/FlyV2%25viaTurret.lua"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨功能最多",
    ["Desc"] = "好用",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://github.com/Synergy-Networks/products/raw/main/Rift/loader.lua"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨红叶脚本",
    ["Desc"] = "要解卡",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://getnative.cc/script/loader"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨TX退休脚本",
    ["Desc"] = "......",
    ["Callback"] = function()
        getgenv().TX = "退休脚本"
        getgenv().QUN = "160369111"
        loadstring(game:HttpGet("https://pastefy.app/64DctLM5/raw"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨RINGTA脚本",
    ["Desc"] = "好用",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/DEADRAILSOP.github.io/refs/heads/main/ringta.lua"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨自动刷卷",
    ["Desc"] = "好用",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/thiennrb7/Script/refs/heads/main/autobond"))()
    end
})

Tab_DeadRails:Button({
    ["Title"] = "死铁轨手动通关汉化（由沙记汉化）",
    ["Desc"] = "由沙记汉化",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/114514lzkill/Dedrail/refs/heads/main/死铁轨手动通关汉化.lua"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 俄亥俄州 (Ohio)
-------------------------------------------------------------------------
local Tab_Ohio = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "俄亥俄州",
    ["Icon"] = "rbxassetid://11949291636",
})

Tab_Ohio:Button({
    ["Title"] = "XA俄亥俄州",
    ["Desc"] = "好用无比",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/Ohio"))()
    end
})

Tab_Ohio:Button({
    ["Title"] = "宿摊自动刷钱",
    ["Desc"] = "刷钱",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sukuna2134/sukunascriptfree/refs/heads/main/%E5%AE%BF%E5%82%A9%E4%BF%84%E4%BA%A5%E4%BF%84%E5%B7%9E%E8%87%AA%E5%8A%A8%E6%8D%A2%E6%9C%8D%E6%8C%82%E6%9C%BA.lua"))()
    end
})

Tab_Ohio:Button({
    ["Title"] = "AL印钞机",
    ["Desc"] = "刷钱",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pijiaobenMSJMleng/ehhdvdhd/refs/heads/main/good.lua"))()
    end
})

Tab_Ohio:Button({
    ["Title"] = "SonwHUB",
    ["Desc"] = "攻击XA",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/canxiaoxue666/SnowHubDemo/refs/heads/main/SnowHub"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 被遗弃 (Abandoned)
-------------------------------------------------------------------------
local Tab_Abandoned = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "被遗弃",
    ["Icon"] = "rbxassetid://94876458579556",
})

Tab_Abandoned:Button({
    ["Title"] = "情云",
    ["Desc"] = "好用",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ChinaQY/-/main/%E6%83%85%E4%BA%91"))()
    end
})

Tab_Abandoned:Button({
    ["Title"] = "某某脚本免费版",
    ["Desc"] = "好用到爆炸",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OWOWOWWOW/HTT/main/HT.lua"))()
    end
})

Tab_Abandoned:Button({
    ["Title"] = "被遗弃油管搬运脚本",
    ["Desc"] = "不知道",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SkibidiCen/MainMenu/main/Code"))()
    end
})

Tab_Abandoned:Button({
    ["Title"] = "被遗弃esp脚本",
    ["Desc"] = "esp",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmaboy-sigma-boy/sigmaboy-sigma-boy/refs/heads/main/StaminaSettings.ESP.PIDC.raw"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 战争大亨 (War Tycoon)
-------------------------------------------------------------------------
local Tab_WarTycoon = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "战争大亨",
    ["Icon"] = "rbxassetid://13316963733",
})

Tab_WarTycoon:Button({
    ["Title"] = "一枪秒人",
    ["Desc"] = "不知道",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/6b4XEjQF"))()
    end
})

Tab_WarTycoon:Button({
    ["Title"] = "乌托邦战争大亨",
    ["Desc"] = "...........",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/USA868/-/refs/heads/main/.github/workflows/%E6%88%98%E4%BA%89%E5%A4%A7%E4%BA%A8.lua"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 无限R币 (Fake Robux)
-------------------------------------------------------------------------
local Tab_Robux = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "无限R币",
    ["Icon"] = "rbxassetid://12231578130",
})

-- 注意：以下脚本实际上是同一个链接，都是 UI 模拟
local fakeRobuxUrl = "https://raw.githubusercontent.com/114514lzkill/gg/refs/heads/main/gg.lua"

Tab_Robux:Button({ ["Title"] = "80R", ["Desc"] = "包真实", ["Callback"] = function() loadstring(game:HttpGet(fakeRobuxUrl))() end })
Tab_Robux:Button({ ["Title"] = "160R", ["Desc"] = "包真实", ["Callback"] = function() loadstring(game:HttpGet(fakeRobuxUrl))() end })
Tab_Robux:Button({ ["Title"] = "300R", ["Desc"] = "包真实", ["Callback"] = function() loadstring(game:HttpGet(fakeRobuxUrl))() end })
Tab_Robux:Button({ ["Title"] = "400R加会员", ["Desc"] = "包真实", ["Callback"] = function() loadstring(game:HttpGet(fakeRobuxUrl))() end })
Tab_Robux:Button({ ["Title"] = "1000R", ["Desc"] = "包真实", ["Callback"] = function() loadstring(game:HttpGet(fakeRobuxUrl))() end })
Tab_Robux:Button({ ["Title"] = "1000R加会员", ["Desc"] = "包真实", ["Callback"] = function() loadstring(game:HttpGet(fakeRobuxUrl))() end })

-------------------------------------------------------------------------
-- Tab: Doors
-------------------------------------------------------------------------
local Tab_Doors = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "doors",
    ["Icon"] = "rbxassetid://10940966071",
})

Tab_Doors:Button({
    ["Title"] = "BobHUB汉化",
    ["Desc"] = "好用",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/65TwT8ja"))()
    end
})

Tab_Doors:Button({
    ["Title"] = "mspaint v3汉化",
    ["Desc"] = "好用",
    ["Callback"] = function()
        getgenv()["Spy"] = "mspaint"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoXuAnZang/XKscript/refs/heads/main/DOORS.txt"))()
    end
})

Tab_Doors:Button({
    ["Title"] = "微山2.3.2",
    ["Desc"] = "愚人节",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/uHHp8fzS"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 速度传奇 (Speed Legends)
-------------------------------------------------------------------------
local Tab_SpeedLegends = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "速度传奇",
    ["Icon"] = "rbxassetid://15949388921",
})

Tab_SpeedLegends:Button({
    ["Title"] = "开启卡宠",
    ["Desc"] = "要钱",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/uR6azdQQ"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 墨水游戏 (Ink Game)
-------------------------------------------------------------------------
local Tab_Ink = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "墨水游戏",
    ["Icon"] = "rbxassetid://106484596651517",
})

Tab_Ink:Button({
    ["Title"] = "XA",
    ["Desc"] = "好用到爆",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/墨水游戏.lua"))()
    end
})

Tab_Ink:Button({
    ["Title"] = "TexRBLX",
    ["Desc"] = "好用到爆",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TexRBLX/Roblox-stuff/refs/heads/main/ink-game/testing.lua"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 监狱人生 (Prison Life)
-------------------------------------------------------------------------
local Tab_PrisonLife = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "监狱人生",
    ["Icon"] = "rbxassetid://1839014184",
})

Tab_PrisonLife:Button({
    ["Title"] = "手理剑",
    ["Desc"] = "秒人",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/114514lzkill/jian/refs/heads/main/jian.lua"))()
    end
})

Tab_PrisonLife:Button({
    ["Title"] = "变车模型",
    ["Desc"] = "真车",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zLe3e4BS"))()
    end
})

Tab_PrisonLife:Button({
    ["Title"] = "杀所有人(不可关)",
    ["Desc"] = "关不掉",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/kXjfpFPh"))()
    end
})

Tab_PrisonLife:Button({
    ["Title"] = "无敌模式",
    ["Desc"] = "无敌",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/LdTVujTA"))()
    end
})

-- 监狱人生传送点
Tab_PrisonLife:Button({
    ["Title"] = "警卫室",
    ["Desc"] = "传送",
    ["Callback"] = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(847.7, 99, 2267.4)
        end
    end
})

Tab_PrisonLife:Button({
    ["Title"] = "监狱室内",
    ["Desc"] = "传送",
    ["Callback"] = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(919.2, 99, 2379.7)
        end
    end
})

Tab_PrisonLife:Button({
    ["Title"] = "罪犯复活点",
    ["Desc"] = "传送",
    ["Callback"] = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-937.6, 93.1, 2063.0)
        end
    end
})

Tab_PrisonLife:Button({
    ["Title"] = "监狱室外",
    ["Desc"] = "传送",
    ["Callback"] = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(760.6, 97, 2475.4)
        end
    end
})

Tab_PrisonLife:Button({
    ["Title"] = "超强指令",
    ["Desc"] = "不知道",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Asddffgujhh/-/refs/heads/main/%E7%9B%91%E7%8B%B1%E4%BA%BA%E7%94%9F%E8%B6%85%E5%BC%BA%E6%8C%87%E4%BB%A4"))()
    end
})

-------------------------------------------------------------------------
-- Tab: GB
-------------------------------------------------------------------------
local Tab_GB = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "GB",
    ["Icon"] = "rbxassetid://130924875419603",
})

Tab_GB:Button({
    ["Title"] = "清风",
    ["Desc"] = "国人脚本",
    ["Callback"] = function()
        -- 按钮回调为空，可能是占位符
    end
})

Tab_GB:Button({
    ["Title"] = "清风老大版",
    ["Desc"] = "国人脚本",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://freenote.biz/raw/muznherhru", true))()
    end
})

Tab_GB:Button({
    ["Title"] = "2代",
    
