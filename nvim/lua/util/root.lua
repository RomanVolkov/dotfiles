local M = {}

local function buf_dir(buf)
  buf = buf or 0
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return vim.fn.getcwd()
  end
  return vim.fn.fnamemodify(name, ":p:h")
end

---Git root for the current buffer. Falls back to cwd.
---@return string
function M.git()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.git and snacks.git.get_root then
    local root = snacks.git.get_root(buf_dir())
    if root then
      return root
    end
  end
  local found = vim.fs.find(".git", { upward = true, path = buf_dir() })
  if found and found[1] then
    return vim.fn.fnamemodify(found[1], ":h")
  end
  return vim.fn.getcwd()
end

---Project root for the current buffer: LSP workspace -> .git/lua marker -> cwd.
---@return string
function M.project()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local ws = client.workspace_folders
    if ws and ws[1] then
      return vim.uri_to_fname(ws[1].uri)
    end
    if client.config and client.config.root_dir then
      return client.config.root_dir
    end
  end
  local found = vim.fs.find({ ".git", "lua" }, { upward = true, path = buf_dir() })
  if found and found[1] then
    return vim.fn.fnamemodify(found[1], ":h")
  end
  return vim.fn.getcwd()
end

return M
