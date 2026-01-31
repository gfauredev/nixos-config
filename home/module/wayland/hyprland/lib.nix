{ lib, config, ... }:
{
  genBinds =
    workspaceSet:
    let
      mod = "SUPER"; # Main modifier, SUPER
      windowCount =
        ws: "hyprctl workspaces -j | jq -r '.[] | select(.name == \"${ws.name}\") | .windows // 0'";
      ifFocus = ws: cmd: "[ $(hyprctl activeworkspace -j | jq -r '.name') = '${ws.name}' ] && ${cmd}";
      workspace = ws: "hyprctl dispatch workspace name:${ws.name}";
      movetoworkspace = ws: "hyprctl dispatch movetoworkspace name:${ws.name}";
      empty = ws: "[ $(${windowCount ws}) -eq 0 ] && ${ws.empty or config.launch.app}";
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        "${mod}, ${key}, exec, ${ws.alreadyWinRules or ":;"} ${
          ifFocus ws (ws.already or config.launch.app)
        }"
        # FIXME Windows often opening on the previous workspace, even if appearing way after having moved
        "${mod}, ${key}, exec, ${ws.emptyWinRules or ":;"} sleep 0.0625; ${workspace ws}; sleep 0.5; ${empty ws}"
        "${mod} SHIFT, ${key}, execr, ${ifFocus ws "hyprctl dispatch movecurrentworkspacetomonitor +1"} || ${movetoworkspace ws}"
      ]) workspaceSet
    );
}
