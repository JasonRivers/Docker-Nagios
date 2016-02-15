# Docker-Nagios
Docker image for Nagios

Nagios Core 4.1.1 running on Ubuntu 14.04 LTS with NagiosGraph & NRPE


### Configurations
Nagios Configuration lives in /opt/nagios/etc
NagiosGraph configuration lives in /opt/nagiosgraph/etc

### Install

```sh
docker pull jasonrivers/nagios:latest
```

### Running

Run with the example configuration with the following:

```sh
docker run --name nagios4 -p 0.0.0.0:8080:80 jasonrivers/nagios:latest
```

alternatively you can use external Nagios configuration & log data with the following:

```sh
docker run --name nagios4 -v /path-to-nagios/etc/:/opt/nagios/etc/ -v /path-to-nagios/var:/opt/nagios/var/ -p 0.0.0.0:8080:80 jasonrivers/nagios:latest
```

For best results your Nagios image should have access to both IPv4 & IPv6 networks 

### Extra Plugins

* Nagios nrpe [http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details]
* Nagiosgraph [http://exchange.nagios.org/directory/Addons/Graphing-and-Trending/nagiosgraph/details]
* JR-Nagios-Plugins -  custom plugins I've created [https://github.com/JasonRivers/nagios-plugins]
* WL-Nagios-Plugins -  custom plugins from William Leibzon [https://github.com/willixix/WL-NagiosPlugins]


