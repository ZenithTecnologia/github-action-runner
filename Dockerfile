FROM debian:stable-slim

# set the github runner version
ARG RUNNER_VERSION="2.285.1"

WORKDIR /gh-action-runner

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip tini apt-transport-https ca-certificates gnupg2 software-properties-common

# Docker itself
RUN curl -sSL https://get.docker.com/ | sh

# cd into the user directory, download and unzip the github actions runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN ./bin/installdependencies.sh

# copy over the start.sh script
COPY --chmod=0755 start.sh start.sh

# set the entrypoint to the start.sh script
ENTRYPOINT ["tini", "-s", "-g", "--", "./start.sh"]
