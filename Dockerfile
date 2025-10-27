FROM --platform=${BUILDPLATFORM} alpine:3.20.3 AS alpine
RUN apk add -U --no-cache ca-certificates

# Image starts here
FROM scratch
ARG TARGETPLATFORM
LABEL maintainer="Hector <hector@email.gnx>"

EXPOSE 80 443 2019
ENV XDG_CONFIG_HOME=config
ENV XDG_DATA_HOME=data

COPY go.mod go.sum ./
RUN go mod download

COPY . .
ARG TARGETOS TARGETARCH TARGETVARIANT
RUN \
  if [ "${TARGETARCH}" = "arm" ] && [ -n "${TARGETVARIANT}" ]; then \
  export GOARM="${TARGETVARIANT#v}"; \
  fi; \
  GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -v ./cmd/caddy

# From https://github.com/caddyserver/caddy-docker/blob/master/2.10/alpine/Dockerfile
FROM alpine:3.21

RUN mkdir -p \
  /config/caddy \
  /data/caddy \
  /etc/caddy \
  /usr/share/caddy

COPY --from=build /work/caddy /usr/bin/caddy
COPY --from=build tsconfig/simple.caddyfile /etc/caddy/Caddyfile

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["run", "--config", "/etc/caddy/Caddyfile"]
ENTRYPOINT ["caddy"]
