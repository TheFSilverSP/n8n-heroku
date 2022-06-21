FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=0.183.0

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata chromium tor && \
    apk add --no-cache bash git openssh

# Set puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set a custom user to not have n8n run as root
USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base && \
	npm_config_user=root npm install --location=global npm@8.12.2 n8n@${N8N_VERSION} browserless puppeteer lodash && \
	apk del build-dependencies

# Install puppeteer extra plugins
RUN npm_config_user=root npm install --location=global puppeteer-extra puppeteer-extra-plugin-stealth
RUN npm_config_user=root npm install --location=global puppeteer-extra-plugin-user-preferences puppeteer-extra-plugin-user-data-dir 

# Tor Setup
RUN mkdir -p /hidden_service && chmod 700 /hidden_service
RUN touch /hidden_service/torrc
RUN echo "HiddenServiceDir /hidden_service" >> /hidden_service/torrc
RUN echo "HiddenServicePort 9050 127.0.0.1:9050" >> /hidden_service/torrc


# Specifying work directory
WORKDIR /data

# copy start script to container
COPY ./start.sh /

# make the script executable
RUN chmod +x /start.sh

# define execution entrypoint
CMD ["/start.sh"]
