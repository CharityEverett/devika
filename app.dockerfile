FROM debian:12

# setting up build variable
ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

# setting up os env
USER root
WORKDIR /home/nonroot/client
RUN groupadd -r nonroot && useradd -r -g nonroot -d /home/nonroot/client -s /bin/bash nonroot

# Install Node.js
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl software-properties-common
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Verify installation
RUN node --version
RUN npm --version

# copying devika app client only
COPY ui /home/nonroot/client/ui
COPY src /home/nonroot/client/src
COPY config.toml /home/nonroot/client/

RUN cd ui && npm install && npm install -g npm && npm install -g bun
RUN chown -R nonroot:nonroot /home/nonroot/client

USER nonroot
WORKDIR /home/nonroot/client/ui

ENTRYPOINT [ "npx", "bun", "run", "dev", "--", "--host" ]
