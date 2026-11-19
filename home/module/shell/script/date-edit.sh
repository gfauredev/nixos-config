#!/bin/sh

# Edit file with default text editor prepending the ISO date
$EDITOR "$(date -I)"."$*"
