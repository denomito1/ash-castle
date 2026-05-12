MODULE.ClientFiles = {
	"cl_init.lua"
}

---@class castle.player_classes
local classes = include( "shared.lua" )

--- [ SERVER ]
---
--- Set player class.
---
---@param pl Player
---@param name string
function classes.setPlayerClass( pl, name )
	pl:SetNW2String( "ash.castle.class", name )
end

concommand.Add( "castle_select_class", function( pl, _, args )
	local name = args[ 1 ]
	if not classes.getClassData( name ) then
		return
	end

	if classes.getPlayerClass( pl ) == name then
		return
	end

	classes.setPlayerClass( pl, name )

	pl:PrintMessage( HUD_PRINTCONSOLE, "you'r class: " .. classes.getPlayerClass( pl ) )
end )

return classes