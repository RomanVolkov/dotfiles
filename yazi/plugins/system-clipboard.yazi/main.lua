-- Meant to run at async context. (yazi system-clipboard)

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local urls = selected_or_hovered()

		if #urls == 0 then
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end

		-- ya.notify({ title = #urls, content = table.concat(urls, " "), level = "info", timeout = 5 })

		-- Use AppleScript to copy files for Finder
		local file_refs = {}
		for _, url in ipairs(urls) do
			table.insert(file_refs, string.format("POSIX file %q", tostring(url)))
		end
		local apple_cmd = string.format(
			"set the clipboard to {%s} as «class furl»",
			table.concat(file_refs, ", ")
		)
		local proc = Command("osascript"):arg("-e"):arg(apple_cmd):spawn()
		local status, err = proc:wait()

		if status and status.success then
			ya.notify({
				title = "System Clipboard",
				content = "Successfully copied the file(s) to system clipboard",
				level = "info",
				timeout = 5,
			})
		end

		if not status or not status.success then
			ya.notify({
				title = "System Clipboard",
				content = string.format(
					"Could not copy selected file(s): %s",
					status and tostring(status.code) or tostring(err)
				),
				level = "error",
				timeout = 5,
			})
		end
	end,
}
