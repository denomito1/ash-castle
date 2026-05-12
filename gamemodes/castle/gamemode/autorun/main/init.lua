MODULE.ClientFiles = {
	"cl_init.lua",
}

---@type ash.round
local round = import( "ash.round" )

---@type ash.player.team
local ash_team = import( "ash.player.team" )

---@type ash.spectator
local ash_spectator = import( "ash.spectator" )

---@type ash.player
local ash_player = import( "ash.player" )

do

	local allowed_teams = {
		[ "blue" ] = true,
		[ "red" ] = true,
		[ "spec" ] = true,
	}

	concommand.Add( "castle_team", function ( pl, _, args )
		local team_name = args[ 1 ]

		if not allowed_teams[ team_name ] then
			return
		end

		if ash_team.getTeam( pl ) == team_name then
			return
		end

		if pl:Alive() then
			pl:KillSilent()
		end

		ash_team.setTeam( pl, team_name )

		ash_spectator.unSpecate( pl )
	end )


end

hook.Add( "ash.PlayerTeamChanged", "Defaults", function( pl, new_team, old_team )
	---@cast pl Player

	if round.getRoundType() == "" and old_team == "spec" and ash_player.getCount( ) >= 1 then
		round.start( "prepare", 30 )
	end
end )

hook.Add( "PlayerCanPickupWeapon", "Defaults", function() return true end )

include( "shared.lua" )