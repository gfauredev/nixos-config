{ lib, config, ... }:
{
  genBinds =
    workspaceSet:
    let
      notEmpty = ws: "hyprctl clients -j | jq -e 'any(.[]; .workspace.name == '${ws}')'";
      focused = ws: "[ $(hyprctl activeworkspace -j | jq -r '.name') = '${ws}' ]";
      mod = "SUPER"; # Main modifier, SUPER
      # Logic for $mod + Key
      alreadyFocusedCmd = ws: "${focused ws.name} && ${ws.empty or config.launch.app}";
      notEmptyCmd = ws: "${notEmpty ws.name} || ${ws.empty or config.launch.app}";
      # Logic for $mod + SHIFT + Key
      shiftCmd = ws: "${focused ws.name} && hyprctl dispatch movecurrentworkspacetomonitor +1";
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        # "${mod}, ${key}, exec, ${alreadyFocusedCmd ws}" FIXME Always executed
        "${mod}, ${key}, workspace, name:${ws.name}"
        "${mod}, ${key}, exec, ${notEmptyCmd ws}"
        "${mod} SHIFT, ${key}, exec, ${shiftCmd ws}"
        "${mod} SHIFT, ${key}, movetoworkspace, name:${ws.name}"
      ]) workspaceSet
    );
}
