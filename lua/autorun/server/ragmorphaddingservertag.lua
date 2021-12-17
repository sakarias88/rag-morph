local tags = string.Explode(",",(GetConVarString("sv_tags") or ""))
for i,tag in ipairs(tags) do
	if tag:find("RagMorph") then table.remove(tags,i) end	
end
table.insert(tags, "RagMorph")
table.sort(tags)
RunConsoleCommand("sv_tags", table.concat(tags, ","))
