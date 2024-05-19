FROM debian:12.1
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
    ca-certificates \
    podman \
    buildah \
    cmake \
    ruby-full \
    ruby-dev \
    libssl-dev \
    pkg-config

# Helm CLI
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list

# Kubernetes repo
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Docker CLI stuff.
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

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
    google-cloud-sdk \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin

# Install golang.
RUN wget -c https://golang.org/dl/go1.22.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz

ENV GOPATH /home/go
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH:

# Install pnpm
RUN npm install -g pnpm @sentry/cli
