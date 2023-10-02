TYPST_LIB="$HOME/.local/share/typst-templates"

[ -h "$(dirname $1)/lib.typ" ] || ln -s $TYPST_LIB $(dirname $1)/lib.typ

# t "watchexec -w $1 -w $TYPST_LIB typst compile $1; rm -fv lib.typ" .
t . sh -c "typst watch $1; \rm -f $(dirname $1)/lib.typ" 

# pdf="$(echo $1|cut -d"." -f1).pdf"
# echo "Oppening the file $pdf"
# xdg-open $pdf

$EDITOR $1
