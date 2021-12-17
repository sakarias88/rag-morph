TOOL.Category		= "Stools"
TOOL.Name			= "#Rag-Mover"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab        = "RagMorph"

TOOL.ClientConVar["keygroup"] = "7"
TOOL.ClientConVar["keygroup_back"] = "4"
TOOL.ClientConVar["force"] = "500"
TOOL.ClientConVar["moveDir"] = "1"
TOOL.ClientConVar["toggle"] = "0"

if CLIENT then
	language.Add( "Tool.ragmover.name", "Make your ragdoll move" )
	language.Add( "Tool.ragmover.desc", "gsdgdsags" )
	language.Add( "Tool.ragmover.0", "Primary fire: Select bone Secondary fire: reset bone Reload: reset ragdoll" )
	language.Add( "Tool.ragmover.NumpadLabel1", "Push" )
	language.Add( "Tool.ragmover.NumpadLabel2", "Pull" )
	language.Add( "Tool.ragmover.SliderLabel", "Force" )
	language.Add( "Tool.ragmover.ListLabel", "Direction" )
	language.Add( "Tool.ragmover.checkBox", "Toggle" )
	language.Add( "Tool.ragmover.checkBoxDesc", "Should it toggle?" )
end

function TOOL:LeftClick( trace )
	if ( trace.Entity and trace.Entity:IsPlayer() ) or trace.Entity:GetClass() ~= "prop_ragdoll" then return false end
	if (CLIENT) then return true end

	if trace.Entity:IsValid()  then

		if not trace.Entity.BoneMover then
			trace.Entity.BoneMover = {}
		end

		local force = self:GetClientNumber("force")
		local key = self:GetClientNumber("keygroup")
		local key_bk = self:GetClientNumber("keygroup_back")
		local moveDir = self:GetClientNumber("moveDir")
		local bone = trace.PhysicsBone
		local toggle = self:GetClientNumber("toggle")

		if not trace.Entity.BoneMover[bone+1] then
			trace.Entity.BoneMover[bone+1] = {}
		end

		trace.Entity.BoneMover[bone+1][1] = force
		trace.Entity.BoneMover[bone+1][2] = moveDir
		trace.Entity.BoneMover[bone+1][4] = toggle

		local ply = self:GetOwner()
		numpad.OnDown(ply, key, "wobble_ApplyPhysForceToRagdollBone", trace.Entity, bone, 1)
		numpad.OnUp(ply, key, "wobble_ApplyPhysForceToRagdollBone", trace.Entity, bone, 0)

		numpad.OnDown(ply, key_bk, "wobble_ApplyPhysForceToRagdollBone", trace.Entity, bone, -1)
		numpad.OnUp(ply, key_bk, "wobble_ApplyPhysForceToRagdollBone", trace.Entity, bone, 0)

		return true
	end
end

function TOOL:RightClick( trace )
	if ( trace.Entity and trace.Entity:IsPlayer() ) or trace.Entity:GetClass() ~= "prop_ragdoll" then return false end
	if (CLIENT) then return true end

	local bone = trace.PhysicsBone
	if not trace.Entity.BoneMover then trace.Entity.BoneMover = {} end

	trace.Entity.BoneMover[bone+1] = nil
	return true
end

function TOOL:Reload( trace )
	if ( trace.Entity and trace.Entity:IsPlayer() ) or trace.Entity:GetClass() ~= "prop_ragdoll" then return false end
	if (CLIENT) then return true end

	trace.Entity.BoneMover = nil
	return true
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl("Numpad", { Label = "#Tool.ragmover.NumpadLabel1",
								Label2 = "#Tool.ragmover.NumpadLabel2",
								Command = "ragmover_keygroup", 
								Command2 = "ragmover_keygroup_back",
								ButtonSize = "22" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool.ragmover.checkBox",
									 Description = "#Tool.ragmover.checkBoxDesc",
									 Command = "ragmover_toggle" } )								

	CPanel:AddControl( "ComboBox", { Label = "#Tool.ragmover.ListLabel",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "directions" ) } )

	CPanel:AddControl( "Slider", { Label = "#Tool.ragmover.SliderLabel",
								 Description = "",
								 Type = "int",
								 Min = 0,
								 Max = 3000,
								 Command = "ragmover_force" } )
end

list.Set( "directions", "#Forward", { ragmover_moveDir = "1" } )
list.Set( "directions", "#Back", { ragmover_moveDir = "-1" } )
list.Set( "directions", "#Right", { ragmover_moveDir = "2" } )
list.Set( "directions", "#Left", { ragmover_moveDir = "-2" } )
list.Set( "directions", "#Up", { ragmover_moveDir = "3" } )
list.Set( "directions", "#Down", { ragmover_moveDir = "-3" } )
list.Set( "directions", "#View direction", { ragmover_moveDir = "4" } )