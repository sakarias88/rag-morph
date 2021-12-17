TOOL.Category		= "Stools"
TOOL.Name			= "#Set RagMorph"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab        = "RagMorph"


TOOL.boneTable = {"ValveBiped.Bip01_Pelvis",
"ValveBiped.Bip01_Spine2",
"ValveBiped.Bip01_R_UpperArm",
"ValveBiped.Bip01_L_UpperArm",
"ValveBiped.Bip01_L_Forearm",
"ValveBiped.Bip01_L_Hand",
"ValveBiped.Bip01_R_Forearm",
"ValveBiped.Bip01_R_Hand",
"ValveBiped.Bip01_R_Thigh",
"ValveBiped.Bip01_R_Calf",
"ValveBiped.Bip01_Head1",
"ValveBiped.Bip01_L_Thigh",
"ValveBiped.Bip01_L_Calf",
"ValveBiped.Bip01_L_Foot",
"ValveBiped.Bip01_R_Foot",
}

function TOOL:IsValidRagdoll( rag, nrOfBones )
	
	local valid = -1

	for i = 0, nrOfBones-1 do
	
		local boneName = rag:GetBoneName( i )
		
		if table.HasValue( self.boneTable , boneName ) then
			return true
		end
	end

	return false
end

if CLIENT then

	
	language.Add( "Tool.setragmorph.name", "Set Morph" )
	language.Add( "Tool.setragmorph.desc", "Choose a ragdoll you want to use" )
	language.Add( "Tool.setragmorph.0", "Primary fire: Select \n Secondary fire: Select default rag morph model \nReload: Override" )
	
	
end

function TOOL:CheckValidRagdoll( ent, boneNum )
	if not string.find( ent:GetClass( ), "prop_ragdoll" ) then
		self:GetOwner():PrintMessage( HUD_PRINTTALK, "Not a ragdoll")
		return false
	elseif not self:IsValidRagdoll( ent, boneNum ) then
		self:GetOwner():PrintMessage( HUD_PRINTTALK, "Not valid! The ragdoll does not have the required bone structure!")
		return false
	end
	
	return true
end

function TOOL:LeftClick( trace )

	if ( trace.Entity and trace.Entity:IsPlayer() ) or not trace.Entity:IsValid() then return false end
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	local boneNum = trace.Entity:GetPhysicsObjectCount()
	
	if not self:CheckValidRagdoll( trace.Entity, boneNum ) then return false end

	
	ply.defaultMorphModel = trace.Entity:GetModel()
	return true
end

function TOOL:RightClick( trace )
	if ( trace.Entity and trace.Entity:IsPlayer() ) or not trace.Entity:IsValid() then return false end
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	local boneNum = trace.Entity:GetPhysicsObjectCount()
	
	if IsValid( ply.WobbleManTagDoll ) and trace.Entity:EntIndex() == ply.WobbleManTagDoll:EntIndex() then return false end
	if not self:CheckValidRagdoll( trace.Entity, boneNum ) then return false end

	if IsValid( ply.WobbleManTagDoll ) then
		RemoveWobbleManMENU(ply)
	end

	
	local rag = trace.Entity
	rag.PlayerOwner = ply
	ply.WobbleManTagDoll = rag
	ply.WobbleManTagDoll.sleep = true	
	ply:SetNetworkedBool("HasWobbleMan",true)
	ply:SetNetworkedEntity( "WobbleManEnt", rag )
	ply:SetNetworkedBool("WobbleManThirdPerson",true)		
	wobble_addMorph( rag )

	if ply.WobbleManFPV == "1.00" then
		ply:SetNetworkedBool("WobbleManFPV",true)
	else
		ply:SetNetworkedBool("WobbleManFPV",false)		
	end
	
	if not ply.WobbleManBones then
		ply.WobbleManBones = {"1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00"}
	end
	
	if not ply.WobbleManHideWeapon then
		ply.WobbleManHideWeapon = "1.00"
	end
	
	if not ply.WobbleManHideViewWeapon then
		ply.WobbleManHideViewWeapon = "1.00"
	end
	
	if not ply.WobbleManRagdollEffectsPly then
		ply.WobbleManRagdollEffectsPly = "0.00"
	end

	if not ply.WobbleManPhysEffectRagdoll then
		ply.WobbleManPhysEffectRagdoll = "1.00"
	end			
		
	
	return true	
end

function TOOL:Reload(trace)
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	ply.defaultMorphModel = NULL
	ply:PrintMessage( HUD_PRINTTALK, "Using player model!")
	
	return true
end

function TOOL.BuildCPanel( CPanel )
CPanel:AddControl( "Label", { Text = "This stool works on most ragdolls", Description = "" } )	
CPanel:AddControl( "Label", { Text = "PRIMARY: Select rag morph model", Description = "" } )	
CPanel:AddControl( "Label", { Text = "SECONDARY: Select a specific ragdoll (use the un-freeze command)", Description = "" } )
CPanel:AddControl( "Label", { Text = "RELOAD: Set the player model as default rag morph model", Description = "" } )
end

