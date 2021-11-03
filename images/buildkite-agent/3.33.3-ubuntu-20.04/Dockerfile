FROM buildkite/agent:3.33.3-ubuntu-20.04
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
    make

# Install golang.
RUN wget -c https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xvzf go1.17.1.linux-amd64.tar.gz

ENV GOPATH /home/go
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH:
