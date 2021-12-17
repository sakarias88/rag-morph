AddCSLuaFile( "autorun/client/wobble3rdperson.lua" )
AddCSLuaFile( "autorun/wobblemanmenu.lua" )

resource.AddFile( "materials/ragMorphInvisivble.vmt" )
resource.AddFile( "materials/icons/ragMorphIco.vmt" )

local allMorphs = {}
local allMorphOwners = {}
local nrOfMorphs = 0

local checkTimer = CurTime()

function wobble_addMorph( ragdoll )

	nrOfMorphs = nrOfMorphs + 1
	allMorphs[nrOfMorphs] = ragdoll
	allMorphOwners[nrOfMorphs] = ragdoll.PlayerOwner
	
end

local function wobble_removeMorph( slot )

	allMorphs[slot] = allMorphs[nrOfMorphs]
	allMorphOwners[slot] = allMorphOwners[nrOfMorphs]
	nrOfMorphs = nrOfMorphs - 1
	
end

function wobble_removeMorphByEntIndex( index )

	for i = 1, nrOfMorphs do 

		if IsValid(allMorphs[i]) && allMorphs[i]:EntIndex( ) == index then
			wobble_removeMorph( i )
			return true
		end
	end
	
	return false
end

local function wobble_checkRagdollTable()

	for i = 1, nrOfMorphs do 

		if !IsValid(allMorphs[i]) then
			allMorphs[i] = allMorphs[nrOfMorphs]
			allMorphOwners[i] = allMorphOwners[nrOfMorphs]
			nrOfMorphs = nrOfMorphs - 1
		end
	end
end
















local boneTable = {"ValveBiped.Bip01_Pelvis",
"ValveBiped.Bip01_Spine2",
"ValveBiped.Bip01_Head1",
"ValveBiped.Bip01_L_Hand",
"ValveBiped.Bip01_L_Forearm",
"ValveBiped.Bip01_L_UpperArm",
"ValveBiped.Bip01_L_Foot",
"ValveBiped.Bip01_L_Calf",
"ValveBiped.Bip01_L_Thigh",
"ValveBiped.Bip01_R_Hand",
"ValveBiped.Bip01_R_Forearm",
"ValveBiped.Bip01_R_UpperArm",
"ValveBiped.Bip01_R_Foot",
"ValveBiped.Bip01_R_Calf",
"ValveBiped.Bip01_R_Thigh",
}

local function makeWepVisable( ply )

	if ply.MorphRagdollModeWep then
		local weps = ply:GetWeapons()
		local count = table.Count(weps)
		
		for i = 1, count do 
			if weps[i]:GetClass() != ply.MorphRagdollModeWep then
				ply:SelectWeapon(weps[i]:GetClass())
				ply:SelectWeapon(ply.MorphRagdollModeWep)
				return true
			end
		end
	end
	
	return false
end

local function GetBoneCheckId( boneName )
	for i = 1, 15 do 
		
		if boneName == boneTable[i] then
			return i
		end
	end

	return -1
end

local function FreezeWobbleManMENU( ply ) 

	if IsValid(ply.WobbleManTagDoll) && ply:Alive() then
	
		ply.WobbleManTagDoll:SetNotSolid( false )	
		ply:SetNetworkedBool("WobbleManThirdPerson",true)
		ply.WobbleManTagDoll:SetOwner(NULL)
		ply.WobbleManTagDoll.oldBoneVel = {}
		ply.WobbleManTagDoll.oldBoneAngVel = {}
		
		if ply.WobbleManMat then
			ply:SetMaterial(ply.WobbleManMat)
		end		

		
		local bones = ply.WobbleManTagDoll:GetPhysicsObjectCount()
		for i = 0 , bones-1 do

			local bone = ply.WobbleManTagDoll:GetPhysicsObjectNum( i ) 
		
			if IsValid( bone ) then 
				bone:Wake()
				
				local modelBoneID = ply.WobbleManTagDoll:TranslatePhysBoneToBone( i )
				local modelBoneName = ply.WobbleManTagDoll:GetBoneName( modelBoneID )
				local arrID = GetBoneCheckId( modelBoneName )
				
				if arrID != -1 && ply.WobbleManBones[arrID] != nil && ply.WobbleManBones[arrID] == "1.00" or ply.RagdollMorphMode == true then
					local bone = ply.WobbleManTagDoll:GetPhysicsObjectNum( i )
					ply.WobbleManTagDoll.oldBoneVel[i] = bone:GetVelocity()
					ply.WobbleManTagDoll.oldBoneAngVel[i] = bone:GetAngleVelocity()
					bone:EnableMotion( false )						
				end
			end
		end			 	
		
		if ply.WobbleManTagDoll.sleep == false && ply.RagdollMorphMode != true then
			local vec = ply:GetAimVector( )
			vec.z = vec.z * 0
			ply:SetPos( ply:GetPos() + vec * -50)
			
			ply.MorphRagdollModeWep = ply:GetActiveWeapon():GetClass()
			makeWepVisable( ply )
		end
	
		ply.WobbleManTagDoll.sleep = true
		ply.InitiatedRagCount = 0
	end
