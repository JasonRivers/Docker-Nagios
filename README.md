# Docker-Nagios

Docker image for Nagios

Build Status: [![Build Status](https://travis-ci.org/JasonRivers/Docker-Nagios.svg?branch=master)](https://travis-ci.org/JasonRivers/Docker-Nagios)

Nagios Core 4.4.8 running on Ubuntu 20.04 LTS with NagiosGraph & NRPE

| Product | Version |
| ------- | ------- |
| Nagios Core | 4.4.8 |
| Nagios Plugins | 2.4.1 |
| NRPE | 4.1.0 |
| NCPA | 2.4.0 |
| NSCA | 2.10.0 |

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
docker run --name nagios4  \
  -v /path-to-nagios/etc/:/opt/nagios/etc/ \
  -v /path-to-nagios/var:/opt/nagios/var/ \
  -v /path-to-custom-plugins:/opt/Custom-Nagios-Plugins \
  -v /path-to-nagiosgraph-var:/opt/nagiosgraph/var \
  -v /path-to-nagiosgraph-etc:/opt/nagiosgraph/etc \
  -p 0.0.0.0:8080:80 jasonrivers/nagios:latest
```

Note: The path for the custom plugins will be /opt/Custom-Nagios-Plugins, you will need to reference this directory in your configuration scripts.

There are a number of environment variables that you can use to adjust the behaviour of the container:

| Environamne Variable | Description |
|--------|--------|
| MAIL_RELAY_HOST | Set Postfix relayhost |
| MAIL_INET_PROTOCOLS | set the inet_protocols in postfix |
| NAGIOS_FQDN | set the server Fully Qualified Domain Name in postfix |
| NAGIOS_TIMEZONE | set the timezone of the server |

For best results your Nagios image should have access to both IPv4 & IPv6 networks 

#### Credentials

The default credentials for the web interface is `nagiosadmin` / `nagios`

### Extra Plugins

* Nagios nrpe [<http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details>]
* Nagiosgraph [<http://exchange.nagios.org/directory/Addons/Graphing-and-Trending/nagiosgraph/details>]
* JR-Nagios-Plugins -  custom plugins I've created [<https://github.com/JasonRivers/nagios-plugins>]
* WL-Nagios-Plugins -  custom plugins from William Leibzon [<https://github.com/willixix/WL-NagiosPlugins>]
* JE-Nagios-Plugins -  custom plugins from Justin Ellison [<https://github.com/justintime/nagios-plugins>]
* DF-Nagios-Plugins - custom pluging for MSSQL monitoring from Dan Fruehauf [<https://github.com/danfruehauf/nagios-plugins>]
* check-mqtt - custom plugin for mqtt monitoring from Jan-Piet Mens [<https://github.com/jpmens/check-mqtt.git>]
