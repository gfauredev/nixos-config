---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
---@diagnostic enable

xplr.config.general.show_hidden = false

-- BÉPO remaps for default mode
xplr.config.modes.builtin.default.key_bindings.on_key.j = {
  help = "rename",
  messages = {
    "PopMode",
    { SwitchModeBuiltin = "rename" },
    {
      BashExecSilently0 = [===[
              NAME=$(basename "${XPLR_FOCUS_PATH:?}")
              "$XPLR" -m 'SetInputBuffer: %q' "${NAME:?}"
            ]===],
    },
  },
}
xplr.config.modes.builtin.default.key_bindings.on_key.o = {
  help = "sort",
  messages = {
    "PopMode",
    { SwitchModeBuiltin = "sort" },
  },
}
xplr.config.modes.builtin.default.key_bindings.on_key.c =
    xplr.config.modes.builtin.default.key_bindings.on_key.left
xplr.config.modes.builtin.default.key_bindings.on_key.t =
    xplr.config.modes.builtin.default.key_bindings.on_key.down
xplr.config.modes.builtin.default.key_bindings.on_key.s =
    xplr.config.modes.builtin.default.key_bindings.on_key.up
xplr.config.modes.builtin.default.key_bindings.on_key.r =
    xplr.config.modes.builtin.default.key_bindings.on_key.right

-- Image preview
xplr.config.modes.builtin.default.key_bindings.on_key.P = {
  help = "preview",
  messages = {
    {
      BashExecSilently0 = [===[
        swayimg "$XPLR_FOCUS_PATH" &
      ]===],
    },
  },
}
