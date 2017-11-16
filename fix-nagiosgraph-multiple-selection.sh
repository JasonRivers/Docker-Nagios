#!/bin/bash
# Author: Tomasz Matejunas
# Email: tm@digitaloak.it
# Website: digitaloak.it

# Description
# Script fixes problem with not working multiple selection for nagiosgraph datasets and periods.

# Run script from the same directory as ngshared.pm.

sed -e 's/$cgi->td($cgi->popup_menu(-name => '\''period'\'', -values => \[@PERIOD_KEYS\], -labels => \\%period_labels, -size => PERIODLISTROWS, -multiple => 1)), "\\n",/$cgi->td($cgi->popup_menu(-name => '\''period'\'', -values => \[@PERIOD_KEYS\], -labels => \\%period_labels, -size => PERIODLISTROWS, -multiple)), "\\n",/' ngshared.pm > ngshared.pm2
rm ngshared.pm
mv ngshared.pm2 ngshared.pm

sed -e 's/$cgi->td($cgi->popup_menu(-name => '\''db'\'', -values => \[\], -size => DBLISTROWS, -multiple => 1)), "\\n",/$cgi->td($cgi->popup_menu(-name => '\''db'\'', -values => \[\], -size => DBLISTROWS, -multiple)), "\\n",/' ngshared.pm > ngshared.pm2
rm ngshared.pm
mv ngshared.pm2 ngshared.pm
