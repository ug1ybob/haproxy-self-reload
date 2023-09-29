#syntax=docker/dockerfile:1.6.0

FROM golang:1.21.1-bullseye AS builder
WORKDIR /
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s -w' -o haproxy-init


FROM quay.io/kubernetes-ingress-controller/debian-base-amd64:0.1

RUN clean-install \
  bash \
  curl \
  socat \
  haproxy \
  ca-certificates \
  liblua5.3-0 \
  dumb-init

RUN mkdir -p /etc/haproxy/errors /var/state/haproxy /run/haproxy
RUN for ERROR_CODE in 400 403 404 408 500 502 503 504;do curl -sSL -o /etc/haproxy/errors/$ERROR_CODE.http \
	https://raw.githubusercontent.com/haproxy/haproxy-1.5/master/examples/errorfiles/$ERROR_CODE.http;done

COPY --from=builder /haproxy-init /
ADD haproxy_reload /

RUN touch /var/run/haproxy.pid

ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["/haproxy-init"]
