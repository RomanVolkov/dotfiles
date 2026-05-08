-- glow previewer for markdown files.
-- Yazi 25+ previewer API: peek/seek take a `job` table holding area,
-- file, skip, and units. Use job.* — `self.*` is nil.

local M = {}

function M:peek(job)
	local child = Command("glow")
		:args({
			"--style", "dark",
			"--width", tostring(math.max(job.area.w - 2, 0)),
			tostring(job.file.url),
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return ya.preview_widgets(job, {
			ui.Text("Failed to spawn glow"):area(job.area),
		})
	end

	local limit = job.area.h
	local i, lines = 0, ""
	repeat
		local next, event = child:read_line()
		if event == 1 then
			return ya.preview_widgets(job, {
				ui.Text(next):area(job.area),
			})
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > job.skip then
			lines = lines .. next
		end
	until i >= job.skip + limit

	child:start_kill()
	if job.skip > 0 and i < job.skip + limit then
		ya.manager_emit("peek", {
			tostring(math.max(0, i - limit)),
			only_if = tostring(job.file.url),
			upper_bound = "",
		})
	else
		ya.preview_widgets(job, {
			ui.Text.parse(lines):area(job.area),
		})
	end
end

function M:seek(job)
	local h = cx.active.preview.area.h
	local step = math.floor(job.units * h / 10)
	local skip = math.max(0, cx.active.preview.skip + step)
	ya.manager_emit("peek", {
		tostring(skip),
		only_if = tostring(job.file.url),
	})
end

return M
