FROM buildkite/agent:3.40.0-ubuntu-20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    build-essential \
    wget \
    postgresql-client \
    git \
    rsync \
    make \
    rsync \
    gcc \
    g++ \
    apt-transport-https \
    ca-certificates

# Helm CLI
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list

# Kubernetes repo
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
    apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Google Cloud SDK stuff
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add -

# Install node repos.
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

RUN apt-get update -y && \
    apt-get install -y \
    nodejs \
    kubectl \
    helm \
    google-cloud-sdk

# Install golang.
RUN wget -c https://golang.org/dl/go1.19.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xvzf go1.19.1.linux-amd64.tar.gz

ENV GOPATH /home/go
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH:

# Install yarn
RUN npm install -g yarn @sentry/cli
