-- pandoc previewer for office docs (.docx, .odt, .epub). Yazi 26.x API:
--   M:peek(job) / M:seek(job)         — job carries area/file/skip/units
--   ya.preview_widget(job, widgets)   — singular (was preview_widgets)
--   ya.emit(name, opts)               — was ya.manager_emit
--   Command(...):arg({list})          — singular arg, was args

local M = {}

function M:peek(job)
	local child = Command("pandoc")
		:arg({
			"--to", "plain",
			"--wrap", "none",
			tostring(job.file.url),
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return ya.preview_widget(job, ui.Text("Failed to spawn pandoc"):area(job.area))
	end

	local limit = job.area.h
	local i, lines = 0, ""
	repeat
		local next, event = child:read_line()
		if event == 1 then
			return ya.preview_widget(job, ui.Text(next):area(job.area))
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
		ya.emit("peek", {
			tostring(math.max(0, i - limit)),
			only_if = tostring(job.file.url),
			upper_bound = "",
		})
	else
		ya.preview_widget(job, ui.Text(lines):area(job.area))
	end
end

function M:seek(job)
	local h = cx.active.preview.area.h
	local step = math.floor(job.units * h / 10)
	local skip = math.max(0, cx.active.preview.skip + step)
	ya.emit("peek", {
		tostring(skip),
		only_if = tostring(job.file.url),
	})
end

return M
