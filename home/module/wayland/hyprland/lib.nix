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
      alreadyRule = ws: lib.optionalString (ws ? alreadyRule) "; ${ws.alreadyRule}";
      emptyRule = ws: lib.optionalString (ws ? emptyRule) "; ${ws.emptyRule}";
      workspace = ws: "hyprctl dispatch workspace name:${ws.name}";
      movetoWs = ws: "hyprctl dispatch movetoworkspace name:${ws.name}";
    in
    lib.concatLists (
      lib.mapAttrsToList (
        key: ws:
        let
          already = ws.already or config.launch.app;
          empty = ws.empty or config.launch.app;
        in
        [
          "${mod}, ${key}, Focus workspace ${ws.name}, execr, ${ifFocus ws (exec "workspace name:${ws.name}${alreadyRule ws}" already)} || ( ${workspace ws} && ${ifEmpty ws (exec "workspace name:${ws.name}${emptyRule ws}" empty)} )"
          "${mod} SHIFT, ${key}, Move focused window to ${ws.name} workspace, execr, ${ifFocus ws "hyprctl dispatch movecurrentworkspacetomonitor +1"} || ${movetoWs ws}"
        ]
      ) workspaceSet
    );
}
