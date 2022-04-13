FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=0.172.0

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata chromium nss freetype harfbuzz ca-certificates ttf-freefont yarn

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
	PUPPETEER_EXECUTABLE_PATH=/usr/local/lib/node_modules/chromium/lib/chromium/chrome-linux/chrome

RUN yarn add puppeteer@13.4.1

RUN mkdir -p /home/root/Downloads /app /usr/local/lib/node_modules/chromium && \
    chown -R root:root /home/root && \
    chown -R root:root /app && \
    chown -R root:root /usr/local/lib/node_modules/chromium

# Set a custom user to not have n8n run as root
USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base && \
	npm_config_user=root npm install -g n8n@${N8N_VERSION} browserless lodash && \
	apk del build-dependencies

# Specifying work directory
WORKDIR /data

# copy start script to container
COPY ./start.sh /

# make the script executable
RUN chmod +x /start.sh

# define execution entrypoint
CMD ["/start.sh"]
