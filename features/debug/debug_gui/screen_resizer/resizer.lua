local resizer = {}

resizer.sizes = {}
resizer.logs = true

function resizer:add_size(w, h, tag, scale)
	assert(w and h, "add_size requires w and h")
	table.insert(self.sizes, {
		w = w,
		h = h,
		tag = tag,
		scale = scale or 1,
	})
end

function resizer:show_menu(x, y)
	screen_resizer.menu_begin()
	for i, entry in ipairs(self.sizes) do
		screen_resizer.menu_label(i, true, entry.tag)
	end
	screen_resizer.menu_finish()
	local idx =  screen_resizer.menu_show(x, y)
	if idx == 0 then return end
	resizer:set_size_by_idx(idx)
end

function resizer:set_size_by_idx(idx)
	local entry = assert(self.sizes[idx], "no size for:" .. idx)
	local scale = entry.scale or 1
	local w = entry.w * scale
	local h = entry.h * scale
	screen_resizer.set_view_size(nil, nil, w, h)
	if self.logs then print(string.format("[RESIZER] change size to:%s scaled:%dx%d", entry.tag, w, h)) end
end

return resizer
