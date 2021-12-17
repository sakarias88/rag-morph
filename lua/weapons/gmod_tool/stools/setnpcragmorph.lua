
TOOL.Category		= "Stools"
TOOL.Name			= "#Set NPC RagMorph"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab        = "RagMorph"

local SliderNames = {"Pelvis","Chest", "Right upper arm", "Left upper arm", "Left forearm", "Left hand", "Right forearm", "Right hand", "Right thigh", " Right calf", "Head",
"Left thigh", "Left calf", "Left foot", "Right foot", "Hide World Weapon", "Hide View Weapon", "Ragdoll physics effects player", "First Person View" }

TOOL.ClientConVar = {
	Pelvis    = "1",
	Chest   = "1",
	RightUpperArm = "1",
	LeftUpperArm = "1",
	LeftForearm = "1",
	LeftHand = "1",
	RightForearm = "1",
	RightHand = "1",
	RightThigh = "1",
	RightCalf = "1",
	Head = "1",
	LeftThigh = "1",
	LeftCalf = "1",
	LeftFoot = "1",
	RightFoot = "1",
}


if CLIENT then
	language.Add( "Tool_setnpcragmorph_Pelvis", "Pelvis" )
	language.Add( "Tool_setnpcragmorph_Chest", "Chest" )
	language.Add( "Tool_setnpcragmorph_RightUpperArm", "RightUpperArm" )
	language.Add( "Tool_setnpcragmorph_LeftUpperArm", "LeftUpperArm" )
	language.Add( "Tool_setnpcragmorph_LeftForearm", "LeftForearm" )
	language.Add( "Tool_setnpcragmorph_LeftHand", "LeftHand" )
	language.Add( "Tool_setnpcragmorph_RightForearm", "RightForearm" )
	language.Add( "Tool_setnpcragmorph_RightHand", "RightHand" )
	language.Add( "Tool_setnpcragmorph_RightThigh", "RightThigh" )
	language.Add( "Tool_setnpcragmorph_RightCalf", "RightCalf" )
	language.Add( "Tool_setnpcragmorph_Head", "Head" )
	language.Add( "Tool_setnpcragmorph_LeftThigh", "LeftThigh" )
	language.Add( "Tool_setnpcragmorph_LeftCalf", "LeftCalf" )
	language.Add( "Tool_setnpcragmorph_LeftFoot", "LeftFoot" )
	language.Add( "Tool_setnpcragmorph_RightFoot", "RightFoot" )


	
	language.Add( "Tool.setnpcragmorph.name", "Set NPC RagMorph" )
	language.Add( "Tool.setnpcragmorph.desc", "Choose a ragdoll you want to use" )
	language.Add( "Tool.setnpcragmorph.0", "Primary fire: Select \n Secondary fire: Select default rag morph model \nReload: Override" )
	
