FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential curl git libicu-dev lsb-release

COPY --from=docker:24.0-cli /usr/local/bin/docker /usr/local/bin/

RUN mkdir -p /usr/local/lib/docker/cli-plugins && \
	curl -SL https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose && \
	chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

WORKDIR /root
VOLUME [ "/root/actions-runner/_work/" ]

RUN mkdir -p /root/actions-runner && cd actions-runner && \
    curl -o actions-runner-linux-x64-2.310.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.310.2/actions-runner-linux-x64-2.310.2.tar.gz &&\
    echo "fb28a1c3715e0a6c5051af0e6eeff9c255009e2eec6fb08bc2708277fbb49f93  actions-runner-linux-x64-2.310.2.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-x64-2.310.2.tar.gz && rm ./actions-runner-linux-x64-2.310.2.tar.gz


COPY entrypoint.sh /home/runner/

ENTRYPOINT [ "/home/runner/entrypoint.sh" ]
