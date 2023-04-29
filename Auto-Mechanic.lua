script_name('Auto-Mechanic')
script_author('Mshq0')

require('lib.moonloader')

local imgui = require('imgui')
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local inicfg = require 'inicfg'

local defaultIni = inicfg.load({
    values = {
        reparePrice = 500
    },
    overlay = {
        view = false,
        userName = false,
        userId = false,
        carName = false,
        carId = false,
        carHealth = false,
        carBenz = false
    }
}, 'Auto-Mechanic')

local reparePrice = imgui.ImBuffer(256)

local view = imgui.ImBool(defaultIni.overlay.view)
local userName = imgui.ImBool(defaultIni.overlay.userName)
local userId = imgui.ImBool(defaultIni.overlay.userId)
local carName = imgui.ImBool(defaultIni.overlay.carName)
local carId = imgui.ImBool(defaultIni.overlay.carId)
local carHealth = imgui.ImBool(defaultIni.overlay.carHealth)
local carBenz = imgui.ImBool(defaultIni.overlay.carBenz)

if not doesFileExist('moonloader/config/Auto-Mechanic.ini') then inicfg.save(defaultIni, 'Auto-Mechanic.ini') end

local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()

local index = 0

function main()
if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('mech', function()
        if main_window_state.v then return end
        main_window_state.v = not main_window_state.v
        imgui.Process = main_window_state.v
    end)

    imgui.Process = false

    while 1 do wait(0)
        if not main_window_state.v then imgui.Process = false end
    end
end

function imgui.OnDrawFrame()
    if main_window_state.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(380, 270))
        imgui.Begin(u8'Auto-Mechanic', main_window_state, imgui.WindowFlags.NoResize)

        imgui.BeginChild('#menu', imgui.ImVec2(365, 45), true)

            if imgui.Button(u8'Значения', imgui.ImVec2(170, 30)) then index = 1 end

            imgui.SameLine()

            if imgui.Button(u8'Оверлей', imgui.ImVec2(170, 30)) then index = 2 end

        imgui.EndChild()

        imgui.BeginChild('#settings', imgui.ImVec2(365, 175), true)

            if index == 1 then
                imgui.PushItemWidth(40)
                imgui.InputText(u8'Стоимость починки', reparePrice)
                imgui.PushItemWidth(0)
                imgui.SameLine()
                imgui.Text('/repare [id] '.. reparePrice.v)
                imgui.SameLine()
                if imgui.Button(u8'Сохранить') then
                    defaultIni.values.reparePrice = reparePrice.v
                    inicfg.save(defaultIni, 'Auto-Mechanic.ini')
                    sampAddChatMessage('[Auto-Mechanic]: Стоимость починки изменена!', -1)
                end

                imgui.Separator()
                imgui.Text(u8'Количество заправляемого бензина - определяется автоматически.')
                imgui.Text(u8' ')
                imgui.Text(u8'F - Repare, G - Filscar')
            end
            if index == 2 then
                imgui.Checkbox(u8'Показывать оверлей', view)
                imgui.SameLine()
                if imgui.Button(u8'Сохранить') then
                    defaultIni.overlay.view = view.v
                    defaultIni.overlay.userName = userName.v
                    defaultIni.overlay.userId = userId.v
                    defaultIni.overlay.carName = carName.v
                    defaultIni.overlay.carId = carId.v
                    defaultIni.overlay.carHealth = carHealth.v
                    defaultIni.overlay.carBenz = carBenz.v
                    if inicfg.save(defaultIni, 'Auto-Mechanic.ini') then
                        sampAddChatMessage('Настройки оверлея изменены!', -1)
                    end
                end
                imgui.Separator()
                imgui.Checkbox(u8'Псевдоним игрока', userName)
                imgui.Checkbox(u8'Айди игрока', userId)
                imgui.Separator()
                imgui.Checkbox(u8'Название машины', carName)
                imgui.Checkbox(u8'Айди машины', carId)
                imgui.Checkbox(u8'Здоровье машины', carHealth)
                imgui.Checkbox(u8'Бензин машины', carBenz)
            end

        imgui.EndChild()
    end
    imgui.End()
end