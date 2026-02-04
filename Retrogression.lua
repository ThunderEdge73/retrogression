Retrogression = SMODS.current_mod

---@param path string
function Retrogression.recursive_load(path)
	local files = NFS.getDirectoryItems(Retrogression.path .. path)
	for _, item in ipairs(files) do
		if string.sub(item, -4) == ".lua" then
			print("Multiverse: Loading " .. item:gsub("%d+_", ""))
			assert(SMODS.load_file(path .. "/" .. item), string.format("File %s failed to load", path))()
		elseif path:find("%.") == nil then
			Retrogression.recursive_load(path .. "/" .. item)
		end
	end
end

Retrogression.recursive_load("misc")
Retrogression.recursive_load("mod")
