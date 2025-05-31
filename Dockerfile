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

RUN curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install ngrok
RUN ngrok config add-authtoken 2x2On2r9mfo5WTrl6OQJiMvi3xY_7SfeNm4NS24qEwKErpMB6

# Expose a fake web port to trick Railway into keeping container alive
EXPOSE 8080

# Start a dummy Python web server to keep Railway service active
# and start tmate session
CMD python3 -m http.server 8080 & \
    ngrok http 8080
