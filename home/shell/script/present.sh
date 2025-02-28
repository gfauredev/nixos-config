# Present a PDF file
present() {
  nohup pdfpc "$@" >/dev/null &
}
