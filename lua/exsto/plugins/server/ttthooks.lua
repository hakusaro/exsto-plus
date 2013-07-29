-- Trouble in Terrorist Town Map Vote Trigger
-- Exsto votemap trigger when a TTT map change is about to happen.

local PLUGIN = exsto.CreatePlugin()

PLUGIN:SetInfo({
  Name = "TTT Map Vote",
  ID = "ttt-map-vote",
  Desc = "Triggers votemaps when TTT is about to change maps.",
  Owner = "Lucas 'Shank' Nicodemus",
  Disabled = false,
} )

-- This is heavily based on https://github.com/tyrantelf/gmod-mapvote/blob/master/lua/autorun/server/sv_autovote.lua
-- Using raw hooks to avoid Exsto so that we can override TTT stuff.
hook.Add( "Initialize", "AutoTTTMapVote", function()
  function CheckForMapSwitch()
     -- Check for mapswitch
     local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
     SetGlobalInt("ttt_rounds_left", rounds_left)
  
     local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
     local switchmap = false
     local nextmap = string.upper(game.GetMapNext())
  
      if rounds_left <= 0 then
        GameMsg("Round limit reached. Beginning vote for next map.")
        switchmap = true
      elseif time_left <= 0 then
        GameMsg("Time limit reached. Beginning vote for next map.")
        switchmap = true
      end

      if switchmap then
        timer.Stop("end2prep")
        local votemap = exsto.GetPlugin("votemap")
        votemap:Votemap()
      else
        GameMsg(rounds_left .. " rounds or " .. math.ceil(time_left/60) .. " minutes remain until next map vote.")
      end
  end
end )

function PLUGIN:Init() 
  self:Debug("Trouble in Terrorist Town gamemode hooks set.", 3)
end

PLUGIN:Register()
