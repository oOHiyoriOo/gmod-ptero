# Use the edge version of Alpine Linux as the base image
FROM alpine:edge

# Install dependencies necessary for SteamCMD and Garry's Mod
RUN apk add --no-cache \
    libc6-compat \
    libstdc++ \
    ca-certificates \
    curl

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

# Download and extract SteamCMD
RUN mkdir -p /home/container/steamcmd && \
    curl -sSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /home/container/steamcmd

# i think this is managed by pterodactyl
# Expose ports (default GMod ports and any additional ones you need)
#EXPOSE 27015/udp 27015/tcp 27005/udp 27005/tcp

# Use the provided entrypoint to start the server
CMD ["/bin/ash", "/entrypoint.sh"]