end

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if !string.find( trace.Entity:GetClass( ), "npc_*" ) then return false end
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	local boneNum = trace.Entity:GetPhysicsObjectCount()
	

	
	if trace.Entity:IsValid()  then
		local ent = trace.Entity
	
	
		local tableSettigns = {}
		
		tableSettigns[1] = (tostring(self:GetClientNumber( "Pelvis" ))..".00")
		tableSettigns[2] = (tostring(self:GetClientNumber( "Chest" ))..".00")
		tableSettigns[3] = (tostring(self:GetClientNumber( "RightUpperArm" ))..".00")
		tableSettigns[4] = (tostring(self:GetClientNumber( "LeftUpperArm" ))..".00")
		tableSettigns[5] = (tostring(self:GetClientNumber( "LeftForearm" ))..".00")
		tableSettigns[6] = (tostring(self:GetClientNumber( "LeftHand" ))..".00")
		tableSettigns[7] = (tostring(self:GetClientNumber( "RightForearm" ))..".00")
		tableSettigns[8] = (tostring(self:GetClientNumber( "RightHand" ))..".00")
		tableSettigns[9] = (tostring(self:GetClientNumber( "RightThigh" ))..".00")
		tableSettigns[10] = (tostring(self:GetClientNumber( "RightCalf" ))..".00")
		tableSettigns[11] = (tostring(self:GetClientNumber( "Head" ))..".00")
		tableSettigns[12] = (tostring(self:GetClientNumber( "LeftThigh" ))..".00")
		tableSettigns[13] = (tostring(self:GetClientNumber( "LeftCalf" ))..".00")
		tableSettigns[14] = (tostring(self:GetClientNumber( "LeftFoot" ))..".00")
		tableSettigns[15] = (tostring(self:GetClientNumber( "RightFoot" ))..".00")	
		
		ent.WobbleManBones = tableSettigns	
	
		//If it doesn't have a ragdoll we will create one for it.
		if !ent.WobbleManTagDoll or ent.WobbleManTagDoll == NULL  then
			
			local rag = ents.Create( "prop_ragdoll" ) 
			local model = ent:GetModel()
			
			
			rag:SetModel( model ) 
			rag:SetPos(ent:GetPos())  
			rag:Spawn()  
			rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS   )
			rag:SetOwner(ent)
			
			 local bones = rag:GetPhysicsObjectCount()

			 for i=0,bones-1 do

				 local bone = rag:GetPhysicsObjectNum( i )  
				 
				 if IsValid( bone ) then  
					local bonepos, boneang = ent:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )  
					bone:SetPos( bonepos )  
					bone:SetAngles( boneang )   					
				 end  
				 
				local matr = ent:GetBoneMatrix(i)
				matr:Scale(Vector(0, 0, 0))
				ent:SetBoneMatrix(i, matr)	
				ent:SetColor({r=0, g=0, b=0, a=0})
			 end 	 
			ent.WobbleManTagDoll = rag
			ent.WobbleManTagDoll.sleep = false
			ent:SetMaterial( "models/effects/vol_light001" ) 


			if ent:GetMaterial() != "models/effects/vol_light001" then
				ent.WobbleManMat = ent:GetMaterial()
			end
			
			if !ent.WobbleManBones then
				ent.WobbleManBones = {"1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00"}
			end
			
			if !ent.WobbleManHideWeapon then
				ent.WobbleManHideWeapon = "0.00"
			end
			
			if !ent.WobbleManHideViewWeapon then
				ent.WobbleManHideViewWeapon = "0.00"
			end
			
			if !ent.WobbleManRagdollEffectsPly then
				ent.WobbleManRagdollEffectsPly = "0.00"
			end			
		end	
		
		return true

	end
	return true

end

function TOOL:RightClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if !string.find( trace.Entity:GetClass( ), "npc_*" ) then return false end
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	local boneNum = trace.Entity:GetPhysicsObjectCount()
	

	
	if trace.Entity:IsValid()  then
		local ent = trace.Entity

		if ent.WobbleManTagDoll && ent.WobbleManTagDoll != NULL  then
			ent.WobbleManTagDoll:Remove()
			ent.WobbleManTagDoll = NULL
			ent:SetMaterial(ply.WobbleManMat)
			ent:SetColor(Color(255,255,255,255))
		end
		
	end
	
	
	return true
end

function TOOL:Reload(trace)



end

function TOOL.BuildCPanel( CPanel )

