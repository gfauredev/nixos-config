COMMITLINT_CMD="commitlint --config $XDG_CONFIG_HOME/commitlintrc.yaml"
if [ -n "$*" ]; then
  echo "$*" | $COMMITLINT_CMD && git commit --all --message "$*"
else
  # Amend if there’s unpushed commits
  if [ -n "$(git log --branches --not --remotes)" ]; then
    git commit --amend --all --no-edit
  else
    git commit --all
    $COMMITLINT_CMD || git reset HEAD^
  fi
fi
