def run(
    plan,
    chain,
    datadir="/var/lib/cdk-erigon",
    zkevm_rpc_rate_limit=250,
    zkevm_data_stream_version=2,
    zkevm_l1_block_range=20000,
    zkevm_l1_query_delay=6000,
    zkevm_l1_first_block=4794475,
):
    config = create_cdk_erigon_node_config(
        plan,
        chain,
        datadir,
        zkevm_rpc_rate_limit,
        zkevm_data_stream_version,
        zkevm_l1_block_range,
        zkevm_l1_query_delay,
        zkevm_l1_first_block,
    )
    start_cdk_erigon_node(plan, config)


def create_cdk_erigon_node_config(
    plan,
    chain,
    datadir,
    zkevm_rpc_rate_limit,
    zkevm_data_stream_version,
    zkevm_l1_block_range,
    zkevm_l1_query_delay,
    zkevm_l1_first_block,
):
    # Create the user configuration file.
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

    # Create the final configuration file.
    common_config_content = read_file("./config/common.yaml")
    network_config_content = read_file("./config/network/{}.yaml".format(chain))
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


def start_cdk_erigon_node(plan, config):
    plan.add_service(
        name="cdk-erigon-node",
        config=ServiceConfig(
            image=ImageBuildSpec(image_name="cdk-erigon", build_context_dir="."),
            files={"/etc/cdk-erigon": config},
            ports={"http_rpc": PortSpec(8545, application_protocol="http")},
            cmd=["--config=/etc/cdk-erigon/config.yaml", "--maxpeers=0"],
        ),
    )
