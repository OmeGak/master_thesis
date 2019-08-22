DEBUG=false
if ${DEBUG}; then
typ bash main_comp.sh in de terminal!
fi

#!/bin/bash
latex main
biber main
pdflatex main


