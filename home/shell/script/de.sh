# Edit a file prepending the ISO date
de() {
  $EDITOR "$(date -I)".$*
}
