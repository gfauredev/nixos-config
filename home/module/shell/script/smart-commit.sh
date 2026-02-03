switch "$0" in
  feat:|fix:|doc:|docs:|style:|refactor:|perf:|test:|chore:|build:|ci:|revert:|wip:)
    git commit --all --message "$0 $*"
    exit 0
    ;;
esac
if [ -n "$*" ]; then
  # echo "$*" | $COMMITLINT_CMD &&
  git commit --all --message "$*"
else
  # Amend if there’s unpushed commits
  if [ -n "$(git log --branches --not --remotes)" ]; then
    git commit --amend --all --no-edit
  else
    # git commit --all
    git add --all
    gitmoji commit # Interactively select an emoji commit message
    # $COMMITLINT_CMD || git reset HEAD^
  fi
fi
