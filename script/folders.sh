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
mkdir -m 700 -v "$HOME/project/"
echo "#include stignore" > "$HOME/project/.stignore"
echo "# Project, projects and eventual nested sub-projects" > "$HOME/project/.ventoyignore"
echo

echo "# Life, life areas that requires monitoring through lifetime or recurring proofs/receipts"
echo "> A life directory contains records for important areas that need monitoring (like health)"
echo "> or documents that might be recurrently asked for (like identity proofs)"
echo "- Replace house with address, bank with name of the bank, vehicle with model…"
mkdir -m 700 -v "$HOME/life/"
mkdir -m 700 -v "$HOME/life/monitor/"
touch "$HOME/life/monitor/GROUP_BY_PHYSICAL_OBJECT"
mkdir -m 700 -v "$HOME/life/monitor/body+health/"
mkdir -m 700 -v "$HOME/life/monitor/42bashRoad+inventory/"
mkdir -m 700 -v "$HOME/life/monitor/tuxCar1337/"
echo "- The proofs are grouped by the organization that delivers them, non-grouped if several"
mkdir -m 700 -v "$HOME/life/proof+formalInfo/"
touch "$HOME/life/proof+formalInfo/GROUP_BY_PROVIDER"
mkdir -m 700 -v "$HOME/life/proof+formalInfo/self+family/"
mkdir -m 700 -v "$HOME/life/proof+formalInfo/stateAdministration/"
mkdir -m 700 -v "$HOME/life/proof+formalInfo/academy+nonprofit/"
mkdir -m 700 -v "$HOME/life/proof+formalInfo/finance+insurance/"
mkdir -m 700 -v "$HOME/life/proof+formalInfo/employer+client/"
mkdir -m 700 -v "$HOME/life/proof+formalInfo/vendor+landlord/"
echo "#include stignore" > "$HOME/life/.stignore"
echo "# Life, life areas that requires monitoring through lifetime or recurring proofs/receipts" > "$HOME/data/.ventoyignore"
echo

echo "# Graph, a graph-like, non-hierarchical data store"
echo "> Contains linked and non-hierarchical data related to"
echo "> projects, important life areas or anything that seems interesting, valuable or fun"
echo "> The graph data store is usually used through and managed by a"
echo "> dedicated knowledge-management app and synced with its own method"
mkdir -m 700 -v "$HOME/.graph/"
echo "# Graph, a graph-like, non-hierarchical data store" > "$HOME/.graph/.ventoyignore"
echo

echo "# Data, unsorted or roughly sorted data that might be useful or interesting"
echo "> A data directory contains files that might become useful"
echo "> in a life area or in a project, or just be interesting or fun"
echo "> Directories represents arbitrarily chosen grouping-criterions among many that might exist"
mkdir -m 700 -v "$HOME/data/"
mkdir -m 700 -v "$HOME/data/dcim/"
mkdir -m 700 -v "$HOME/data/screenshot/"
mkdir -m 700 -v "$HOME/data/learn/"
mkdir -m 700 -v "$HOME/data/memory/"
mkdir -m 700 -v "$HOME/data/misc/"
echo "#include stignore" > "$HOME/data/.stignore"
echo "# Data, unsorted or roughly sorted data that might be useful or interesting" > "$HOME/data/.ventoyignore"
echo

echo "Archive, definitively complete or discontinued project, expired or no longer useful files"
mkdir -m 700 -v "$HOME/archive/"
mkdir -m 700 -v "$HOME/archive/project/"
mkdir -m 700 -v "$HOME/archive/life/"
echo "#include stignore" > "$HOME/archive/.stignore"
echo "Archive, definitively complete or discontinued project, expired or no longer useful files" > "$HOME/archive/.ventoyignore"
echo
