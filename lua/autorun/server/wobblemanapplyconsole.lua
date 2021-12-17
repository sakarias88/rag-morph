concommand.Add( "wobble_ChangeBoneRigging", function( ply, com, args )
	ply.WobbleManBones = args
end)

concommand.Add( "wobble_ChangeRagMorphOptions", function( ply, com, args )
	ply.WobbleManHideWeapon = args[1]
	ply.WobbleManHideViewWeapon = args[2]
	ply.WobbleManRagdollEffectsPly = args[3]
	ply.WobbleManFPV = args[4]
	ply.WobbleManPhysEffectRagdoll = args[5]
	ply.UseRagMorphAsDeathRagdoll = args[6]
	ply.SnapHeadToViewAngle = args[7]

	if ply.WobbleManFPV == "0.00" then
		ply:SetNetworkedBool("WobbleManFPV",false)
	else
		ply:SetNetworkedBool("WobbleManFPV",true)
	end
end)
