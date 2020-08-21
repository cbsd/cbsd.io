#!/bin/sh

. /etc/rc.conf

[ -z "${cbsd_workdir}" ] && exit
export workdir="${cbsd_workdir}"
globalconf="${workdir}/cbsd.conf";

[ ! -f ${globalconf} ] && exit
. ${globalconf}
. ${subr}
. ${inventory}

MAP="${dbdir}/jmap.txt"
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
DOCROOT="/home/web/dashboard"
INDEX="${DOCROOT}/index.html"

[ ! -d "${DOCROOT}" ] && mkdir -p ${DOCROOT}
[ ! -f "${MAP}" ] && err 1 "No such ${MAP}"

. ${MAP} 2>/dev/null

cat > ${INDEX} <<eof <html="">

<script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/js/bootstrap.js"></script>
<link type="text/css" rel="stylesheat" href="/css/bootstrap.css">


<font size="-2">

EOF

MJ=`cut -d = -f 1 ${MAP}`

for i in ${MJ}; do
    eval T="\$$i"
    NODE=$(echo ${T} |awk '{printf $1}')
    A=""

    if [ -n "${NODE}" ]; then
    A=$(cbsd rexe node=${NODE} /usr/local/bin/cbsd jdescr jname=${i} 2>/dev/null)
    TEMPLIST="/tmp/pkg_info.$$"
    cbsd rexe node=${NODE} cat /usr/jails/jails-system/${i}/pkg_info|tr -d \\r > ${TEMPLIST}
    echo "<pre>" > ${DOCROOT}/pkg_info_${i}.html
    erro=`cbsd rexe node=${NODE} cat ${TEMPLIST} >> ${DOCROOT}/pkg_info_${i}.html 2>/dev/null`
    rm -f ${TEMPLIST}
    fi

cat >>${INDEX} <<eof <tr=""></eof></pre>
EOF
done

cat <<eof <="" table="">


EOF


         <!-- end content -->
    <div class="footer">Copyright © 2013—2019 CBSD Team.</div>
     <!-- end main -->
    <script type="text/javascript">if(typeof main=='object') main.start();</script>


</eof><table border="1">
<tbody><tr bgcolor="#CCFFCC"><td>jname</td><td>srv</td></tr><tr><td bgcolor="#CCFFCC"><a href="pkg_info_${i}.html" data-toggle="tooltip" data-placement="right" title="$A">${i}</a></td><td>${T}</td></tr></tbody></table></font></eof>
