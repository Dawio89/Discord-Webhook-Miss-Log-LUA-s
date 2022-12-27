--Discord Webhook Misslog for Ev0lve by Dawio89--
local urn = info.ev0lve.username
local url = "" -- set your webhook here
local hitboxes = {'Head','Chest','Stomach','Left Arm', 'Right Arm','Left Leg','Right Leg'}
local hits = gui.checkbox("scripts.elements_a.hits", "scripts.elements_a", "Log hit's")
local misses = gui.checkbox("scripts.elements_a.misses", "scripts.elements_a", "Log misses")
function send(msg)
    utils.http_post(url,"Content-Type: application/x-www-form-urlencoded", string.format("content=%s",msg), function(urlContent)
    end)
end

function on_shot_fired(shot_info)
    if shot_info.manual then return end
    local target = shot_info.target
    local name = engine.get_player_info(target).name
    local hc = shot_info.hitchance
    local hitchance = string.format("%d", hc * 100)
    local backtrack = shot_info.backtrack
    local hitbox = hitboxes[shot_info.client_hitgroup]
    local hitbox_h = hitboxes[shot_info.server_hitgroup]
    local damage = shot_info.client_damage
    local damage_h = shot_info.server_damage
    local reason = shot_info.result

if (shot_info.result ~= "hit") and misses:get_value() then
    if reason == "" then
        reason_1 = "resolver"
    else 
        reason_1 = reason
    end
    post = string.format("**["..urn.."]** Missed %s | [hc] %i | [bt] %i | [hg] %s | [dmg] %i | missed due to: %s",
    name, hitchance, backtrack, hitbox, damage, reason_1)

  else if (shot_info.result == "hit") and  hits:get_value() then
    post = string.format('**['..urn..']** Hit %s | [hc] %s | [bt] %s | [hg] %s [aimed: %s] | [dmg] %d [aimed: %d] ', name, hitchance,
    backtrack, hitbox_h, hitbox, damage_h, damage)

  else return end
  end
      send(post)
  end