--[[
Pelvis Chest Head
LeftHand LeftForearm LeftUpperArm
LeftFoot LeftCalf LeftThigh
RightHand RightForearm RightUpperArm
RightFoot RightCalf RightThigh
--]]

	CPanel:AddControl( "Label", { Text = "Middle", Description = "" } )
	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_Pelvis",
									 Description = "#Tool_setnpcragmorph_Pelvis",
									 Command = "setnpcragmorph_Pelvis" })
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_Chest",
									 Description = "#Tool_setnpcragmorph_Chest",
									 Command = "setnpcragmorph_Chest" }) 

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_Head",
									 Description = "#Tool_setnpcragmorph_Head",
									 Command = "setnpcragmorph_Head" } )

									 
	CPanel:AddControl( "Label", { Text = "Left", Description = "" } )									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_LeftHand",
									 Description = "#Tool_setnpcragmorph_LeftHand",
									 Command = "setnpcragmorph_LeftHand" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_LeftForearm",
									 Description = "#Tool_setnpcragmorph_LeftForearm",
									 Command = "setnpcragmorph_LeftForearm" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_LeftUpperArm",
									 Description = "#Tool_setnpcragmorph_LeftUpperArm",
									 Command = "setnpcragmorph_LeftUpperArm" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_LeftFoot",
									 Description = "#Tool_setnpcragmorph_LeftFoot",
									 Command = "setnpcragmorph_LeftFoot" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_LeftCalf",
									 Description = "#Tool_setnpcragmorph_LeftCalf",
									 Command = "setnpcragmorph_LeftCalf" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_LeftThigh",
									 Description = "#Tool_setnpcragmorph_LeftThigh",
									 Command = "setnpcragmorph_LeftThigh" } )
									 

	CPanel:AddControl( "Label", { Text = "Right", Description = "" } )
	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_RightHand",
									 Description = "#Tool_setnpcragmorph_RightHand",
									 Command = "setnpcragmorph_RightHand" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_RightForearm",
									 Description = "#Tool_setnpcragmorph_RightForearm",
									 Command = "setnpcragmorph_RightForearm" }) 

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_RightUpperArm",
									 Description = "#Tool_setnpcragmorph_RightUpperArm",
									 Command = "setnpcragmorph_RightUpperArm" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_RightFoot",
									 Description = "#Tool_setnpcragmorph_RightFoot",
									 Command = "setnpcragmorph_RightFoot" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_RightCalf",
									 Description = "#Tool_setnpcragmorph_RightCalf",
									 Command = "setnpcragmorph_RightCalf" } )	
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_setnpcragmorph_RightThigh",
									 Description = "#Tool_setnpcragmorph_RightThigh",
									 Command = "setnpcragmorph_RightThigh" } )										 
end


local function InitiateWobbleMan(npc)

		local rag = ents.Create( "prop_ragdoll" ) 
		local model = npc:GetModel()

		rag:SetModel( model ) 
		rag:SetPos(npc:GetPos())  
		rag:Spawn()  
		rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS   )
		rag:SetOwner(npc)

		 local bones = rag:GetPhysicsObjectCount()

		 for i=0,bones-1 do

			 local bone = rag:GetPhysicsObjectNum( i )  

			 if IsValid( bone ) then  
				local bonepos, boneang = npc:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )  
				bone:SetPos( bonepos )  
				bone:SetAngles( boneang )   
			 end

			local matr = npc:GetBoneMatrix(i)
			matr:Scale(Vector(0, 0, 0))
			npc:SetBoneMatrix(i, matr)
		 end
		npc:SetColor(0,0,0,0)
		npc.WobbleManTagDoll = rag
		npc.WobbleManTagDoll.sleep = false
		npc:SetMaterial( "models/effects/vol_light001" ) 
		npc:DrawWorldModel( false )


		if npc:GetMaterial() != "models/effects/vol_light001" then
			npc.WobbleManMat = npc:GetMaterial()
		end

		if !npc.WobbleManBones then
			npc.WobbleManBones = {"1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00","1.00"}
		end

		if !npc.WobbleManHideWeapon then
			npc.WobbleManHideWeapon = "0.00"
		end

		if !npc.WobbleManHideViewWeapon then
			npc.WobbleManHideViewWeapon = "0.00"
		end

		if !npc.WobbleManRagdollEffectsPly then
			npc.WobbleManRagdollEffectsPly = "0.00"
		end

end
