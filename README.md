# Kurtosis CDK-Erigon Node

This is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package that will spin up a CDK-Erigon node, optimized for syncing with any Polygon Hermez zkEVM network. The package is designed to be used for testing, validation and development of the [cdk-erigon](https://github.com/0xPolygonHermez/cdk-erigon) client. It is not intended for production use.

## Table of Contents

- [Quickstart](#quickstart)
  - [Deploy a Node](#deploy-a-node)
  - [Node Integrity Check](#node-integrity-check)
  - [Configure your Node](#configure-your-node)
  - [Add a New Network](#add-a-new-network)
- [Supported Networks](#supported-networks)

## Quickstart

> 🚨 Make sure you have [Docker](https://www.docker.com/) and [Kurtosis](https://docs.kurtosis.com/install) installed.

### Deploy a Node

```bash
# Deploy a local CDK-Erigon mainnet node.
$ kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node
# Equivalent to: kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node '{chain: mainnet}'

# Alternatively, deploy nodes for other networks.
$ kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node '{chain: cardona}'
$ kurtosis run --enclave cdk-erigon github.com/leovct/kurtosis-cdk-erigon-node '{chain: bali}'
```

The list of networks currently supported is available [here](#supported-networks).

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

Finally, to monitor the node, you can use [polycli](https://github.com/maticnetwork/polygon-cli).

```bash
$ polycli monitor --rpc-url http://127.0.0.1:50169
```

### Node Integrity Check

Here are quick steps to ensure your node is synced and working correctly. For this example, we will sync against the Bali Testnet.


First, verify your node sync status.

```bash
$ curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' http://127.0.0.1:50169
{"jsonrpc":"2.0","id":1,"result":false}
```

Second, retrieve the latest block number (e.g. from the local node).

```bash
$ cast bn --rpc-url http://127.0.0.1:50169
1285203
```

Third and finally, compare state roots of local node RPC and sequencer RPC URLs for the latest block. They should match!

```bash
$ cast block 1285203 --rpc-url http://127.0.0.1:50169 --json | jq -r .stateRoot
0x54ee9fed29133351f1f49259ab47021fd06816210e1b16d0402de042ffb16e50

$ cast block 1285203 --rpc-url https://rpc.internal.zkevm-rpc.com --json | jq -r .stateRoot
0x54ee9fed29133351f1f49259ab47021fd06816210e1b16d0402de042ffb16e50
```

### Configure your Node

To tailor your CDK-Erigon node according to your specific needs, explore and adjust the default configuration file (`config.yaml`). This file encompasses crucial parameters such as the target blockchain, zkEVM configurations, and L1 query parameters like block range, query delay, and the initial block for L1 synchronization. Feel free to customize these values and initiate your personalized node.

Here's a step-by-step guide:

1. Clone the repository.

```bash
$ git clone https://github.com/leovct/kurtosis-cdk-erigon-node.git
$ cd kurtosis-cdk-erigon-node
```

2. Edit the configuration.

```bash
$ vi config.yaml
```

3. Start the node with your custom parameters.

```bash
$ kurtosis run --enclave cdk-erigon --args-file config.yaml .
```

Note: The current version of the CDK-Erigon node is based on the [`zkevm`](https://github.com/0xPolygonHermez/cdk-erigon/tree/zkevm) branch. As soon as Kurtosis supports build-time variables in the Dockerfile (refer to this [issue](https://github.com/kurtosis-tech/kurtosis/issues/2214)), we will be able to pass the CDK-Erigon node version as a configuration parameter in `config.yaml`. This enhancement will provide greater flexibility and ease of configuration for testing CDK-Erigon node versions.

### Add a New Network

Enhance the versatility of this Kurtosis package by seamlessly integrating a new network.

1. Navigate to the `config/network` directory.

```bash
$ cd config/networks
```

2. Add your own network configuration. For instance, refer to the existing mainnet configuration file (`config/networks/mainnet.yaml`) as a template.

```bash
$ vi my-network.yaml
```

Note that certain parameters are shared among all CDK-Erigon nodes and are stored in a separate file (`config/common.yaml`). This modular approach ensures the simplicity and readability of configurations.

3. Adjust the `chain` parameter, in the configuration file (`config.yaml`), to match your network file name (here, it would be `my-network`).

4. Start the node for your new network.

```bash
$ kurtosis run --enclave cdk-erigon --args-file config.yaml .
```

## Supported Networks

Here is the list of networks currently supported. If you wish to add a new one, visit this [section](#add-a-new-network).

| Network               | Rootchain                | Configuration File                |
| --------------------- | ------------------------ | --------------------------------- |
| zkEVM Mainnet         | Ethereum Mainnet         | `config/networks/mainnet.yaml`    |
| zkEVM Etrog Testnet   | Ethereum Sepolia Testnet | `config/networks/etrog.yaml`      |
| zkEVM Cardona Testnet | Ethereum Sepolia Testnet | `config/networks/cardona.yaml`    |
| zkEVM Bali Testnet    | Ethereum Sepolia Testnet | `config/networks/bali.yaml`       |
| X1 Testnet            | Ethereum Sepolia Testnet | `config/networks/x1-testnet.yaml` |
