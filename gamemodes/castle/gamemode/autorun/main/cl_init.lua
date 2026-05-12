include( "shared.lua" )

---@type ash.player
local ash_player = import( "ash.player" )

---@type ash.round
local round = import( "ash.round" )

do
	local format_time = _G.string.ToMinutesSeconds
	hook.Add( "HUDPaint", "Defaults", function()
		draw.SimpleText( format_time( round.getTimeLeft() ), "DermaLarge", ScrW() * 0.5, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		draw.SimpleText( round.getRoundType():upper(), "DermaDefaultBold", ScrW() * 0.5, 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	end )
end

hook.Add("PostDrawViewModel", "Defaults", function( ViewModel, ply, Weapon )
    if ( not IsValid( Weapon ) ) then return end

    if ( Weapon.UseHands or not Weapon:IsScripted() ) then

        local hands = ply:GetHands()
        if ( IsValid( hands ) and IsValid( hands:GetParent() ) ) then

            if ( not hook.Call( "PreDrawPlayerHands", hands, ViewModel, ply, Weapon ) ) then

                if ( Weapon.ViewModelFlip ) then render.CullMode( MATERIAL_CULLMODE_CW ) end
                hands:DrawModel()
                render.CullMode( MATERIAL_CULLMODE_CCW )

            end

            hook.Run( "PostDrawPlayerHands", hands, ViewModel, ply, Weapon )

        end

    end

    player_manager.RunClass( ply, "PostDrawViewModel", ViewModel, Weapon )

    if ( Weapon.PostDrawViewModel == nil ) then return end
    return Weapon:PostDrawViewModel( ViewModel, Weapon, ply )
end)
