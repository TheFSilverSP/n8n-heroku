FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=0.171.0

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata
RUN apk --update add fontconfig pango-dev libxcursor libxdamage cups-libs dbus-libs libxrandr libxscrnsaver libc6-compat 
RUN apk update && apk add libnss3 libnssutil3 libsmime3 libnspr4 libatk-1.0 libatk-bridge-2.0 libdrm libxkbcommon libXcomposite libgbm libasound libatspi ld-linux-x86-64

# Set a custom user to not have n8n run as root
USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base && \
	npm_config_user=root npm install -g n8n@${N8N_VERSION} lodash puppeteer browserless && \
	apk del build-dependencies

# Specifying work directory
WORKDIR /data

# copy start script to container
COPY ./start.sh /

# make the script executable
RUN chmod +x /start.sh

# define execution entrypoint
CMD ["/start.sh"]
