FROM debian:12

# Install dependencies
RUN apt update && apt install software-properties-common wget curl git openssh-client tmate python3 sudo neofetch -y && apt clean
RUN curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash
RUN curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py
RUN chmod -R 777 /bin/systemctl
RUN apt install pufferpanel
RUN sed -i "s/\"host\": \"0.0.0.0:8080\"/\"host\": \"0.0.0.0:$pufferPanelPort\"/g" /etc/pufferpanel/config.json
RUN pufferpanel user add --name "ServerTipacVN" --password "svtipacvn" --email "admin@svtipacvn" --admin
RUN systemctl restart pufferpanel
RUN echo "Ok"
# page to keep the service alive

# Expose a fake web port to trick Railway into keeping container alive
EXPOSE 8080

# Start a dummy Python web server to keep Railway service active
# and start tmate session
CMD python3 -m http.server 8080
