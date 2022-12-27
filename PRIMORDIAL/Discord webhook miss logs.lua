local enable     = menu.add_checkbox("Webhook miss log", "enable")
local httpFactory = require('Lightweight HTTP Library')
local Discord = require('Discord Webhook Library')
local Webhook = Discord.new('')--your webhook here
local RichEmbed = Discord.newEmbed()
local hitgroupName = {"Generic", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg", "Right leg", "Neck", "Gear"},
Webhook:setUsername('Primordial')
Webhook:setAvatarURL('https://i.imgur.com/3obbq9G.png')

local http = httpFactory.new({
    task_interval = 0.3,
    enable_debug = false,
    timeout = 10
})

local function on_aimbot_miss(miss)
    if enable:get() then
        Webhook:send('**['..user.name..']** Missed ' ..miss.player:get_name().. ' | [hc] '.. miss.aim_hitchance ..' | [bt] '.. miss.backtrack_ticks - 1 ..' | [hg] '.. hitgroupName[miss.aim_hitgroup + 1] ..' | [dmg] '.. miss.aim_damage ..' | missed due to: '.. miss.reason_string)
    end
end

callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)