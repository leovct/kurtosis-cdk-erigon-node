FROM golang:1.19 as builder
WORKDIR /opt/cdk-erigon
RUN git clone --branch zkevm https://github.com/0xPolygonHermez/cdk-erigon . \
  && make cdk-erigon

FROM debian:bookworm-slim
LABEL author="devtools@polygon.technology"
LABEL description="CDK-Erigon binary builder"
COPY --from=builder /opt/cdk-erigon/build/bin/cdk-erigon /usr/local/bin/cdk-erigon
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["cdk-erigon"]
