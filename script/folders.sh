# This script explains the root of my personal organization folders (based on PARA)
# and creates the proper associated directories in my home directory

# Directories names should :
# 1. Use consistent syntax : always singular, camelCase, ASCII alphanumeric, mostly nouns
# 2. Sort alphabetically from the least to most actionable
# 3. Be as short as possible while also as unambiguous as possible

# Sub-directories corresponding to *.git or *.large
# should not be synced with lower capacity devices

# TODO make this script idempotent

echo "# Project, projects and eventual nested sub-projects"
echo "  A project directory contains files that might be required"\
  " to progress towards a final goal or a precise milestone"
if [ ! -d $HOME/project ]; then
  mkdir -m 700 -v $HOME/project/
fi
echo "#include stignore" > $HOME/project/.stignore
echo "# Project, projects and eventual nested sub-projects"\
  > $HOME/project/.ventoyignore
echo

echo "# Life, life areas that recurrently requires precise files through lifetime"
echo "  A life directory contains files that might be required"\
  " at any time during lifetime for an important life area."
if [ ! -d $HOME/life ]; then
  mkdir -m 700 -p -v $HOME/life/monitor/{health,consumable,house,vehicle,belonging,finance}
  mkdir -m 700 -p -v $HOME/life/proof+formalInfo/{administration,academy,finance,insurance,law,state,old}
  mkdir -m 700 -p -v $HOME/life/proof+formalInfo/identity/{french,online}
fi
echo "#include stignore" > $HOME/life/.stignore
echo "# Life, life areas that recurrently requires precise files through lifetime"\
  > $HOME/data/.ventoyignore
echo

echo "# Graph, a graph-like, non-hierarchical data store"
echo "  Contains linked and non-hierarchical data related to"\
  " projects, important life areas or anything that seems interesting, valuable or fun"
echo "The graph data store is usually used through and managed by a"\
  " dedicated knowledge-management app and synced with its own method"
if [ ! -d $HOME/.graph ]; then
  mkdir -m 700 -v $HOME/.graph/
fi
# echo "#include stignore" > $HOME/.graph/.stignore
echo "# Graph, a graph-like, non-hierarchical data store"
  > $HOME/.graph/.ventoyignore
echo

echo "# Data, unsorted or roughly sorted data that might be useful or interesting"
echo "  A data directory contains files that might become useful"\
  " in a life area or in a project, or just be interesting or fun."\
  " Directories represents arbitrarily chosen grouping-criterions among many that might exist."
if [ ! -d $HOME/data ]; then
  mkdir -m 700 -p -v $HOME/data/{dcim,screenshot}
  mkdir -m 700 -p -v $HOME/data/{learn,memory,misc}
fi
echo "#include stignore" > $HOME/data/.stignore
echo "# Data, unsorted or roughly sorted data that might be useful or interesting"\
  > $HOME/data/.ventoyignore
echo

echo "Archive, definitively complete or discontinued project, expired or no longer useful files"
if [ ! -d $HOME/archive ]; then
  mkdir -m 700 -p -v $HOME/archive/{project,life}
fi
echo "#include stignore" > $HOME/archive/.stignore
echo "Archive, definitively complete or discontinued project, expired or no longer useful files"\
  > $HOME/archive/.ventoyignore
echo
