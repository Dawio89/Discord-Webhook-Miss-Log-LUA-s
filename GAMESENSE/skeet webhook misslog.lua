--this one was repasted by nezu
local http = require 'gamesense/http'
local WEBHOOK_URL = 'https://discord.com/api/webhooks/<REDACTED>'
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local urn = "" --your username or whatever

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local shots = {}

local function aim_fire(e)
  print("aim_fire", e.id);
  shots[e.id] = e;
end
client.set_event_callback('aim_fire', aim_fire)

local function aim_hit(e)
  print("aim_hit", e.id);
  shots[e.id] = nil
end
client.set_event_callback('aim_hit', aim_hit)

local function aim_miss(e)
  print("aim_miss", e.id);
  local shot = shots[e.id];
  shots[e.id] = nil;

  local flags = {
    shot.teleported and 'T' or '',
        shot.interpolated and 'I' or '',
        shot.extrapolated and 'E' or '',
        shot.boosted and 'B' or '',
        shot.high_priority and 'H' or ''
    }
  local group = hitgroup_names[e.hitgroup + 1] or '?'
  local body = {
    content = string.format(
      "**["..urn.."]** Missed %s | [hc] %d | [bt] %d | [hg] %s | [dmg] %d | [flags] %s | missed due to: %s",
      entity.get_player_name(e.target), math.floor(e.hit_chance + 0.5), time_to_ticks(shot.backtrack), group, shot.damage, table.concat(flags), e.reason
    )
  }

  http.post(WEBHOOK_URL, { body = json.stringify(body), headers = { ['Content-Length'] = #json.stringify(body), ['Content-Type'] = 'application/json' } }, function() end)
end
client.set_event_callback('aim_miss', aim_miss)