-- Org mode
require "orgmode".setup_ts_grammar()      -- Org mode grammars (exec before treesitter)

require "orgmode".setup({
  org_agenda_files = { "~/note/*.org" }, -- ISO date
  org_default_notes_file = "~/note/in.org",
  mappings = {
    disable_all = true,
    global = {
      org_agenda = { '<Leader>oa' },
      org_capture = { '<Leader>oc' },
    },
    org = {
      org_cycle = { '<TAB>' },
      org_change_date = { '<Leader>ocid' },
      org_priority_up = { '<Leader>ociR' },
      org_priority_down = { '<Leader>ocir' },
      org_todo = { '<Leader>ocit' },
      org_todo_prev = { '<Leader>ociT' },
    }
  }
})
