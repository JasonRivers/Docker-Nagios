FROM ubuntu:14.04
MAINTAINER Jason Rivers <jason@jasonrivers.co.uk>

ENV NAGIOS_HOME			/opt/nagios
ENV NAGIOS_USER			nagios
ENV NAGIOS_GROUP		nagios
ENV NAGIOS_CMDUSER		nagios
ENV NAGIOS_CMDGROUP		nagios
ENV NAGIOSADMIN_USER		nagiosadmin
ENV NAGIOSADMIN_PASS		nagios
ENV APACHE_RUN_USER		nagios
ENV APACHE_RUN_GROUP		nagios
ENV NAGIOS_TIMEZONE		UTC
ENV DEBIAN_FRONTEND		noninteractive
ENV NG_NAGIOS_CONFIG_FILE	${NAGIOS_HOME}/etc/nagios.cfg
ENV NG_CGI_DIR			${NAGIOS_HOME}/sbin
ENV NG_WWW_DIR			${NAGIOS_HOME}/share/nagiosgraph
ENV NG_CGI_URL			/cgi-bin

RUN	sed -i 's/universe/universe multiverse/' /etc/apt/sources.list	;\
	apt-get update && apt-get install -y				\
		iputils-ping						\
		netcat							\
		build-essential						\
		snmp							\
		snmpd							\
		snmp-mibs-downloader					\
		php5-cli						\
		php5-gd							\
		libgd2-xpm-dev						\
		apache2							\
		libapache2-mod-php5					\
		runit							\
		unzip							\
		bc							\
		postfix							\
		bsd-mailx						\
		libnet-snmp-perl					\
		git							\
		libssl-dev						\
		libcgi-pm-perl						\
		librrds-perl						\
		libgd-gd2-perl						\
		libnagios-object-perl

RUN	( egrep -i "^${NAGIOS_GROUP}"    /etc/group || groupadd $NAGIOS_GROUP    )				&&	\
	( egrep -i "^${NAGIOS_CMDGROUP}" /etc/group || groupadd $NAGIOS_CMDGROUP )
RUN	( id -u $NAGIOS_USER    || useradd --system -d $NAGIOS_HOME -g $NAGIOS_GROUP    $NAGIOS_USER    )	&&	\
	( id -u $NAGIOS_CMDUSER || useradd --system -d $NAGIOS_HOME -g $NAGIOS_CMDGROUP $NAGIOS_CMDUSER )


ADD https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz /tmp/
RUN	cd /tmp							&&	\
	tar -zxvf nagios-4.1.1.tar.gz				&&	\
	cd nagios-4.1.1						&&	\
	./configure							\
		--prefix=${NAGIOS_HOME}					\
		--exec-prefix=${NAGIOS_HOME}				\
		--enable-event-broker					\
		--with-nagios-command-user=${NAGIOS_CMDUSER}		\
		--with-command-group=${NAGIOS_CMDGROUP}			\
		--with-nagios-user=${NAGIOS_USER}			\
		--with-nagios-group=${NAGIOS_GROUP}		&&	\
	make all						&&	\
	make install						&&	\
	make install-config					&&	\
	make install-commandmode				&&	\
	cp sample-config/httpd.conf /etc/apache2/conf-available/nagios.conf	&&	\
	ln -s /etc/apache2/conf-available/nagios.conf /etc/apache2/conf-enabled/nagios.conf

ADD http://www.nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz /tmp/
RUN	cd /tmp							&&	\
	tar -zxvf nagios-plugins-2.1.1.tar.gz			&&	\
	cd nagios-plugins-2.1.1					&&	\
	./configure							\
		--prefix=${NAGIOS_HOME}				&&	\
	make							&&	\
	make install

ADD http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz /tmp/
RUN	cd /tmp/						&&	\
	tar -zxvf nrpe-2.15.tar.gz				&&	\
	cd nrpe-2.15						&&	\
	./configure							\
		--with-ssl=/usr/bin/openssl				\
		--with-ssl-lib=/usr/lib/x86_64-linux-gnu	&&	\
	make check_nrpe						&&	\
	cp src/check_nrpe ${NAGIOS_HOME}/libexec/

