for finger in {left-middle-finger,left-index-finger,right-thumb,right-index-finger,right-middle-finger}; do
  echo "PREPARE YOUR $finger, ENROLL IS COMING …"
  sleep 4
  sudo fprintd-enroll -f "$finger" gf
done
