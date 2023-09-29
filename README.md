# haproxy-self-reload
(forked from [aledbf/haproxy-self-reload](https://github.com/aledbf/haproxy-self-reload))

Monitor HAProxy configuration file changes to trigger a reload

*Using docker*

```console
$ docker run -v /some/haproxy.cfg:/etc/haproxy/haproxy.cfg:ro ug1ybob/haproxy-self-reload:0.0.3
```

*Creating a pod*

```console
$ kubectl create -f ./pod.yaml
```
