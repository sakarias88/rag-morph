

if ( SERVER ) then
	AddCSLuaFile( "wobblemanmenu.lua" )
	return
end

--Rigging
local riggingPanel = {"Pelvis", "Chest", "Head", "Hand", "Forearm", "Upper arm", "Foot", "Calf", "Thigh"}
local riggingTitles = { "Middle", "Left Arm", "Left Leg", "Right Arm", "Right Leg"}
local riggingCheckBoxes = {}
local riggingSettings = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

--Options
local OptionsPanel = {"Hide World Weapon", "Hide View Weapon", "Ragdoll physics effects player", "First Person View", "Physics effects ragdoll", "Use ragmorph as deathragdoll", "Snap Ragdoll head to view angle"}
local OptionsCheckBoxes = {}
local OptionsSettings = { 1, 1, 0, 0, 1, 1, 0}


local function ChangeBoneRigging()
	
	ply = LocalPlayer()
	for i, v in pairs( riggingCheckBoxes ) do
		local val = 0
		
		if v:GetChecked( true ) then
			val = 1
		end
		
		riggingSettings[i] = val					
	end	
	
	RunConsoleCommand( "wobble_ChangeBoneRigging", riggingSettings[1], riggingSettings[2], riggingSettings[3], riggingSettings[4], riggingSettings[5]
												 , riggingSettings[6], riggingSettings[7], riggingSettings[8], riggingSettings[9], riggingSettings[10]
												 , riggingSettings[11], riggingSettings[12], riggingSettings[13], riggingSettings[14], riggingSettings[15])								 									 
end

local function ChangeRagMorphOptions()

	ply = LocalPlayer()
	for i, v in pairs( OptionsCheckBoxes ) do
		local val = 0
		
		if v:GetChecked( true ) then
			val = 1
		end
		
		OptionsSettings[i] = val					
	end	
	
	RunConsoleCommand( "wobble_ChangeRagMorphOptions", OptionsSettings[1], OptionsSettings[2], OptionsSettings[3], OptionsSettings[4], OptionsSettings[5], OptionsSettings[6], OptionsSettings[7])
end



function MakeAddToolMenuTabs()
    spawnmenu.AddToolTab("RagMorph", "Rag Morph", "icons/ragMorphIco")
end
hook.Add("AddToolMenuTabs", "MakeAddToolMenuTabs", MakeAddToolMenuTabs) 

function RagMorphRigging(Panel)
    Panel:ClearControls()
	
	local titleCount = 1
	local checkBoxCount = 1
	for i = 1, 15 do 
		
		local titleSlot = math.fmod( i, 3 )
		
		if titleSlot == 1 then
			local label = vgui.Create("DLabel", dermaPanel)
			label:SetText(riggingTitles[titleCount])
			Panel:AddItem(label)	
			titleCount = titleCount + 1
		end
		
		checkBoxCount = i
		if checkBoxCount > 9 then checkBoxCount = checkBoxCount - 6 end
		
		local pos = 1
		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( riggingPanel[checkBoxCount] ) 
		checkBox:SetValue( riggingSettings[i] )
		Panel:AddItem(checkBox)
		riggingCheckBoxes[i] = checkBox		
	end
	
	Panel.Think = function()
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			Panel.applySettings = true
		elseif ( not input.IsMouseDown( MOUSE_LEFT ) and Panel.applySettings ) then
			ChangeBoneRigging()
			Panel.applySettings = false
		end
	end	


end



function RagMorphOptions(Panel)
    Panel:ClearControls()
	
	for i = 1, 7 do 
	
		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( OptionsPanel[i] ) 
		checkBox:SetValue( OptionsSettings[i] )
		Panel:AddItem(checkBox)
		OptionsCheckBoxes[i] = checkBox		
	end
	
	Panel.Think = function()
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			Panel.applySettings = true
		elseif ( not input.IsMouseDown( MOUSE_LEFT ) and Panel.applySettings ) then
			ChangeRagMorphOptions()
			Panel.applySettings = false
		end
	end	
	

end


function RagMorphCommands(Panel)
    Panel:ClearControls()

	local label = vgui.Create("DLabel", dermaPanel)
	label:SetText(" ")
	
	Panel:AddControl("Button", {Text = "Rag Morph mode ON", Command = "CreateWobbleManMENU"})
	Panel:AddControl("Button", {Text = "Rag Morph mode OFF", Command = "RemoveWobbleManMENU"})
	
	Panel:AddItem(label)
	
	Panel:AddControl("Button", {Text = "Freeze Rag Morph", Command = "FreezeWobbleManMENU"})
	Panel:AddControl("Button", {Text = "Un-freeze Rag Morph", Command = "UnFreezeWobbleManMENU"})	
	
	Panel:AddItem(label)
	
	Panel:AddControl("Button", {Text = "Ragdoll mode ON", Command = "RagMorphRagdollModeOn"})		
	Panel:AddControl("Button", {Text = "Ragdoll mode OFF", Command = "RagMorphRagdollModeOff"})	
end


--Tabs
function AddPopulateRagMorphMenu()
	spawnmenu.AddToolMenuOption("RagMorph", "General", "RagMorphRigging", "#Rigging", "", "", RagMorphRigging)		
	spawnmenu.AddToolMenuOption("RagMorph", "General", "RagMorphOptions", "#Options", "", "", RagMorphOptions)
	spawnmenu.AddToolMenuOption("RagMorph", "General", "RagMorphCommands", "#Commands", "", "", RagMorphCommands)				
end
hook.Add("PopulateToolMenu", "AddPopulateRagMorphMenu", AddPopulateRagMorphMenu)



