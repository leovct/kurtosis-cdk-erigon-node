# Kurtosis CDK-Erigon Node

This is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package that will spin up a CDK-Erigon node, optimized for syncing with the Polygon Hermez zkEVM network. The package is designed to be used for testing, validation and development of the [cdk-erigon](https://github.com/0xPolygonHermez/cdk-erigon) client. It is not intended for production use.

## Table of Contents

- [Quickstart](#quickstart)
  - [Deploy a Node](#deploy-a-node)
  - [Configure your Node](#configure-your-node)
  - [Add a New Network](#add-a-new-network)

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

### Configure your Node

To tailor your CDK-Erigon node according to your specific needs, explore and adjust the default [configuration](./config.yaml) file. This file encompasses crucial parameters such as the target blockchain, zkevm configurations, and L1 query parameters like block range, query delay, and the initial block for L1 synchronization.

Feel free to customize these values and initiate your personalized node. Here's a step-by-step guide:

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
$ kurtosis run --enclave cdk-erigon --args-file ./config.yaml .
```

### Add a New Network

Enhance the versatility of this Kurtosis package by seamlessly integrating a new network.

1. Navigate to the `config/network` directory.

```bash
$ cd config/network
```

2. Add your own network configuration. For instance, refer to the existing mainnet configuration [file](./config/network/mainnet.yaml) as a template.

```bash
$ vi my-network.yaml
```

Note that certain parameters are shared among all CDK-Erigon nodes and are stored in a separate [file](./config/common.yaml). This modular approach ensures the simplicity and readability of configurations.

3. Adjust the `chain` parameter, in the configuration file (`./config.yaml`), to match your network file name (here, it would be `my-network`).

4. Start the node for your new network.

```bash
$ kurtosis run --enclave cdk-erigon --args-file ./config.yaml .
```
