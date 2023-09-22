# Create dl dir in user temp dir
[ -d /run/user/$(id -u)/dl ] || mkdir -m 700 /run/user/$(id -u)/dl
[ -h $XDG_DOWNLOAD_DIR ] || ln -s /run/user/$(id -u)/dl $XDG_DOWNLOAD_DIR

# Create USB dir
[ -h $HOME/usb ] || ln -s /run/media/$USER $HOME/usb

# Create files dirs
[ -d $HOME/doc ] || mkdir -m 700 $HOME/doc
echo "Documents" > $HOME/doc/.ventoyignore
[ -d $HOME/note ] || mkdir -m 700 $HOME/note
echo "Notes" > $HOME/note/.ventoyignore
[ -d $HOME/perso ] || mkdir -m 700 $HOME/perso
echo "Personal documents" > $HOME/perso/.ventoyignore
[ -d $HOME/aud ] || mkdir -m 700 $HOME/aud
echo "Audio files" > $HOME/aud/.ventoyignore
[ -d $HOME/img ] || mkdir -m 700 $HOME/img
echo "Images & Videos" > $HOME/img/.ventoyignore
[ -d $HOME/misc ] || mkdir -m 700 $HOME/misc
echo "Miscellaneous" > $HOME/misc/.ventoyignore
