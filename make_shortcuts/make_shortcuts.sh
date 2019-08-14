#!/usr/bin/env sh

# multiple sed commands linked by either -e or ;
cat files | sort | sed -e 's/^/map o/' -e 's/:/ $vim/' >> lf_shortcuts
echo >> lf_shortcuts
cat folders | sort | sed 's/^/map g/;s/:/ $cd/' >> lf_shortcuts

cat files | sort | sed -e 's/^/alias o/' -e "s/:/='vim/" -e "s/$/'/" >> bash_aliases
echo >> bash_aliases
cat folders | sort | sed -e 's/^/alias g/' -e "s/:/='cd/" -e "s/$/'/" >> bash_aliases
