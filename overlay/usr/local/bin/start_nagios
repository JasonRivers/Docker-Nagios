#!/bin/bash

# adapted from https://github.com/discourse/discourse_docker/blob/master/image/base/boot
# this script becomes PID 1 inside the container, catches termination signals, and stops
# processes managed by runit

if [ -z "$(ls -A /opt/nagios/etc)" ]; then
    echo "Started with empty ETC, copying example data in-place"
    cp -Rp /orig/etc/* /opt/nagios/etc/
fi

if [ -z "$(ls -A /opt/nagios/var)" ]; then
    echo "Started with empty VAR, copying example data in-place"
    cp -Rp /orig/var/* /opt/nagios/var/
fi

if [ ! -f "${NAGIOS_HOME}/etc/htpasswd.users" ] ; then
  htpasswd -c -b -s "${NAGIOS_HOME}/etc/htpasswd.users" "${NAGIOSADMIN_USER}" "${NAGIOSADMIN_PASS}"
  chown -R ${NAGIOS_USER}.${NAGIOS_GROUP} "${NAGIOS_HOME}/etc/htpasswd.users"
fi

shutdown() {
  echo Shutting Down
  ls /etc/service | SHELL=/bin/sh parallel --no-notice sv force-stop {}
  if [ -e "/proc/${RUNSVDIR}" ]; then
    kill -HUP "${RUNSVDIR}"
    wait "${RUNSVDIR}"
  fi

  # give stuff a bit of time to finish
  sleep 1

  ORPHANS=$(ps -eo pid= | tr -d ' ' | grep -Fxv 1)
  SHELL=/bin/bash parallel --no-notice 'timeout 5 /bin/bash -c "kill {} && wait {}" || kill -9 {}' ::: "${ORPHANS}" 2> /dev/null
  exit
}

exec runsvdir -P /etc/service &
RUNSVDIR=$!
echo "Started runsvdir, PID is ${RUNSVDIR}"

trap shutdown SIGTERM SIGHUP SIGINT
wait "${RUNSVDIR}"

shutdown

