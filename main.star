def run(plan):
    plan.add_service(
        name="cdk-erigon-node",
        config=ServiceConfig(
            image=ImageBuildSpec(image_name="cdk-erigon", build_context_dir="."),
            ports={"http_rpc": PortSpec(8545, application_protocol="http")},
        ),
    )
