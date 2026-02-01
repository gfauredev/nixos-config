{ lib, config, ... }:
{
  genBinds =
    mod: workspaceSet:
    let
      windowCount =
        ws: "hyprctl workspaces -j | jq -r '.[] | select(.name == \"${ws.name}\") | .windows // 0'";
      ifFocus = ws: cmd: "[ $(hyprctl activeworkspace -j | jq -r '.name') = '${ws.name}' ] && ${cmd}";
      ifEmpty = ws: cmd: "[ $(${windowCount ws}) -eq 0 ] && ${cmd}";
      exec = rules: cmd: "hyprctl dispatch exec '[${rules}] ${cmd}'";
      alreadyRule =
        ws:
        lib.optionalString (
          ws.alreadyWinRules != null && ws.alreadyWinRules != ""
        ) "; ${ws.alreadyWinRules}";
      emptyRule =
        ws: lib.optionalString (ws.emptyWinRules != null && ws.emptyWinRules != "") "; ${ws.emptyWinRules}";
      workspace = ws: "hyprctl dispatch workspace name:${ws.name}";
      movetoWs = ws: "hyprctl dispatch movetoworkspace name:${ws.name}";
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        "${mod}, ${key}, Focus workspace ${ws.name}, execr, ${
          ifFocus ws (exec "workspace name:${ws.name}${alreadyRule ws}" (ws.already or config.launch.app))
        }; ${workspace ws}; ${
          ifEmpty ws (exec "workspace name:${ws.name}${emptyRule ws}" (ws.empty or config.launch.app))
        }"
        "${mod} SHIFT, ${key}, Move focused window to ${ws.name} workspace, execr, ${ifFocus ws "hyprctl dispatch movecurrentworkspacetomonitor +1"} || ${movetoWs ws}"
      ]) workspaceSet
    );
}
