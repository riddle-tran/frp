FROM golang:1.23 AS builder

COPY . /building
WORKDIR /building

RUN make frpc

RUN make frps

FROM alpine:latest as frps

COPY --from=builder /building/bin/frps /usr/bin/frps
COPY --from=builder /building/conf/frps.toml /etc/frp/frps.toml

ENTRYPOINT ["/usr/bin/frps"]
CMD ["-c", "/etc/frp/frps.toml"]
EXPOSE 7000
EXPOSE 7500


FROM alpine:latest as frpc
COPY --from=builder /building/bin/frpc /usr/bin/frpc
COPY --from=builder /building/conf/frpc.toml /etc/frp/frpc.toml

ENTRYPOINT ["/usr/bin/frpc"]
CMD ["-c", "/etc/frp/frpc.toml"]

