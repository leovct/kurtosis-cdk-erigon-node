blockscout = import_module("github.com/leovct/kurtosis-blockscout/main.star")


def run(
    plan,
    cdk_erigon_version="zkevm",
    chain="cardona",
    datadir="/var/lib/cdk-erigon",
    zkevm_rpc_rate_limit=250,
    zkevm_data_stream_version=2,
    zkevm_l1_block_range=20000,
    zkevm_l1_query_delay=6000,
    zkevm_l1_first_block=4794475,
    persistent=True,
    deploy_blockscout=False,
):
    # Start the CDK-Erigon node.
    config = generate_config(
        plan,
        chain,
        datadir,
        zkevm_rpc_rate_limit,
        zkevm_data_stream_version,
        zkevm_l1_block_range,
        zkevm_l1_query_delay,
        zkevm_l1_first_block,
    )
    rpc_http_url = start_node(plan, cdk_erigon_version, config, persistent, datadir)

    # Start a blockchain explorer if needed.
    if deploy_blockscout:
        blockscout.run(plan, rpc_http_url)


def start_node(plan, cdk_erigon_version, config, persistent, datadir):
    """
    Start a CDK-Erigon node.

    Args:
        config (file): Configuration file.
        persistent (boolean): Wether the data should be persisted.
        datadir (string): The directory where chain data will be stored.

    Returns:
        The JSON-RPC HTTP URL of the node.
    """
    files = {}
    files["/etc/cdk-erigon"] = config
    if persistent:
        files[datadir] = Directory(persistent_key="cdk-erigon-node-data")

    service = plan.add_service(
        name="cdk-erigon-node",
        config=ServiceConfig(
            image=ImageBuildSpec(
                image_name="cdk-erigon",
                build_context_dir=".",
                build_args={
                    "CDK_ERIGON_VERSION": cdk_erigon_version,
                },
            ),
            files=files,
            ports={"http_rpc": PortSpec(8545, application_protocol="http")},
            cmd=["--config=/etc/cdk-erigon/config.yaml", "--maxpeers=0"],
        ),
    )
    return "http://{hostname}:8545".format(hostname=service.ip_address)


def generate_config(
    plan,
    chain,
    datadir,
    zkevm_rpc_rate_limit,
    zkevm_data_stream_version,
    zkevm_l1_block_range,
    zkevm_l1_query_delay,
    zkevm_l1_first_block,
):
    """
    Generate CDK-Erigon node configuration file.

    It generates/loads a bunch of configuration files:
    - User config (see `config/user.yaml`).
    - Common config (see `config/user.yaml`).
    - Network-specific config (see `config/networks/`).
    Then the configuration files are aggregated into a final configuration file.

    Args:
        chain (string):  The name of the chain.
        datadir (string): The directory where chain data will be stored.
        zkevm_rpc_rate_limit (int): The RPC rate limit in requests per second.
        zkevm_data_stream_version (int): The stream version indicator (1: PreBigEndian, 2: BigEndian) of the zkEVM data stream.
        zkevm_l1_block_range (int): The block range used to filter verifications and sequences on L1.
        zkevm_l1_query_delay (int): The delay (in ms) between queries for verifications and sequences on L1.
        zkevm_l1_first_block (int): The first block to start syncing from on L1.

    Returns:
        The configuration file.
    """
    # Generate the user configuration file.
    user_config_template = read_file("./config/user.yaml")
    user_config_template_data = {
        "DATADIR": datadir,
        "ZKEVM_RPC_RATE_LIMIT": zkevm_rpc_rate_limit,
        "ZKEVM_DATASTREAM_VERSION": zkevm_data_stream_version,
        "ZKEVM_L1_BLOCK_RANGE": zkevm_l1_block_range,
        "ZKEVM_L1_QUERY_DELAY": zkevm_l1_query_delay,
        "ZKEVM_L1_FIRST_BLOCK": zkevm_l1_first_block,
    }
    user_config = plan.render_templates(
        config={
            "user_config.yaml": struct(
                template=user_config_template,
                data=user_config_template_data,
            ),
        },
        name="cdk-erigon-user-config",
    )

    # Load the common and network-specific configuration files.
    common_config_content = read_file("./config/common.yaml")
    network_config_content = read_file("./config/networks/{}.yaml".format(chain))

    # Generate the final configuration file.
    result = plan.run_sh(
        run='cd /etc/cdk-erigon \
            && mkdir config \
            && cat user_config.yaml > config/config.yaml \
            && echo "{}" > common_config.yaml \
            && cat common_config.yaml >> config/config.yaml \
            && echo "" >> config/config.yaml \
            && echo "{}" > network_config.yaml \
            && cat network_config.yaml >> config/config.yaml'.format(
            common_config_content, network_config_content
        ),
        files={
            "/etc/cdk-erigon": user_config,
        },
        store=[
            StoreSpec(src="/etc/cdk-erigon/config/*", name="cdk-erigon-final-config")
        ],
    )
    return result.files_artifacts[0]
