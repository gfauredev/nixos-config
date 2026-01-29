{ lib, config, ... }:
{
  genBinds =
    workspaceSet:
    let
      empty = ws: ''hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "${ws}")' ||'';
      focused = ws: ''[ $(hyprctl activeworkspace -j | jq -r '.name') = "${ws.name}" ]'';
      mod = "SUPER"; # Main modifier, SUPER
      # Logic for $mod + Key
      focusCmd = ws: ''
        ${empty ws} "${ws.empty or config.launch.app}" || ${focused ws} "${ws.empty or config.launch.app}"
      '';
      #   focused=$(hyprctl activeworkspace -j | jq -r '.name')
      #   if [ "$focused" = "${ws.name}" ]; then
      #     hyprctl dispatch exec "${ws.already or config.launch.app}"
      #   else
      #     sleep 0.05 # Wait a tiny bit for the focus change to register in the state
      #     is_empty=$(hyprctl workspaces -j | jq -r '.[] | select(.name == "${ws.name}") | .windows')
      #     if [ "$is_empty" -eq 0 ]; then
      #       hyprctl dispatch exec "${ws.empty or config.launch.app}"
      #     fi
      #   fi
      # '';
      # Logic for $mod + SHIFT + Key
      shiftCmd = ws: ''
        [ "$(hyprctl activeworkspace -j | jq -r '.name')" = "${ws.name}" ] && hyprctl dispatch movecurrentworkspacetomonitor +1
      '';
    in
    lib.concatLists (
      lib.mapAttrsToList (key: ws: [
        "${mod}, ${key}, workspace, name:${ws.name}"
        "${mod}, ${key}, exec, ${focusCmd ws}"
        "${mod} SHIFT, ${key}, movetoworkspace, name:${ws.name}"
        "${mod} SHIFT, ${key}, exec, ${shiftCmd ws}"
      ]) workspaceSet
    );
}
