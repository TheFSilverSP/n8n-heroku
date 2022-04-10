FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=0.171.0

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata
RUN apk --update add chromium alsa-lib at-spi2-atk at-spi2-core atk cairo cups-libs dbus-libs eudev-libs expat ffmpeg-libs flac fontconfig freetype glib gtk+3.0 harfbuzz lcms2 libatomic libdrm libevent libgcc libjpeg-turbo libpng libpulse libstdc++ libwebp libx11 libxcb libxcomposite libxdamage libxext libxfixes libxkbcommon libxml2 libxrandr libxslt mesa-gbm mkfontscale musl nspr nss opus pango re2 snappy wayland-libs-client xdg-utils zlib ca-certificates ttf-freefont pango-dev libxcursor libxscrnsaver libc6-compat gcompat libxshmfence

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
