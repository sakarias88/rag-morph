hook.Add("CalcView", "WobbleMan CalcView", function(ply, position, angles, fov)
	if not ply:Alive() or GetViewEntity() ~= ply then return end
	local useSpecialView = ply:GetNetworkedBool("HasWobbleMan")

	if useSpecialView then
		local RagdollIsSleeping =  ply:GetNetworkedBool("WobbleManThirdPerson")
		local InRagdollMode =  ply:GetNetworkedBool("WobbleManRagDollMode") 
		local rag = ply:GetNetworkedEntity( "WobbleManEnt" )

		if not RagdollIsSleeping or InRagdollMode == true then
			local fpv = ply:GetNetworkedBool("WobbleManFPV")	

			if fpv and IsValid(rag) then
				if rag:LookupAttachment( "eyes" ) ~= 0 then
					local myEyes = rag:GetAttachment( rag:LookupAttachment( "eyes" ) )
					return GAMEMODE:CalcView(ply, myEyes.Pos , angles, fov) 
				else
					local BoneIndx = rag:LookupBone("ValveBiped.Bip01_Head1")
					local BonePos , BoneAng = rag:GetBonePosition( BoneIndx )
					return GAMEMODE:CalcView(ply, BonePos, angles, fov) 				
				end
			else
				local aimVec = ply:GetAimVector()
				local oldPos = position
				local pos = Vector(0,0,0)

				if InRagdollMode == true then
					pos = oldPos + (aimVec * -100)
				else
					pos = oldPos + (aimVec * -200)
				end

				local Trace = {}
				Trace.start = oldPos
				Trace.endpos = pos
				Trace.mask = MASK_NPCWORLDSTATIC
				local tr = util.TraceLine(Trace)
				if tr.Hit then	
					pos = tr.HitPos
				end

				position = pos + aimVec * 20
				return GAMEMODE:CalcView(ply, position, angles, fov)
			end

			if ( not IsValid(rag) ) then
				ply:SetNetworkedBool("HasWobbleMan" , false)
			end
		end
	end
end)