end
concommand.Add( "FreezeWobbleManMENU", FreezeWobbleManMENU )  


local function UnFreezeWobbleManMENU(ply) 

	if IsValid(ply.WobbleManTagDoll) && ply:Alive() && !ply:InVehicle() then
	
		ply.InitiatedRagCount = 0
		ply.WobbleManTagDoll.sleep = false
		ply:SetNetworkedBool("WobbleManThirdPerson",false)
		ply.WobbleManTagDoll:SetOwner(ply)			
		ply.WobbleManMat = ply:GetMaterial()	
		ply:SetMaterial( "ragMorphInvisivble" ) 

		if(ply.WobbleManPhysEffectRagdoll != "1.00") then
			ply.WobbleManTagDoll:SetNotSolid( true )
		else
			ply.WobbleManTagDoll:SetNotSolid( false )			
		end

		local bones = ply.WobbleManTagDoll:GetPhysicsObjectCount()
		
		for i=0,bones-1 do	
			local bone = ply.WobbleManTagDoll:GetPhysicsObjectNum( i )
			bone:EnableMotion( true )
			bone:Wake()

			if ply.WobbleManTagDoll.oldBoneVel && ply.WobbleManTagDoll.oldBoneVel[i] then
				bone:SetVelocity( ply.WobbleManTagDoll.oldBoneVel[i] )
				ply.WobbleManTagDoll.oldBoneVel[i] = Vector(0,0,0)
			end

			if ply.WobbleManTagDoll.oldBoneAngVel && ply.WobbleManTagDoll.oldBoneAngVel[i] then
				bone:AddAngleVelocity(ply.WobbleManTagDoll.oldBoneAngVel[i])
				ply.WobbleManTagDoll.oldBoneAngVel[i] = Vector(0,0,0)
			end
		end	
	end
	
end
concommand.Add( "UnFreezeWobbleManMENU", UnFreezeWobbleManMENU ) 



