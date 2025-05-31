FROM debian:12

# Install dependencies
RUN apt update && apt install software-properties-common wget curl git openssh-client tmate python3 sudo neofetch -y && \
curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | sudo bash && sudo apt-get install pufferpanel && sudo systemctl enable pufferpanel && \
sudo pufferpanel user add --email admin@servertipacvn --name ServerTipacVN --password svtipacvn --admin && sudo systemctl enable --now pufferpanel && \
apt clean
# Create a dummy index page to keep the service alive

# Expose a fake web port to trick Railway into keeping container alive
EXPOSE 8080

# Start a dummy Python web server to keep Railway service active
# and start tmate session
CMD python3 -m http.server 8080 & \
    tmate -F
