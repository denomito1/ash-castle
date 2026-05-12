---@class castle.player_classes
local classes = {}

local classes_map = {}
local classes_list, classes_list_count = {}, 0

--- [SHARED]
---
--- Create player class.
---
---@param name string
---@param struct table
---@retunr table structure, integer id
function classes.add( name, struct )
	classes_list_count = classes_list_count + 1

	struct.name = name

	classes_list[ classes_list_count ] = struct
	classes_map[ name ] = struct

	return struct, classes_list_count
end

--- [SHARED]
---
--- Get classes list.
---
---@return table classes list
function classes.getList(  )
	return classes_list
end

--- [SHARED]
---
--- Get player class.
---
---@param name string class name
---@return table? class table
function classes.getClassData( name )
	return classes_map[ name ]
end

--- [SHARED]
---
--- Get player class.
---
---@param pl Player
function classes.getPlayerClass( pl )
	return pl:GetNW2String( "ash.castle.class", "" )
end


do
	local path = "data_static/ash_castle/classes/"
	local files = file.Find( path .. "*.json", "GAME" )

	for i = 1, #files do
		local name = files[ i ]
		classes.add( string.sub( name, 1, string.len( name ) - 5 ), util.JSONToTable( file.Read( path .. name, "GAME" ) or "[]" ) or {} )
	end
end

PrintTable( classes_list )

return classes

