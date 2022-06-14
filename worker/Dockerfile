FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=0.181.2

# Update everything and install needed dependencies
RUN apk add --update tor

# Set a custom user to not have n8n run as root
USER root

RUN mkdir -p /hidden_service && chmod 700 /hidden_service
RUN touch /hidden_service/torrc
RUN echo "HiddenServiceDir /hidden_service" >> /hidden_service/torrc
RUN echo "HiddenServicePort 9050 127.0.0.1:$PORT" >> /hidden_service/torrc

# Specifying work directory
WORKDIR /data

# copy start script to container
COPY ./torstart.sh /

# make the script executable
RUN chmod +x /torstart.sh

# define execution entrypoint
CMD /torstart.sh --bind localhost:$PORT
