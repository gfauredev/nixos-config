# This script explains the root of my personal organization (based on PARA)
# and creates the associated directories in my home directory
# (although being not limited to directories)
#
# Remarks :
# - Names are choosen to sort alphabetically from the least to most actionable
# - Names are always singular, never plural
# - Names are kept short, while still be totally clear and non-ambiguous on their nature

echo "== Org == Textual organisation files =="
if [ ! -d $HOME/org ]; then
  echo "\nCreating org directory …"
  mkdir -m 700 -v $HOME/org/
fi
echo "#include stignore" > $HOME/org/.stignore
echo "Organization" > $HOME/org/.ventoyignore
echo

echo "== Project == Projects (containing sub-projects) =="
echo "  Tasks required to progress toward goal or next milestone"
echo "  Knowledge & data that are useful for the project"
if [ ! -d $HOME/project ]; then
  echo "\nCreating project directory and subdirectories …"
  mkdir -m 700 -v $HOME/project/
  echo "\nCreating large project directory to avoid on devices with fewer storage space …"
  mkdir -m 700 -v $HOME/project.large/
fi
echo "#include stignore" > $HOME/project/.stignore
echo "Project" > $HOME/project/.ventoyignore
echo "#include stignore" > $HOME/project.large/.stignore
echo

echo "== Life == Broad life areas =="
echo "  Knowledge & data that are useful regularly in life"
echo "  Tasks that needs to be done regularly and not ending projects"
if [ ! -d $HOME/life ]; then
  echo "\nCreating life directory and subdirectories …"
  mkdir -m 700 -v $HOME/life/
  mkdir -m 700 -v $HOME/life/health/
  mkdir -m 700 -v $HOME/life/identity/
  mkdir -m 700 -v $HOME/life/relation/
  mkdir -m 700 -v $HOME/life/finance+insurance/
  mkdir -m 700 -v $HOME/life/degree+certification/
  echo "\nCreating large life directory to avoid on devices with fewer storage space …"
  mkdir -m 700 -v $HOME/life.large/
fi
echo "#include stignore" > $HOME/life/.stignore
echo "Life" > $HOME/data/.ventoyignore
echo "#include stignore" > $HOME/life.large/.stignore
echo

echo "== Data == Unsorted or type-sorted data =="
echo "  Knowledge & data that might be useful in life or projects"
echo "  Interesting knowledge that might be worth or fun to learn"
if [ ! -d $HOME/data ]; then
  echo "\nCreating data directory and subdirectories …"
  mkdir -m 700 -v $HOME/data/
  mkdir -m 700 -v $HOME/data/document/
  mkdir -m 700 -v $HOME/data/document.text/
  mkdir -m 700 -v $HOME/data/audio/
  mkdir -m 700 -v $HOME/data/audio/record/
  mkdir -m 700 -v $HOME/data/audio/music.entertain/
  mkdir -m 700 -v $HOME/data/image/
  mkdir -m 700 -v $HOME/data/image/screenshot/
  mkdir -m 700 -v $HOME/data/video/
  mkdir -m 700 -v $HOME/data/video/screenrecord/
  mkdir -m 700 -v $HOME/data/video/movie.entertain/
  echo "\nCreating large data directory to avoid on devices with fewer storage space …"
  mkdir -m 700 -v $HOME/data.large/
  mkdir -m 700 -v $HOME/data.large/code/
  mkdir -m 700 -v $HOME/data.large/audio/
  mkdir -m 700 -v $HOME/data.large/audio/record/
  mkdir -m 700 -v $HOME/data.large/audio/music.entertain/
  mkdir -m 700 -v $HOME/data.large/image/
  mkdir -m 700 -v $HOME/data.large/image/screenshot/
  mkdir -m 700 -v $HOME/data.large/video/
  mkdir -m 700 -v $HOME/data.large/video/screenrecord/
  mkdir -m 700 -v $HOME/data.large/video/movie.entertain/
fi
echo "#include stignore" > $HOME/data/.stignore
echo "Data" > $HOME/data/.ventoyignore
echo "#include stignore" > $HOME/data.large/.stignore
echo

echo "== Archive == Sorting kept as-is =="
echo "  Definitely done or discontinued projects"
echo "  Definitely used or learned knowledge"
if [ ! -d $HOME/archive ]; then
  echo "\nCreating archive directory and subdirectories …"
  mkdir -m 700 -v $HOME/archive/
  mkdir -m 700 -v $HOME/archive/project/
  mkdir -m 700 -v $HOME/archive/life/
  mkdir -m 700 -v $HOME/archive/data/
fi
echo "#include stignore" > $HOME/archive/.stignore
echo "Archive" > $HOME/archive/.ventoyignore
echo