local function CreateWobbleManMENU(ply)

	if !ply:InVehicle() && !IsValid(ply.WobbleManTagDoll) && ply:Alive() && ply.RagdollMorphMode != true then

		local rag = ents.Create( "prop_ragdoll" ) 
		local model = ""
		
		if !ply.defaultMorphModel or ply.defaultMorphModel == NULL then
			model = ply:GetModel()
		else
			model = ply.defaultMorphModel
		end
		
		rag:SetModel( model ) 
		rag:SetPos(ply:GetPos())  
		rag:Spawn()
		rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		rag:SetOwner(ply)
		
		rag.PlayerOwner = ply		
		wobble_addMorph( rag )
		
		local bones = rag:GetPhysicsObjectCount()

		for i=0,bones-1 do

			local bone = rag:GetPhysicsObjectNum( i )  
			 
			if IsValid( bone ) then  
				local bonepos, boneang = ply:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )  
				bone:SetPos( bonepos )  
				bone:SetAngles( boneang )   
			end 
		end 	 
		
		
		ply.WobbleManTagDoll = rag
		ply.WobbleManTagDoll.sleep = false
		ply:DrawWorldModel( false )
		ply.WobbleManMat = ply:GetMaterial()
		ply:SetMaterial( "ragMorphInvisivble" )
		ply:SetNetworkedBool("HasWobbleMan",true)
		ply:SetNetworkedBool("WobbleManThirdPerson",false)
		ply:SetNetworkedEntity( "WobbleManEnt", rag )	
		
		if ply.WobbleManFPV == "1.00" then
			ply:SetNetworkedBool("WobbleManFPV",true)
		else
			ply:SetNetworkedBool("WobbleManFPV",false)		
		end
			
		if(ply.WobbleManPhysEffectRagdoll != "1.00") then
			rag:SetNotSolid( true )
		end
		
		if !ply.WobbleManBones then
			ply.WobbleManBones = {"1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00"}
		end
		
		if !ply.WobbleManHideWeapon then
			ply.WobbleManHideWeapon = "1.00"
		end
		
		if !ply.WobbleManHideViewWeapon then
			ply.WobbleManHideViewWeapon = "1.00"
		end
		
		if !ply.WobbleManRagdollEffectsPly then
			ply.WobbleManRagdollEffectsPly = "0.00"
		end

		if !ply.WobbleManPhysEffectRagdoll then
			ply.WobbleManPhysEffectRagdoll = "1.00"
		end

		if !ply.SnapHeadToViewAngle then
			ply.SnapHeadToViewAngle = "0.00"
		end
		
		if ply.WobbleManHideWeapon == "1.00" then
			ply:DrawWorldModel( false )
		else
			ply:DrawWorldModel( true )			
		end
		
		if ply.WobbleManHideViewWeapon == "1.00" then
			ply:DrawViewModel( false )
		else
			ply:DrawViewModel( true )				
		end			
		
	elseif IsValid(ply.WobbleManTagDoll) && ply:Alive() then
		UnFreezeWobbleManMENU(ply) 
	end

end
concommand.Add( "CreateWobbleManMENU", CreateWobbleManMENU )   

local function RagMorphRagdollModeOn(ply)
	
	if !ply:InVehicle() && (ply.RagdollMorphMode == nil or ply.RagdollMorphMode == false) && IsValid(ply.WobbleManTagDoll) && ply.WobbleManTagDoll.sleep != true then
		ply.RagdollMorphMode = true
		
		ply:SetNetworkedBool("WobbleManRagDollMode",true)
		
		ply.MorphRagdollModeWep = ply:GetActiveWeapon():GetClass()
		ply.OldHealth = ply:Health()
		
		ply:Spectate( OBS_MODE_CHASE )
		ply:SpectateEntity( ply.WobbleManTagDoll )
		
		
		local bones = ply.WobbleManTagDoll:GetPhysicsObjectCount()
		local vel = ply:GetVelocity()
		
		ply.WobbleManTagDoll:SetNotSolid( false )	
		
		for i = 0 , bones-1 do
			local bone = ply.WobbleManTagDoll:GetPhysicsObjectNum( i ) 
			
			if IsValid(bone) then
				bone:SetVelocity( vel ) 
			end
		end			
	end
	
	ply.InitiatedRagCount = ply.InitiatedRagCount or 0
	--Prevent stack overflow
	if !IsValid(ply.WobbleManTagDoll) and ply.InitiatedRagCount <= 2 then
		ply.InitiatedRagCount = ply.InitiatedRagCount + 1
		CreateWobbleManMENU(ply)
		RagMorphRagdollModeOn(ply)
	elseif ply.InitiatedRagCount > 2 then
		ply.InitiatedRagCount = 0
	end
end
concommand.Add( "RagMorphRagdollModeOn", RagMorphRagdollModeOn )  

