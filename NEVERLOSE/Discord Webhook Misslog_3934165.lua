--Discord Webhook Misslog--
ui.sidebar("\a5147FFFFDiscord H/M log","align-right") --NL script icon

ffi.cdef[[void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);]];
local shell32 = ffi.load 'Shell32'

files.create_folder("Discord Webhook")

local main = ui.create("Main", "                                                        Discord Webhook Misslog")
main:label("                            If you have any questions, DM me on Discord: \a5147FFFFDawio89#9849")
local url_menu = main:input("Webhook", "https://discord.com/api/webhooks/...")
local combo = main:selectable("Conditions","Miss","Hit","Console")
local save_url = main:button("Save Webhook",function()
    files.write("Discord Webhook/saved webhook.lua", url_menu:get())
    common.reload_script()
end)
local howto = main:button("How to make a webhook", function()
  shell32.ShellExecuteA(nil, "open", "https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks", nil, nil, 1)
end)
local urn = common.get_username()
local hitboxes = {'Head','Neck','Pelvis','Stomach','Lower Chest', 'Chest','Upper Chest','Right Thigh', 'Left Thigh','Right Calf','Left Calf','Right Foot','Left Foot','Right Hand','Left Hand','Right Upper Arm','Right Forearm','Left Upper Arm','Left Forearm'}
local url = files.read("Discord Webhook/saved webhook.lua")
print(url)


local function hook(msg)
    network.post(string.format("%s", url),string.format("content=%s",msg),postasync,function(urlContent)
   end)
end

events.aim_fire:set(function(shoot)
    hitgroup = hitboxes[shoot.hitgroup]
	damage = shoot.damage
end)

events.aim_ack:set(function(e)
    damage_h = e.damage
    hitgroup_h = hitboxes[e.hitgroup]
    Hitchance = e.hitchance
    Backtrack = e.backtrack
    playerIndex = e.target_index
    Status = e.state
        if Status == "misprediction" then
            fixedStatus = "jitter correction"
        elseif Status == "correction" then
            fixedStatus = "resolver"
        else
            fixedStatus = Status
        end
    targetEntity = entity.get_local_player()
    targetPlayerObject = e.target
    Name = targetPlayerObject:get_name()
if not (Status == Hit) and combo:get(1) then
  post = string.format('**['..urn..']** Missed %s | [hc] %s | [bt] %s | [hg] %s | [dmg] %d | missed due to: %s', Name, Hitchance,
  Backtrack, hitgroup, damage, fixedStatus)
    if combo:get(3) then
        print_raw(string.format('\aFFFFFF['..urn..'] Missed %s | [hc] %s | [bt] %s | [hg] %s | [dmg] %d | missed due to: %s', Name, Hitchance,
        Backtrack, hitgroup, damage, fixedStatus))
    end
else if combo:get(2) then
  post = string.format('**['..urn..']** Hit %s | [hc] %s | [bt] %s | [hg] %s [aimed: %s] | [dmg] %d [aimed: %d] ', Name, Hitchance,
  Backtrack, hitgroup_h, hitgroup, damage_h, damage)
    if combo:get(3) then
        print_raw(string.format('\aFFFFFF['..urn..'] Hit %s | [hc] %s | [bt] %s | [hg] %s [aimed: %s] | [dmg] %d [aimed: %d] ', Name, Hitchance,
        Backtrack, hitgroup_h, hitgroup, damage_h, damage))
    end
else return end
end
    hook(post)
end)
