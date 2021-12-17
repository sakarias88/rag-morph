
TOOL.Category		= "Stools"
TOOL.Name			= "#No collide player"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab        = "RagMorph"



if CLIENT then

	
	language.Add( "Tool.setowner.name", "No collide player" )
	language.Add( "Tool.setowner.desc", "Make props not collide with you" )
	language.Add( "Tool.setowner.0", "Primary fire: No collide player, Secondary fire: Collide player" )
	
	
end

function TOOL:LeftClick( trace )


	if ( trace.Entity and trace.Entity:IsPlayer() ) then return false end

	local coll = trace.Entity:GetCollisionGroup( )
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	 
	
	if trace.Entity:IsValid()  then
		trace.Entity:SetOwner(ply)

		return true

	end
	return true

end

function TOOL:RightClick( trace )
	if ( trace.Entity and trace.Entity:IsPlayer() ) then return false end

	if (CLIENT) then return true end
	local ply = self:GetOwner()
	 
	
	if trace.Entity:IsValid()  then
		trace.Entity:SetOwner(NULL)

		return true

	end
	return true
end


function TOOL.BuildCPanel( CPanel )
CPanel:AddControl( "Label", { Text = "This is like nocolliding with the player", Description = "" } )	

end