local function RagMorphRagdollModeOff(ply)

	if IsValid(ply.WobbleManTagDoll) && ply.RagdollMorphMode == true then
		ply.InitiatedRagCount = 0
		if ply.WobbleManTagDoll.sleep == true then
			UnFreezeWobbleManMENU(ply)
		end
	
		local viewAng = ply:EyeAngles()
		ply.RagdollMorphMode = false
		ply:SetNetworkedBool("WobbleManRagDollMode",false)
		ply:UnSpectate()
		ply:Spawn()
		ply:SetEyeAngles( viewAng )
		ply:SelectWeapon(ply.MorphRagdollModeWep)	
		
		if ply.OldHealth then
			ply:SetHealth( ply.OldHealth )
		end
		
		if IsValid(ply.WobbleManTagDoll) then
			ply:SetPos( ply.WobbleManTagDoll:GetPos() )
			ply:SetVelocity( ply.WobbleManTagDoll:GetVelocity() )	
		end
		
		
		if(ply.WobbleManPhysEffectRagdoll != "1.00") then
			ply.WobbleManTagDoll:SetNotSolid( true )
		else
			ply.WobbleManTagDoll:SetNotSolid( false )			
		end	

		local wepon = ply:GetActiveWeapon()
		if IsValid( wepon ) then --It's a wepon!!
			wepon:SetNextPrimaryFire( CurTime() )
			wepon:SetNextSecondaryFire( CurTime() )	
		end		
	end
end
concommand.Add( "RagMorphRagdollModeOff", RagMorphRagdollModeOff )  

function RemoveWobbleManMENU(ply)

	if ply.RagdollMorphMode == true then
		RagMorphRagdollModeOff(ply)
	end

	if IsValid(ply.WobbleManTagDoll) then
	
		if ply.WobbleManTagDoll.sleep == true then
			UnFreezeWobbleManMENU(ply) 
		end	
	
		wobble_removeMorphByEntIndex( ply.WobbleManTagDoll:EntIndex() )
		
		ply.WobbleManTagDoll:Remove()
		ply.WobbleManTagDoll = NULL
	end
	
	if ply.WobbleManMat then
		ply:SetMaterial(ply.WobbleManMat)
	end	

	ply:SetNetworkedBool("HasWobbleMan",false)
	ply:DrawWorldModel( true )
	ply:DrawViewModel( true )
	ply.InitiatedRagCount = 0
	
	if ply:Alive() then
		ply.MorphRagdollModeWep = ply:GetActiveWeapon():GetClass()
		makeWepVisable( ply )
	end
end
concommand.Add( "RemoveWobbleManMENU", RemoveWobbleManMENU ) 

local function ToggelRagMorphMode(ply)
	ply.InitiatedRagCount = 0
	if ply.RagdollMorphMode == true then
		RagMorphRagdollModeOff(ply)
	else
		RagMorphRagdollModeOn(ply)
	end

end
concommand.Add( "WobbleToggleRagdoll", ToggelRagMorphMode ) 

