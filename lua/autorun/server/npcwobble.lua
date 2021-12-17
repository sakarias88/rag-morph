
local allNPCs = {}
local NPCcounter = 0;
local checkTableDelay = 0;

local boneTable = {"ValveBiped.Bip01_Pelvis",
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

local function GetBoneCheckId( boneName )
	for i = 1, 15 do 
		
		if boneName == boneTable[i] then
			return i
		end
	end

	return -1
end

function addNPCtoTable(npc)
	NPCcounter = NPCcounter + 1
	allNPCs[NPCcounter] = npc
end

function checkNPCtalbe()

	local newNPCtable = {}
	local slot = 0
	
	for i=1,NPCcounter do 
		if allNPCs[i] and allNPCs[i]:IsValid() and IsValid(allNPCs[i]) then
			slot = slot + 1;
			newNPCtable[slot] = allNPCs[i]
		end
	end
	
	allNPCs = newNPCtable
	NPCcounter = slot
end

hook.Add("Think","MoveNPCWobbleRagdollBones",
function()

	for k, v in pairs( allNPCs ) do	
		if v:IsNPC() then
			if v.WobbleManTagDoll and v.WobbleManTagDoll ~= NULL then

				local bones = v.WobbleManTagDoll:GetPhysicsObjectCount()
				for i = 0 , bones-1 do

					local bone = v.WobbleManTagDoll:GetPhysicsObjectNum( i ) 
				
					if IsValid( bone ) then 
						bone:Wake()
						
						local modelBoneID = v.WobbleManTagDoll:TranslatePhysBoneToBone( i )
						local modelBoneName = v.WobbleManTagDoll:GetBoneName( modelBoneID )
						
						local arrID = GetBoneCheckId( modelBoneName )
						
						if arrID ~= -1 and v.WobbleManBones[arrID] ~= nil and v.WobbleManBones[arrID] == "1.00" then
						
							local bonepos, boneang = v:GetBonePosition( v.WobbleManTagDoll:TranslatePhysBoneToBone( i ) )  
							bone:SetPos( bonepos )  
							bone:SetAngles( boneang )  
							bone:SetVelocity( v:GetVelocity() )
						end
					end
				end				
				
			end
		end
	end	

	if checkTableDelay < CurTime() then
		checkTableDelay = CurTime() + 2
		checkNPCtalbe()
	end
	
end)

-- Removing it if the NPC dies
hook.Add("OnNPCKilled","RemoveNPCWobble",
function( victim, killer, weapon )

		if victim.WobbleManTagDoll and victim.WobbleManTagDoll ~= NULL  then
			victim.WobbleManTagDoll:Remove()
		end
end)


function addNPCtable( pl, npc )
	addNPCtoTable(npc)
end
hook.Add("PlayerSpawnedNPC", "AddNPCtoNPCTable", addNPCtable)


function RemoveNPCRagMorph(ent)

	if( ent:IsNPC() and ent.WobbleManTagDoll and ent.WobbleManTagDoll ~= NULL ) then
		ent.WobbleManTagDoll:Remove()
	end

end
hook.Add("EntityRemoved", "RemoveNPCRagMorph", RemoveNPCRagMorph)











