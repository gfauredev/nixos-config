# This script explains the root of my personal organization folders (based on PARA)
# and creates the proper associated directories in my home directory

# Directories names should :
# 1. Use consistent syntax : always singular, camelCase, ASCII alphanumeric, mostly nouns
# 2. Sort alphabetically from the least to most actionable
# 3. Be as short as possible while also as unambiguous as possible

# Sub-directories corresponding to *.git or *.large
# should not be synced with lower capacity devices

echo "# Project, projects and eventual nested sub-projects"
echo "> A project directory contains files that might be required"
echo "> to progress towards a final goal or a precise milestone"
# if [ ! -d $HOME/project ]; then # TODO make this script idempotent
mkdir -m 700 -v $HOME/project/
# fi
echo "#include stignore" > $HOME/project/.stignore
echo "# Project, projects and eventual nested sub-projects"\
  > $HOME/project/.ventoyignore
echo

echo "# Life, life areas that requires monitoring through lifetime or recurring proofs/receipts"
echo "> A life directory contains records for important areas that need monitoring (like health)"
echo "> or documents that might be recurrently asked for (like identity proofs)"
# if [ ! -d $HOME/life ]; then
echo "- Replace house with address, bank with name of the bank, vehicle with model…"
mkdir -m 700 -v $HOME/life/
mkdir -m 700 -v $HOME/life/monitor/
mkdir -m 700 -v $HOME/life/monitor/health/
mkdir -m 700 -v $HOME/life/monitor/consumable/
mkdir -m 700 -v $HOME/life/monitor/house/
mkdir -m 700 -v $HOME/life/monitor/vehicle/
mkdir -m 700 -v $HOME/life/monitor/bank/
mkdir -m 700 -v $HOME/life/monitor/belonging/
touch $HOME/life/monitor/GROUP_BY_PHYSICAL_OBJECT
echo "- The proofs are grouped by the organization that delivers them, non-grouped if several"
mkdir -m 700 -v $HOME/life/proof+formalInfo/
mkdir -m 700 -v $HOME/life/proof+formalInfo/self/
mkdir -m 700 -v $HOME/life/proof+formalInfo/state/
mkdir -m 700 -v $HOME/life/proof+formalInfo/school/
mkdir -m 700 -v $HOME/life/proof+formalInfo/bank/
mkdir -m 700 -v $HOME/life/proof+formalInfo/insurance/
mkdir -m 700 -v $HOME/life/proof+formalInfo/company/
touch $HOME/life/proof+formalInfo/GROUP_BY_PROVIDER
# fi
echo "#include stignore" > $HOME/life/.stignore
echo "# Life, life areas that requires monitoring through lifetime or recurring proofs/receipts"\
  > $HOME/data/.ventoyignore
echo

echo "# Graph, a graph-like, non-hierarchical data store"
echo "> Contains linked and non-hierarchical data related to"
echo "> projects, important life areas or anything that seems interesting, valuable or fun"
echo "> The graph data store is usually used through and managed by a"
echo "> dedicated knowledge-management app and synced with its own method"
# if [ ! -d $HOME/.graph ]; then
mkdir -m 700 -v $HOME/.graph/
# fi
# echo "#include stignore" > $HOME/.graph/.stignore
echo "# Graph, a graph-like, non-hierarchical data store"
  > $HOME/.graph/.ventoyignore
echo

echo "# Data, unsorted or roughly sorted data that might be useful or interesting"
echo "> A data directory contains files that might become useful"
echo "> in a life area or in a project, or just be interesting or fun"
echo "> Directories represents arbitrarily chosen grouping-criterions among many that might exist"
# if [ ! -d $HOME/data ]; then
mkdir -m 700 -v $HOME/data/
mkdir -m 700 -v $HOME/data/dcim/
mkdir -m 700 -v $HOME/data/screenshot/
mkdir -m 700 -v $HOME/data/learn/
mkdir -m 700 -v $HOME/data/memory/
mkdir -m 700 -v $HOME/data/misc/
# fi
echo "#include stignore" > $HOME/data/.stignore
echo "# Data, unsorted or roughly sorted data that might be useful or interesting"\
  > $HOME/data/.ventoyignore
echo

echo "Archive, definitively complete or discontinued project, expired or no longer useful files"
# if [ ! -d $HOME/archive ]; then
mkdir -m 700 -v $HOME/archive/
mkdir -m 700 -v $HOME/archive/project/
mkdir -m 700 -v $HOME/archive/life/
# fi
echo "#include stignore" > $HOME/archive/.stignore
echo "Archive, definitively complete or discontinued project, expired or no longer useful files"\
  > $HOME/archive/.ventoyignore
echo