--Pasting the ragdoll on the player
local function MoveWobbleRagdollBones()
	
	
	for i=1,nrOfMorphs do

		if IsValid(allMorphs[i]) && IsValid(allMorphs[i].PlayerOwner) && allMorphs[i].PlayerOwner:Alive() && allMorphs[i].PlayerOwner.SnapHeadToViewAngle == "1.00" && !allMorphs[i].sleep then
			local ang = allMorphs[i].PlayerOwner:EyeAngles()
			ang.r = ang.r + 90
			ang.p = ang.p - 90			
			
			local bone = allMorphs[i]:GetPhysicsObjectNum( allMorphs[i]:TranslateBoneToPhysBone( allMorphs[i]:LookupBone( "ValveBiped.Bip01_Head1" ) ) )
			local vel = bone:GetVelocity()
			bone:SetAngles( ang )
			bone:SetVelocity( vel )
		end
	
		if not(IsValid(allMorphs[i])) && IsValid(allMorphOwners[i]) && allMorphOwners[i]:GetMaterial() == "ragMorphInvisivble" then
			local ply = allMorphOwners[i]
			RemoveWobbleManMENU(ply)
			wobble_checkRagdollTable()
		end
		
		if IsValid(allMorphs[i]) && !IsValid(allMorphs[i].PlayerOwner) then
			allMorphs[i]:Remove()
			wobble_checkRagdollTable()
		end
	
		if allMorphs[i] != NULL && IsValid(allMorphs[i]) && IsValid( allMorphs[i].PlayerOwner ) then
			local v = allMorphs[i].PlayerOwner
	
			allMorphs[i]:GetPhysicsObject():Wake()
	
			if v.RagdollMorphMode == true then
				local wepon = v:GetActiveWeapon()
				if IsValid( wepon ) then
					wepon:SetNextPrimaryFire( CurTime() + 10 )
					wepon:SetNextSecondaryFire( CurTime() + 10 )	
				end
			end
	
			if v:Alive() && IsValid(v.WobbleManTagDoll) then
			
				v.dieOnce = false
			
				if !v.WobbleManTagDoll.sleep && v.RagdollMorphMode != true then
			
					local ragVel = Vector(0,0,0)
				
					if v.WobbleManHideWeapon == "1.00" then
						v:DrawWorldModel( false )
					else
						v:DrawWorldModel( true )			
					end

					if v.WobbleManHideViewWeapon == "1.00" then
						v:DrawViewModel( false )
					else
						v:DrawViewModel( true )				
					end
					
					if v.WobbleManPhysEffectRagdoll != "1.00" then
						v.WobbleManTagDoll:SetNotSolid( true )
					else
						v.WobbleManTagDoll:SetNotSolid( false )			
					end
					 
					--Setting bone pos
					local bones = v.WobbleManTagDoll:GetPhysicsObjectCount()
					for i = 0 , bones-1 do

						local bone = v.WobbleManTagDoll:GetPhysicsObjectNum( i ) 
					
						if IsValid( bone ) then 
							bone:Wake()
							
							ragVel = ragVel + bone:GetVelocity()
							
							local modelBoneID = v.WobbleManTagDoll:TranslatePhysBoneToBone( i )
							local modelBoneName = v.WobbleManTagDoll:GetBoneName( modelBoneID )
							local arrID = GetBoneCheckId( modelBoneName )
							
							if arrID != -1 && v.WobbleManBones[arrID] != nil && v.WobbleManBones[arrID] == "1.00" then
							
								local bonepos, boneang = v:GetBonePosition( v:LookupBone( modelBoneName ) ) 
								bone:SetVelocity( v:GetVelocity() )
								bone:SetPos( bonepos )  
								bone:SetAngles( boneang )
							end
							
						end
					end			 

					 

					if v.WobbleManRagdollEffectsPly == "1.00" then
						ragVel = (ragVel / bones) * 0.05
						v:SetVelocity(ragVel)
					end
				end
				
				--Apply forces on bones
				if v.WobbleManTagDoll.BoneMover then
					local bones = v.WobbleManTagDoll:GetPhysicsObjectCount()
					for i = 0 , bones-1 do
						
						local bone = v.WobbleManTagDoll:GetPhysicsObjectNum( i ) 
			
						
						if IsValid( bone ) && v.WobbleManTagDoll.BoneMover[i+1] && v.WobbleManTagDoll.BoneMover[i+1][3] != 0 && v.WobbleManTagDoll.BoneMover[i+1][3] != null then 

							local conDir = v.WobbleManTagDoll.BoneMover[i+1][2]
							local dir = Vector(0,0,0)
							
							if conDir == 1 then
								dir = v:GetForward()
							elseif conDir == -1 then
								dir = v:GetForward() * -1
							elseif conDir == 2 then
								dir = v:GetRight()
							elseif conDir == -2 then
								dir = v:GetRight() * -1
							elseif conDir == 3 then
								dir = v:GetUp() 
							elseif dir == -3 then
								dir = v:GetUp() * -1
							elseif conDir == 4 then
								dir = v:EyeAngles( ):Forward()
							end

							bone:ApplyForceCenter(v.WobbleManTagDoll.BoneMover[i+1][1] * dir * v.WobbleManTagDoll.BoneMover[i+1][3])
						end
					
					end
				end
			
			elseif(!v:Alive() && v.dieOnce == false) then
							
				if v.WobbleManMat then
					v:SetMaterial(v.WobbleManMat)
				end			
				
				if v.UseRagMorphAsDeathRagdoll != nil && v.UseRagMorphAsDeathRagdoll == "0.00" then
					v.WobbleManTagDoll:Remove()
					v.WobbleManTagDoll = NULL	
					v:SetNetworkedBool("HasWobbleMan",false)
					v.dieOnce = true
				else
					
					v.WobbleManTagDoll:SetNotSolid( false )	
					v:SetNetworkedBool("WobbleManThirdPerson",true)
					v.WobbleManTagDoll:SetOwner(NULL)
					v.WobbleManTagDoll.sleep = true
					v.RagdollMorphMode = false

					
					--Removing death ragdoll
					local deathRag = v:GetRagdollEntity()
					if IsValid(deathRag) then
						
						if IsValid( v.WobbleManTagDoll ) then
							v:Spectate( OBS_MODE_CHASE )
							v:SpectateEntity( v.WobbleManTagDoll )
						end
						
						deathRag:Remove()
						v.dieOnce = true
					end
					
				end		

			end
		else
			wobble_removeMorph( i )
		end
	end
