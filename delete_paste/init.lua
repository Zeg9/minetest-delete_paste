minetest.register_privilege("dp","Use delete paste")

-- mode:
--  0 => do nothing,
--  1 => remove paste,
--  2 => convert flowing pastes to sources
--  3 => delete everything in a 1-node radius
--  4 => delete everything in a 3-node radius
--  5 => dig nodes below paste
--  6 => convert everything in a 1-node radius to stone
local mode = 0

minetest.register_node("delete_paste:paste_source", {
	description = "Delete paste",
	tiles = {"delete_paste_paste.png"},
	walkable = true,
	drawtype = "glasslike",
	paramtype = "light",
	light_source = 14,
	sunlight_propagates = true,
	liquidtype = "source",
	liquid_alternative_flowing = "delete_paste:paste_flowing",
	liquid_alternative_source = "delete_paste:paste_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
})
minetest.register_node("delete_paste:paste_flowing", {
	description = "Delete paste (flowing)",
	tiles = {"delete_paste_paste_flowing.png"},
	walkable = true,
	drawtype = "glasslike",
	paramtype = "light",
	light_source = 14,
	sunlight_propagates = true,
	liquidtype = "flowing",
	liquid_alternative_flowing = "delete_paste:paste_flowing",
	liquid_alternative_source = "delete_paste:paste_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
})

minetest.register_chatcommand("dp", {
	params = "<mode>",
	description = "Switch the delete paste mode",
	privs = {dp=true},
	func = function(name,param)
		mode = tonumber(param)
	end,
})

minetest.register_abm({
	nodenames = {"delete_paste:paste_source","delete_paste:paste_flowing"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, ...)
		if mode == 0 then
		elseif mode == 1 then
			minetest.remove_node(pos)
		elseif mode == 3 then
			for x=pos.x-1,pos.x+1 do
			for y=pos.y-1,pos.y+1 do
			for z=pos.z-1,pos.z+1 do
				minetest.remove_node({x=x,y=y,z=z})
			end
			end
			end
		elseif mode == 5 then
			local p = {x=pos.x,y=pos.y-1,z=pos.z}
			local n = minetest.get_node(p).name
			if n ~= "delete_paste:paste_source" and n ~="delete_paste:paste_flowing" then
				minetest.remove_node(p)
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"delete_paste:paste_source","delete_paste:paste_flowing"},
	interval = 1.0,
	chance = 4,
	action = function(pos, node, ...)
		if mode == 0 then
		elseif mode == 2 then
			minetest.set_node(pos, {name="delete_paste:paste_source"}) -- convert flowing to source
		elseif mode == 4 then
			for x=pos.x-3,pos.x+3 do
			for y=pos.y-3,pos.y+3 do
			for z=pos.z-3,pos.z+3 do
				minetest.remove_node({x=x,y=y,z=z})
			end
			end
			end
		elseif mode == 6 then
			for x=pos.x-1,pos.x+1 do
			for y=pos.y-1,pos.y+1 do
			for z=pos.z-1,pos.z+1 do
				minetest.set_node({x=x,y=y,z=z},{name="mapgen_stone"})
			end
			end
			end
		end
	end,
})
