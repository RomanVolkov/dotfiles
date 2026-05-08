-- pandoc previewer for office docs (.docx, .odt, .epub).
-- Converts to plain text on the fly. Same peek/seek scrolling pattern
-- as the glow previewer.

local M = {}

function M:peek()
	local child = Command("pandoc")
		:args({
			"--to", "plain",
			"--wrap", "none",
			tostring(self.file.url),
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return ya.preview_widgets(self, {
			ui.Text("Failed to spawn pandoc"):area(self.area),
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
