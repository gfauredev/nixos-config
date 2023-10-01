TYPST_LIB="$HOME/.local/share/typst-templates"

ln -s $TYPST_LIB lib.typ
# term "watchexec -w $1 -w $TYPST_LIB typst compile $1; rm -fv lib.typ" .
term "typst watch $1; rm -fv lib.typ" .
pdf="$(echo $1|cut -d"." -f1).pdf"
echo "Oppening the file $pdf"
xdg-open $pdf
