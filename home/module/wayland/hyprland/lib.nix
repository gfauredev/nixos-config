{ lib, config, ... }:
{
  genBinds =
    workspaceSet:
    let
      empty = ws: ''hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "${ws}")' ||'';
      focused = ws: ''[ $(hyprctl activeworkspace -j | jq -r '.name') = "${ws}" ] &&'';
      mod = "SUPER"; # Main modifier, SUPER
      # Logic for $mod + Key
      focusCmd = ws: "${empty ws.name} ${ws.empty or config.launch.app}";
      # Logic for $mod + SHIFT + Key
      # shiftCmd = ws: ''
      #   ${focused ws.name} hyprctl dispatch movecurrentworkspacetomonitor +1
      # '';
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        "${mod}, ${key}, workspace, name:${ws.name}"
        "${mod}, ${key}, exec, ${focusCmd ws}"
        "${mod} SHIFT, ${key}, movetoworkspace, name:${ws.name}"
        # "${mod} SHIFT, ${key}, exec, ${shiftCmd ws}"
      ]) workspaceSet
    );
}