ADD http://downloads.sourceforge.net/project/nagiosgraph/nagiosgraph/1.5.2/nagiosgraph-1.5.2.tar.gz /tmp
RUN	cd /tmp/										&&	\
	tar xvzf nagiosgraph-1.5.2.tar.gz							&&	\
	cd nagiosgraph-1.5.2									&&	\
	./install.pl --install										\
		--prefix /opt/nagiosgraph								\
		--nagios-user ${NAGIOS_USER}								\
		--www-user ${NAGIOS_USER}								\
		--nagios-perfdata-file ${NAGIOS_HOME}/var/perfdata.log					\
		--nagios-cgi-url /cgi-bin							&&	\
	cp share/nagiosgraph.ssi ${NAGIOS_HOME}/share/ssi/common-header.ssi

RUN cd /opt &&		\
	git clone https://github.com/willixix/WL-NagiosPlugins.git	WL-Nagios-Plugins	&&	\
	git clone https://github.com/JasonRivers/nagios-plugins.git	JR-Nagios-Plugins	&&	\
	chmod +x /opt/WL-Nagios-Plugins/check*							&&	\
	cp /opt/nagios/libexec/utils.sh /opt/JR-Nagios-Plugins/


RUN	sed -i.bak 's/.*\=www\-data//g' /etc/apache2/envvars
RUN	export DOC_ROOT="DocumentRoot $(echo $NAGIOS_HOME/share)"					&&	\
	sed -i "s,DocumentRoot.*,$DOC_ROOT," /etc/apache2/sites-enabled/000-default.conf		&&	\
	sed -i "s,</VirtualHost>,<IfDefine ENABLE_USR_LIB_CGI_BIN>\nScriptAlias /cgi-bin/ /opt/nagios/sbin/\n</IfDefine>\n</VirtualHost>," /etc/apache2/sites-enabled/000-default.conf	&&	\
	ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

RUN	mkdir -p /usr/share/snmp/mibs								&&	\
	mkdir -p ${NAGIOS_HOME}/etc/conf.d							&&	\
	mkdir -p ${NAGIOS_HOME}/etc/monitor							&&	\
	mkdir -p ${NAGIOS_HOME}/.ssh								&&	\
	chown ${NAGIOS_USER}:${NAGIOS_GROUP} ${NAGIOS_HOME}/.ssh				&&	\
	chmod 700 ${NAGIOS_HOME}/.ssh								&&	\
	chmod 0755 /usr/share/snmp/mibs								&&	\
	touch /usr/share/snmp/mibs/.foo								&&	\
	ln -s /usr/share/snmp/mibs ${NAGIOS_HOME}/libexec/mibs					&&	\
	ln -s ${NAGIOS_HOME}/bin/nagios /usr/local/bin/nagios					&&	\
	echo "use_timezone=$NAGIOS_TIMEZONE" >> ${NAGIOS_HOME}/etc/nagios.cfg			&&	\
	echo "SetEnv TZ \"${NAGIOS_TIMEZONE}\"" >> /etc/apache2/conf-enabled/nagios.conf	&&	\
	echo "cfg_dir=${NAGIOS_HOME}/etc/conf.d" >> ${NAGIOS_HOME}/etc/nagios.cfg		&&	\
	echo "cfg_dir=${NAGIOS_HOME}/etc/monitor" >> ${NAGIOS_HOME}/etc/nagios.cfg		&&	\
	download-mibs && echo "mibs +ALL" > /etc/snmp/snmp.conf

RUN	sed -i 's,/bin/mail,/usr/bin/mail,' /opt/nagios/etc/objects/commands.cfg		&&	\
	sed -i 's,/usr/usr,/usr,'           /opt/nagios/etc/objects/commands.cfg

RUN	cp /etc/services /var/spool/postfix/etc/

RUN	mkdir -p /etc/sv/nagios								&&	\
	mkdir -p /etc/sv/apache								&&	\
	rm -rf /etc/sv/getty-5								&&	\
	mkdir -p /etc/sv/postfix

ADD nagios.init /etc/sv/nagios/run
ADD apache.init /etc/sv/apache/run
ADD postfix.init /etc/sv/postfix/run
ADD postfix.stop /etc/sv/postfix/finish
ADD start.sh /usr/local/bin/start_nagios
RUN chmod +x /usr/local/bin/start_nagios

ENV APACHE_LOCK_DIR /var/run
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

VOLUME /opt/nagios/var
VOLUME /opt/nagios/etc
VOLUME /opt/nagios/libexec
VOLUME /var/log/apache2
VOLUME /usr/share/snmp/mibs

CMD ["/usr/local/bin/start_nagios"]
