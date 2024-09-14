local M = {}

local function lazy_map(tbls)
  for _, tbl in ipairs(tbls) do
    local opt = {}
    for k, v in pairs(tbl) do
      if type(k) == 'string' and k ~= 'mode' then
        opt[k] = v
      end
    end
    vim.keymap.set(tbl['mode'], tbl[1], tbl[2], opt)
  end
end

lazy_map {
  { '<leader>;',           ':',               mode = { 'n', 'v', }, silent = false, desc = 'cmdline', },
  { '<leader><c-;>',       ':lua ',           mode = { 'n', 'v', }, silent = false, desc = 'cmdline, lua', },
  { 'Q',                   'q',               mode = { 'n', 'v', }, silent = true,  desc = 'q', },
  { 'c.',                  '<cmd>cd %:h<cr>', mode = { 'n', 'v', }, silent = true,  desc = 'cd %:h', },
  { 'cu',                  '<cmd>cd ..<cr>',  mode = { 'n', 'v', }, silent = true,  desc = 'cd ..', },
  { 'U',                   '<c-r>',           mode = { 'n', },      silent = true,  desc = 'redo', },
  { '<S-ScrollWheelDown>', '10zl',            mode = { 'n', 'v', }, silent = false, desc = 'scroll right horizontally', },
  { '<S-ScrollWheelUp>',   '10zh',            mode = { 'n', 'v', }, silent = false, desc = 'scroll left horizontally', },
  { '<c-j>',               '5j',              mode = { 'n', 'v', }, silent = true,  desc = '5j', },
  { '<c-k>',               '5k',              mode = { 'n', 'v', }, silent = true,  desc = '5k', },
  { '<a-y>',               '"+y',             mode = { 'n', 'v', }, silent = true,  desc = '"+y', },
  { '<a-d>',               '"+d',             mode = { 'n', 'v', }, silent = true,  desc = '"+d', },
  { '<a-c>',               '"+c',             mode = { 'n', 'v', }, silent = true,  desc = '"+c', },
  { '<a-p>',               '"+p',             mode = { 'n', 'v', }, silent = true,  desc = '"+p', },
  { '<a-s-p>',             '"+P',             mode = { 'n', 'v', }, silent = true,  desc = '"+P', },
  { '<c-c>',               '"+y',             mode = { 'v', },      silent = true,  desc = '"+y', },
}

function M.yank(feedkeys)
  local B = require 'dp_base'
  local save_cursor = vim.fn.getcurpos()
  B.cmd('norm %s', feedkeys)
  if B.is_in_str('y', feedkeys) then
    local temp = ''
    vim.fn.setpos('.', save_cursor)
    local head = 'yank to '
    if B.is_in_str('+', feedkeys) then
      temp = vim.fn.getreg '+'
      head = head .. '+'
    else
      temp = vim.fn.getreg '"'
      head = head .. '"'
    end
    B.notify_info_append { head, temp, }
  end
end

lazy_map {
  -- { 'q',  '<cmd>WhichKey q<cr>',                                                 mode = { 'n', 'v', }, silent = true, desc = '<nop>', },
  { 'q',     '<nop>',                                                                   mode = { 'n', 'v', }, silent = true, desc = '<nop>', },
  { '<cr>e', '<cmd>e!<cr>',                                                             mode = { 'n', 'v', }, silent = true, desc = 'e!', },
  { '<cr>c', function() vim.cmd 'silent !explorer "%:p:h"' end,                         mode = { 'n', 'v', }, silent = true, desc = 'explorer %:h', },
  { '<cr>w', function() vim.cmd('silent !explorer "' .. vim.loop.cwd() .. '"') end,     mode = { 'n', 'v', }, silent = true, desc = 'explorer cwd', },
  { '<cr>s', function() vim.cmd 'silent !start "" "%:p"' end,                           mode = { 'n', 'v', }, silent = true, desc = 'start %:h', },
  { '<cr>d', function() vim.cmd 'silent !start /d "%:p" cmd' end,                       mode = { 'n', 'v', }, silent = true, desc = 'start %:p cmd', },
  { '<cr>f', function() vim.cmd('silent !start /d "' .. vim.loop.cwd() .. '" cmd') end, mode = { 'n', 'v', }, silent = true, desc = 'start cwd cmd', },
}

-- lazy_map {
--   { 'qy',         function() M.yank 'qiy' end,   desc = 'qiy', mode = { 'n', }, silent = true, },
--   { 'q<leader>y', function() M.yank 'qi"+y' end, desc = 'qiy', mode = { 'n', }, silent = true, },
-- }

lazy_map {
  { 'vw',         function() M.yank 'viw' end,   desc = 'viw',   mode = { 'n', }, silent = true, },
  { 'v<leader>w', function() M.yank 'viW' end,   desc = 'viW',   mode = { 'n', }, silent = true, },
  { 'yw',         function() M.yank 'yiw' end,   desc = 'yiw',   mode = { 'n', }, silent = true, },
  { 'y<leader>w', function() M.yank 'yiW' end,   desc = 'yiW',   mode = { 'n', }, silent = true, },
  { 'y<cr>w',     function() M.yank '"+yiw' end, desc = '"+yiw', mode = { 'n', }, silent = true, },
  { 'y<cr><cr>w', function() M.yank '"+yiW' end, desc = '"+yiW', mode = { 'n', }, silent = true, },
}

-- 只保留第二列数据
-- %s/[^,]\+,\([^,]*\),.*/\=submatch(1)
