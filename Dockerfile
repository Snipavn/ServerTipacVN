FROM debian:12

# Install dependencies
RUN apt update && apt install software-properties-common wget curl git openssh-client tmate python3 sudo neofetch -y && apt clean

# page to keep the service alive

# Expose a fake web port to trick Railway into keeping container alive
EXPOSE 8080

# Start a dummy Python web server to keep Railway service active
# and start tmate session
CMD python3 -m http.server 8080 & \
    tmate -F
