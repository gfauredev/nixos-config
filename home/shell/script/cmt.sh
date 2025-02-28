COMMITLINT_CMD="commitlint --config $XDG_CONFIG_HOME/commitlintrc.yaml"
# TODO Nixify ~/.config/commitlintrc.yaml
# TODO allow to write the msg unquoted
if [ -n "$1" ]; then
  echo "$@" | $COMMITLINT_CMD && git commit -am "$@"
else
  # Amend if there’s unpushed commits
  if [ -n "$(git log --branches --not --remotes)" ]; then
    git commit --amend --all --no-edit
  else
    git commit
    $COMMITLINT_CMD || git reset HEAD^
  fi
fi
