# Kurtosis CDK-Erigon Node

This is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package that will spin up a CDK-Erigon node, optimized for syncing with the Polygon Hermez zkEVM network. The package is designed to be used for testing, validation and development of the [cdk-erigon](https://github.com/0xPolygonHermez/cdk-erigon) client. It is not intended for production use.

## Quickstart

### Deploy a Node

```bash
# Deploy a local CDK-Erigon mainnet node.
$ kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node
# Equivalent to: kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node '{chain: mainnet}'

# Alternatively, deploy nodes for other networks.
$ kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node '{chain: cardona}'
$ kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node '{chain: bali}'
```

Once the command is executed, observe the output, especially the exposed port (here, 50169), which corresponds to the HTTP-RPC server of the CDK-Erigon node.

```bash
...
Starlark code successfully run. No output was returned.

Made with Kurtosis - https://kurtosis.com
INFO[2024-03-05T11:42:06+01:00] ===================================================
INFO[2024-03-05T11:42:06+01:00] ||          Created enclave: cdk-erigon          ||
INFO[2024-03-05T11:42:06+01:00] ===================================================
Name:            cdk-erigon
UUID:            86dd2080720e
Status:          RUNNING
Creation Time:   Tue, 05 Mar 2024 11:42:00 CET
Flags:

========================================= Files Artifacts =========================================
UUID   Name

========================================== User Services ==========================================
UUID           Name              Ports                                          Status
6252397ca95a   cdk-erigon-node   http_rpc: 8545/tcp -> http://127.0.0.1:50169   RUNNING
```

Explore logs with:

```bash
$ kurtosis service logs cdk-erigon cdk-erigon-node --all --follow
```

Connect to the node:

```bash
$ kurtosis service shell cdk-erigon cdk-erigon-node
```

Finnally, to monitor the node, you can use [polycli](https://github.com/maticnetwork/polygon-cli).

```bash
$ polycli monitor --rpc-url http://127.0.0.1:50169
```
