local lint = require('lint')

lint.linters_by_ft = {
  commit = { 'commitlint', },
  c = { 'cppcheck', },  -- TODO install it via dev env
  cpp = { 'cppcheck', } -- TODO install it via dev env
}
