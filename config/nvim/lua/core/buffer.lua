-- Smart buffer-delete shared helper.
-- If deleting `bufnr` would leave no real buffers, draw alpha into the
-- current window first so the window stays alive (preventing neo-tree from
-- expanding to fullscreen), then delete the requested buffer.

local M = {}

local function is_real_listed(b)
  if not vim.bo[b].buflisted then
    return false
  end
  local ft = vim.bo[b].filetype
  if ft == "alpha" or ft == "neo-tree" then
    return false
  end
  -- Treat empty unnamed buffers as not "real" (e.g. orphan [No Name])
  local name = vim.api.nvim_buf_get_name(b)
  if name == "" then
    local lines = vim.api.nvim_buf_get_lines(b, 0, 2, false)
    if #lines == 0 or (#lines == 1 and lines[1] == "") then
      return false
    end
  end
  return true
end

function M.smart_bdelete(bufnr, force)
  bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()

  local listed = vim.tbl_filter(is_real_listed, vim.api.nvim_list_bufs())
  local is_last = #listed <= 1 and vim.tbl_contains(listed, bufnr)

  if is_last then
    local ok, alpha = pcall(require, "alpha")
    if ok then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local wb = vim.api.nvim_win_get_buf(win)
        if vim.bo[wb].filetype ~= "neo-tree" then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
      alpha.start(false)
    end
  end
  pcall(vim.api.nvim_buf_delete, bufnr, { force = force == true })
end

return M
