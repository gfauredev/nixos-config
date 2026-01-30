{ lib, config, ... }:
{
  genBinds =
    workspaceSet:
    let
      mod = "SUPER"; # Main modifier, SUPER
      windowCount =
        ws: "hyprctl workspaces -j | jq -r '.[] | select(.name == \"${ws.name}\") | .windows // 0'";
      ifFocus = ws: cmd: "[ $(hyprctl activeworkspace -j | jq -r '.name') = '${ws.name}' ] && ${cmd}";
      # Logic for $mod + Key
      workspace = ws: "hyprctl dispatch workspace name:${ws.name} && sleep 0.0625";
      empty = ws: "[ $(${windowCount ws}) -eq 0 ] && ${ws.empty or config.launch.app}";
      # Logic for $mod + SHIFT + Key
      shift = ws: ifFocus ws "hyprctl dispatch movecurrentworkspacetomonitor +1";
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        "${mod}, ${key}, exec, ${ws.alreadyWinRules or ":;"} ${
          ifFocus ws (ws.already or config.launch.app)
        } || ${workspace ws} && ${empty ws}"
        "${mod} SHIFT, ${key}, execr, ${shift ws}"
        "${mod} SHIFT, ${key}, movetoworkspace, name:${ws.name}"
      ]) workspaceSet
    );
}
