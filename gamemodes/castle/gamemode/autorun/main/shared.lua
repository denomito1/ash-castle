---@type ash.round
local round = import( "ash.round" )

---@type ash.player
local ash_player = import( "ash.player" )

---@type ash.player.team
local ash_team = import( "ash.player.team" )

---@type ash.spectator
local ash_spectator = import( "ash.spectator" )

---@type ash.entity
local ash_entity = import( "ash.entity" )


import( "ash.player.footsteps.dynamic" )

ash_team.register({
    name = "spec",
    color = Color( 43, 150, 251 ),
    score = 0,
    mates = { },
})

ash_team.register({
    name = "red",
    color = Color( 237, 87, 61 ),
    score = 0,
    mates = { },
    models = {
        Model"models/player/arctic.mdl",
        Model"models/player/guerilla.mdl",
        Model"models/player/leet.mdl",
        Model"models/player/phoenix.mdl",
    },
})

ash_team.register({
    name = "blue",
    color = Color( 43, 150, 251 ),
    score = 0,
    mates = { },
    models = {
        Model"models/player/gasmask.mdl",
        Model"models/player/riot.mdl",
        Model"models/player/swat.mdl",
        Model"models/player/urban.mdl",
    },
})

---@type castle.player_classes
local castle_classes = import( "player_classes" )


do
	local ash_player_iterator = ash_player.iterator
	local Player_Give = Player.Give
	local Player_Alive = Player.Alive

	round.createRoundStack(
		{
			{
				name = "prepare",
				time = 10,
				finish = function( data )
					print( "round end", data.name )
				end,
				start = function( )
					for _, pl in ash_player_iterator() do
						if not Player_Alive( pl ) then
							pl:Spawn()
							pl:SetModel( "models/player/gasmask.mdl" )
							pl:SetupHands()

							local class_data = castle_classes.getClassData( castle_classes.getPlayerClass( pl ) )

							if class_data then
								local weapons = class_data.weapons
								for i = 1, #weapons do
									Player_Give( pl, weapons[ i ] )
								end
							end
						end

					end

					game.CleanUpMap()
				end
			},

			{
				name = "started",
				time = 60 * 2,
				finish = function( )
				end,
				start = function( )

					for _, pl in ash_player_iterator() do
						if not Player_Alive( pl ) then
							pl:Spawn()
							pl:SetModel( "models/player/gasmask.mdl" )
							pl:SetupHands()

							local class_data = castle_classes.getClassData( castle_classes.getPlayerClass( pl ) )

							if class_data then
								local weapons = class_data.weapons
								for i = 1, #weapons do
									Player_Give( pl, weapons[ i ] )
								end
							end
						end
					end

				end,
			},

			{
				name = "post_round",
				time = 10,
				finish = function( data )
					print( "round end", data.name )
				end,
				start = function( data )
					print( "round start", data.name )
				end
			},
		}
	)
end

hook.Add( "frontfire.mode.base.CanPlayerSpawn", "Defaults", function( pl )
	if ash_team.getTeam( pl ) == "spec" then
		return false
	end

	return true
end )

do
	local Player_KillSilent = Player.KillSilent
    local Player_Alive = Player.Alive
    local OBS_MODE_FIXED = _G.OBS_MODE_FIXED


	hook.Add( "ash.player.Initialized", "Defaults", function( pl )
		ash_team.setTeam( pl, "spec" )

	    if Player_Alive( pl ) then
	        Player_KillSilent( pl )
	    end

	    local cams_list, cams_count = ash_entity.getByClass( "ash_camera", false )
	    local spawns, spawns_count = ash_entity.getByClass( "frontfire_spawn", false )

	    if cams_count > 0 then
	        ash_spectator.specate( pl, cams_list[ 1 ], OBS_MODE_FIXED )
	    elseif spawns_count > 0 then
	        ash_spectator.specate( pl, spawns[ 1 ], OBS_MODE_FIXED )
	    else
	        ash_spectator.specate( pl, game.GetWorld(), OBS_MODE_FIXED )
	    end
	end )
end

