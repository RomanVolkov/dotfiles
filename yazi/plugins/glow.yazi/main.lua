-- glow previewer for markdown files.
-- Spawns `glow` with the preview pane's current width and renders the
-- output line-by-line, supporting yazi's peek/seek scrolling protocol.

local M = {}

function M:peek()
	local child = Command("glow")
		:args({
			"--style", "dark",
			"--width", tostring(math.max(self.area.w - 2, 0)),
			tostring(self.file.url),
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return ya.preview_widgets(self, {
			ui.Text("Failed to spawn glow"):area(self.area),
		})
	end

	local limit = self.area.h
	local i, lines = 0, ""
	repeat
		local next, event = child:read_line()
		if event == 1 then
			return ya.preview_widgets(self, {
				ui.Text(next):area(self.area),
			})
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > self.skip then
			lines = lines .. next
		end
	until i >= self.skip + limit

	child:start_kill()
	if self.skip > 0 and i < self.skip + limit then
		ya.manager_emit("peek", {
			tostring(math.max(0, i - limit)),
			only_if = tostring(self.file.url),
			upper_bound = "",
		})
	else
		ya.preview_widgets(self, {
			ui.Text.parse(lines):area(self.area),
		})
	end
end

function M:seek(units)
	local h = cx.active.preview.area.h
	local step = math.floor(units * h / 10)
	local skip = math.max(0, cx.active.preview.skip + step)
	ya.manager_emit("peek", {
		tostring(skip),
		only_if = tostring(self.file.url),
	})
end

return M
