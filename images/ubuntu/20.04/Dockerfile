FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    build-essential \
    wget \
    postgresql-client

# Install node.
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs

# Install golang.
RUN wget -c https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xvzf go1.16.3.linux-amd64.tar.gz