end
hook.Add("Think","MoveWobbleRagdollBones", MoveWobbleRagdollBones)


--Removing the wobble ragdoll if we enter a vehicle
--Can't make the player use the wobble ragdoll while they are in a vehicle
--Sure it works if i nocollide it but the animations don't work like they normally do so it just looks very odd.

local function denyVehicleUsage( ply, veh, role ) 

	if ply.RagdollMorphMode == true then return false end

	if IsValid( ply.WobbleManTagDoll ) && ply.WobbleManTagDoll.sleep != true then
		FreezeWobbleManMENU(ply)
		ply:PrintMessage( HUD_PRINTTALK, "You can't use rag morph inside vehicles. Use un-freeze to use the rag morph again.")
	end
	
end
hook.Add("CanPlayerEnterVehicle","RagMorphDenyVehicleUsage", denyVehicleUsage)
-----------------------------------------------OLD CONSOLE COMMANDS
--Keeping them just in case someone likes console commands

--Freezing it
function FreezeWobbleMan( ply, com, arg ) 
	ply.InitiatedRagCount = 0
	if IsValid(ply.WobbleManTagDoll) then		
		if ply.WobbleManTagDoll.sleep == true then
			UnFreezeWobbleManMENU(ply)
		else
			FreezeWobbleManMENU(ply)
		end
	end
	
end
concommand.Add( "WobbleFreeze", FreezeWobbleMan )  


--Creating it
function SpawnWobbleMan( ply, com, arg ) 
	ply.InitiatedRagCount = 0
	if IsValid(ply.WobbleManTagDoll) then
		RemoveWobbleManMENU(ply)
	else
		CreateWobbleManMENU(ply)
	end

end
concommand.Add( "WobbleCreate", SpawnWobbleMan )  


--Simulating death with a ragMorph
function ApplyMorphRagdollSpeed( ply, inf, kill ) 

	if IsValid(ply.WobbleManTagDoll) then
	
		local bones = ply.WobbleManTagDoll:GetPhysicsObjectCount()
		local vel = ply:GetVelocity()
		
		for i = 0 , bones-1 do
			local bone = ply.WobbleManTagDoll:GetPhysicsObjectNum( i ) 
			
			if IsValid(bone) then
				
				bone:SetVelocity( vel ) 
			end
		end		
	end

end
hook.Add("PlayerDeath", "ApplyMorphRagdollSpeed", ApplyMorphRagdollSpeed)


--Numpad
function wobble_ApplyPhysForceToRagdollBone( ply, ent, bone, mul )
	if not ent:IsValid() or !ent.BoneMover or !ent.BoneMover[bone+1] then return false end
	
	local toggle = ent.BoneMover[bone+1][4]
	
	if toggle && toggle == 1 then
		if mul != 0 then
		
			if !ent.BoneMover[bone+1][3] or ent.BoneMover[bone+1][3] == 0 then
				ent.BoneMover[bone+1][3] = mul
			else
				ent.BoneMover[bone+1][3] = 0
			end
		
		end
	else
		ent.BoneMover[bone+1][3] = mul
	end
end
 
-- Register the function with the numpad library.
numpad.Register( "wobble_ApplyPhysForceToRagdollBone", wobble_ApplyPhysForceToRagdollBone )
