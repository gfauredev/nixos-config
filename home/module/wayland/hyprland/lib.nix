{ lib, config, ... }:
{
  genBinds =
    mod: workspaceSet:
    lib.concatLists (
      lib.mapAttrsToList (
        key: ws:
        let
          already = ws.already or config.launch.app;
          empty = ws.empty or config.launch.app;
          alreadyRule = lib.optionalString (ws ? alreadyRule) "; ${ws.alreadyRule}";
          emptyRule = lib.optionalString (ws ? emptyRule) "; ${ws.emptyRule}";
        in
        [
          {
            _args = [
              (lib.generators.mkLuaInline "\"${mod} + ${key}\"")
              (lib.generators.mkLuaInline ''
                function()
                  local active = hl.get_active_workspace()
                  if active and active.name == "${ws.name}" then
                    hl.dispatch(hl.dsp.exec_cmd([=[[workspace name:${ws.name}${alreadyRule}] ${already}]=]))
                  else
                    hl.dispatch(hl.dsp.focus({ workspace = "name:${ws.name}" }))
                    local target = hl.get_workspace("name:${ws.name}")
                    if not target or target.windows == 0 then
                      hl.dispatch(hl.dsp.exec_cmd([=[[workspace name:${ws.name}${emptyRule}] ${empty}]=]))
                    end
                  end
                end
              '')
              { description = "Focus workspace ${ws.name}"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"${mod} + SHIFT + ${key}\"")
              (lib.generators.mkLuaInline ''
                function()
                  local active = hl.get_active_workspace()
                  if active and active.name == "${ws.name}" then
                    hl.dispatch(hl.dsp.workspace.move({ monitor = "+1" }))
                  else
                    hl.dispatch(hl.dsp.window.move({ workspace = "name:${ws.name}" }))
                  end
                end
              '')
              { description = "Move focused window to ${ws.name} workspace"; }
            ];
          }
        ]
      ) workspaceSet
    );
}
