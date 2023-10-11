# Link the Typst library to use inside Typst file
TYPST_LIB="$HOME/.local/share/typst-templates"
# TODO enhance this with proper Typst imports
[ -h "$(dirname $1)/lib.typ" ] || ln -s $TYPST_LIB $(dirname $1)/lib.typ

# Recompile the Typst file at each modification
# t "watchexec -w $1 -w $TYPST_LIB typst compile $1; rm -fv lib.typ" .
t . sh -c "typst watch $1; \rm -f $(dirname $1)/lib.typ" 

# Open generated PDF in PDF viewer
PDF="$(echo $1 | sd "typ" "pdf")"
echo "Openning PDF $pdf"
xdg-open $pdf

# Open Typst file in text editor
# $EDITOR $1
