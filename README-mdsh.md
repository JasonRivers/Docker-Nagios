# Build and Publish

```console
docker build -t nagios:himslm01-latest .
docker tag nagios:himslm01-latest registry.lan.lxiv.uk/nagios:himslm01-latest
docker login registry.lan.lxiv.uk
docker push registry.lan.lxiv.uk/nagios:himslm01-latest
```


```console
docker build -t nagios:himslm01-4.4.6 .
docker tag nagios:himslm01-4.4.6 registry.lan.lxiv.uk/nagios:himslm01-4.4.6
docker login registry.lan.lxiv.uk
docker push registry.lan.lxiv.uk/nagios:himslm01-4.4.6
```