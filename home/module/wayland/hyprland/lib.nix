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
      workspace = name: "hyprctl dispatch workspace name:${name}";
      ifEmpty = ws: cmd: "[ $(${windowCount ws}) -eq 0 ] && ${cmd}";
      # Logic for $mod + SHIFT + Key
      shift = ws: ifFocus ws "hyprctl dispatch movecurrentworkspacetomonitor +1";
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        "${mod}, ${key}, exec, [${ws.alreadyWinRules or ""}] ${
          ifFocus ws (ws.already or config.launch.app)
        } || ${workspace ws.name} && ${ifEmpty ws (ws.empty or config.launch.app)}"
        "${mod} SHIFT, ${key}, exec, ${shift ws}"
        "${mod} SHIFT, ${key}, movetoworkspace, name:${ws.name}"
      ]) workspaceSet
    );
}
