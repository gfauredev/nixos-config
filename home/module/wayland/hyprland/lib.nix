{ lib, config, ... }:
{
  genBinds =
    workspaceSet:
    let
      mod = "SUPER"; # Main modifier, SUPER
      windowCount =
        ws: "hyprctl workspaces -j | jq -r '.[] | select(.name == \"${ws}\") | .windows // 0'";
      empty = ws: "[ $(${windowCount ws}) -eq 0 ] &&";
      focused = ws: "[ $(hyprctl activeworkspace -j | jq -r '.name') = '${ws}' ] &&";
      # Logic for $mod + Key
      toggleCmd =
        ws:
        let
          cmdAlready = ws.already or config.launch.app;
          cmdEmpty = ws.empty or config.launch.app;
          exec = "hyprctl dispatch exec";
          workspace = "hyprctl dispatch workspace";
        in
        # FIXME Works in shell but not in Hyprland’s exec
        "${focused ws.name} ${exec} '${cmdAlready}' || ${workspace} name:${ws.name} && ${empty ws.name} ${exec} '${cmdEmpty}'";
      # Logic for $mod + SHIFT + Key
      shiftCmd = ws: "${focused ws.name} && hyprctl dispatch movecurrentworkspacetomonitor +1";
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        # "${mod}, ${key}, exec, ${toggleCmd ws}" FIXME
        "${mod}, ${key}, workspace, ${ws.name}" # Temporary FIX
        "${mod} SHIFT, ${key}, exec, ${shiftCmd ws}"
        "${mod} SHIFT, ${key}, movetoworkspace, name:${ws.name}"
      ]) workspaceSet
    );
}
