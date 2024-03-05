# Kurtosis CDK-Erigon Node

This is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis) package that will spin up a CDK-Erigon node, optimized for syncing with the Polygon Hermez zkEVM network. The package is designed to be used for testing, validation and development of the [cdk-erigon](https://github.com/0xPolygonHermez/cdk-erigon) client. It is not intended for production use.

## Commands

Deploy a local CDK-Erigon node.

```bash
$ kurtosis clean -a && kurtosis run --enclave cdk-erigon .
INFO[2024-03-05T11:41:59+01:00] Cleaning old Kurtosis engine containers...
INFO[2024-03-05T11:41:59+01:00] Successfully cleaned old Kurtosis engine containers
INFO[2024-03-05T11:41:59+01:00] Cleaning enclaves...
INFO[2024-03-05T11:41:59+01:00] Successfully removed the following enclaves:
c59e49e1992d4dd7aee2bd9bf475c95c	cdk-erigon
INFO[2024-03-05T11:41:59+01:00] Successfully cleaned enclaves
INFO[2024-03-05T11:41:59+01:00] Cleaning unused images...
INFO[2024-03-05T11:41:59+01:00] Successfully cleaned unused images
INFO[2024-03-05T11:41:59+01:00] Creating a new enclave for Starlark to run inside...
INFO[2024-03-05T11:42:00+01:00] Enclave 'cdk-erigon' created successfully
INFO[2024-03-05T11:42:00+01:00] Executing Starlark package at '/Users/leovct/Documents/work/infra/kurtosis-cdk-erigon-node' as the passed argument '.' looks like a directory
INFO[2024-03-05T11:42:00+01:00] Compressing package 'github.com/leovct/kurtosis-cdk-erigon-node' at '.' for upload
INFO[2024-03-05T11:42:00+01:00] Uploading and executing package 'github.com/leovct/kurtosis-cdk-erigon-node'

Container images used in this run:
> cdk-erigon - locally built

Adding service with name 'cdk-erigon-node' and image 'cdk-erigon'
Service 'cdk-erigon-node' added with service UUID '6252397ca95a4d58bc7710a325704132'

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

Check the logs.

```bash
$ kurtosis service logs cdk-erigon cdk-erigon-node --all --follow
[INFO] [03-05|10:42:03.965] logging to file system                   log dir=/root/.local/share/erigon/logs file prefix=erigon log level=info json=false
[INFO] [03-05|10:42:03.976] Build info                               git_branch=zkevm git_tag=v0.0.3-alpha-4-gbc50d2dd1f git_commit=bc50d2dd1f413e15d0eb1213f9fb63ccbe5e077a
[INFO] [03-05|10:42:03.976] Poseidon hashing                         Accelerated=true
[INFO] [03-05|10:42:03.976] Starting Erigon on                       devnet=hermez-cardona-internal
[INFO] [03-05|10:42:03.977] Maximum peer count                       ETH=0 total=0
[INFO] [03-05|10:42:03.977] starting HTTP APIs                       APIs=eth,debug,net,trace,web3,erigon,zkevm
[INFO] [03-05|10:42:03.977] torrent verbosity                        level=WRN
[INFO] [03-05|10:42:06.080] Set global gas cap                       cap=50000000
[INFO] [03-05|10:42:06.081] [Downloader] Runnning with               ipv6-enabled=true ipv4-enabled=true download.rate=16mb upload.rate=4mb
[INFO] [03-05|10:42:06.081] Opening Database                         label=chaindata path=/root/Documents/work/clients/cdk-erigon/tmp2/chaindata
[INFO] [03-05|10:42:06.085] Re-Opening DB in exclusive mode to apply migrations
[INFO] [03-05|10:42:06.087] Apply migration                          name=db_schema_version5
[INFO] [03-05|10:42:06.088] Applied migration                        name=db_schema_version5
[INFO] [03-05|10:42:06.088] Apply migration                          name=txs_begin_end
[INFO] [03-05|10:42:06.089] Applied migration                        name=txs_begin_end
[INFO] [03-05|10:42:06.089] Apply migration                          name=reset_blocks_4
[INFO] [03-05|10:42:06.090] Applied migration                        name=reset_blocks_4
[INFO] [03-05|10:42:06.091] Updated DB schema to                     version=6.0.0
[INFO] [03-05|10:42:06.132] Writing custom genesis block             hash=0xe65e09471025d299d0fd5b57e9ae325ecf16037cbd2f456db435b6bb1369154d
[INFO] [03-05|10:42:06.133] Initialised chain configuration          config="{ChainID: 2440, Homestead: 0, DAO: 0, Tangerine Whistle: 0, Spurious Dragon: 0, Byzantium: 0, Constantinople: 0, Petersburg: 0, Istanbul: 0, Muir Glacier: 0, Berlin: 0, London: 9999999999999999999999999999999999999999999999999, Arrow Glacier: 9999999999999999999999999999999999999999999999999, Gray Glacier: 9999999999999999999999999999999999999999999999999, Terminal Total Difficulty: 58750000000000000000000, Merge Netsplit: <nil>, Shanghai: 9999999999999999999999999999999999999999999999999, Cancun: 9999999999999999999999999999999999999999999999999, Prague: 9999999999999999999999999999999999999999999999999, Engine: ethash}" genesis=0xe65e09471025d299d0fd5b57e9ae325ecf16037cbd2f456db435b6bb1369154d
[INFO] [03-05|10:42:06.133] Effective                                prune_flags= snapshot_flags= history.v3=false
[INFO] [03-05|10:42:06.139] Initialising Ethereum protocol           network=2440
[INFO] [03-05|10:42:06.139] Disk storage enabled for ethash DAGs     dir=/root/Documents/work/clients/cdk-erigon/tmp2/ethash-dags count=2
[INFO] [03-05|10:42:06.140] Starting private RPC server              on=localhost:9092
[INFO] [03-05|10:42:06.140] new subscription to logs established
[INFO] [03-05|10:42:06.141] Starting datastream client...
[INFO] [03-05|10:42:06.195] Datastream client initialized...
[INFO] [03-05|10:42:06.197] rpc filters: subscribing to Erigon events
[INFO] [03-05|10:42:06.197] new subscription to newHeaders established
[INFO] [03-05|10:42:06.198] Reading JWT secret                       path=/root/Documents/work/clients/cdk-erigon/tmp2/jwt.hex
[INFO] [03-05|10:42:06.198] Generated JWT secret                     path=/root/Documents/work/clients/cdk-erigon/tmp2/jwt.hex
[INFO] [03-05|10:42:06.200] HTTP endpoint opened for Engine API      url=127.0.0.1:8551 ws=true ws.compression=true
[INFO] [03-05|10:42:06.200] HTTP endpoint opened                     url=[::]:8545 ws=false ws.compression=true grpc=false
[INFO] [03-05|10:42:06.204] Started P2P networking                   version=68 self=enode://6936c4d21035f27e1855cfe833cb093351b13da174544df15bc2d1ee96666b7881c9579828f6a3dc09ca6e2b07b0869b78e3cb565dd569c94d941be6fc4e62c2@127.0.0.1:0 name=erigon/v2.43.0-dev-bc50d2dd/linux-arm64/go1.19.13
[INFO] [03-05|10:42:06.206] Started P2P networking                   version=67 self=enode://6936c4d21035f27e1855cfe833cb093351b13da174544df15bc2d1ee96666b7881c9579828f6a3dc09ca6e2b07b0869b78e3cb565dd569c94d941be6fc4e62c2@127.0.0.1:0 name=erigon/v2.43.0-dev-bc50d2dd/linux-arm64/go1.19.13
[INFO] [03-05|10:42:06.208] [1/15 L1Syncer] Starting L1 sync stage
...
```

Connect to the node.

```bash
$ kurtosis service shell cdk-erigon cdk-erigon-node
```

Monitor the node.

```bash
$ polycli monitor --rpc-url http://127.0.0.1:50169
```
