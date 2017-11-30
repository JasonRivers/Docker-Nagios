#!/bin/bash
#################################################################
#
# Author: 	Tomasz Matejunas tm@digitaloak.it digitaloak.it
# Description:	Script adds nagiosgraph links (Stats section)
#		to nagios sidebar
#
# 		Run script from nagios/share folder where
#		is side.php script (this script will be modified)
#
##################################################################
sed '
/<\/body>/ i\
<div class="navsection">\
    <div class="navsectiontitle">Stats</div>\
    <div class="navsectionlinks">\
	<ul class="navsectionlinks">\
	    <li><a href="/nagios/cgi-bin/show.cgi" target="main">Graphs</a></li>\
	    <li><a href="/nagios/cgi-bin/showhost.cgi" target="main">Graphs by Host</a></li>\
	    <li><a href="/nagios/cgi-bin/showservice.cgi" target="main">Graphs by Service</a></li>\
	    <li><a href="/nagios/cgi-bin/showgroup.cgi" target="main">Graphs by Group</a></li>\
	</ul>\
    </div>\
</div>
' side.php > side.php2
rm side.php
mv side.php2 side.php