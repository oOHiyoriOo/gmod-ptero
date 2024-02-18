# Use the edge version of Alpine Linux as the base image
FROM ubuntu:22.04

# Avoid prompts from apt during build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    iproute2 \
    gdb \
    && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y libc6:i386 libstdc++6:i386

# Add the SteamCMD installation layer
RUN adduser --disabled-password --home /home/container container

# Copy the provided entrypoint.sh script into the image
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to user 'container' to avoid using root for the server process
USER container
ENV USER=container HOME=/home/container

# Set the working directory to /home/container
WORKDIR /home/container

# Use the provided entrypoint to start the server
CMD ["/bin/bash", "/entrypoint.sh"]
