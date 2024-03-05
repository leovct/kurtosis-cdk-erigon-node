FROM golang:1.19 as builder
WORKDIR /opt/cdk-erigon
RUN git clone --branch zkevm https://github.com/0xPolygonHermez/cdk-erigon . \
  && make cdk-erigon

FROM debian:bookworm-slim
LABEL author="devtools@polygon.technology"
LABEL description="CDK-Erigon builder"
COPY --from=builder /opt/cdk-erigon/build/bin/cdk-erigon /usr/local/bin/cdk-erigon
CMD ["cdk-erigon"]
