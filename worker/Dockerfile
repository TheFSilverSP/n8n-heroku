FROM node:lts-alpine

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata tor

# Set a custom user to not have n8n run as root
USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base

RUN mkdir -p /hidden_service && chmod 700 /hidden_service
RUN touch /hidden_service/torrc
RUN echo "HiddenServiceDir /hidden_service" >> /hidden_service/torrc
RUN echo "HiddenServicePort 9050 127.0.0.1:9050" >> /hidden_service/torrc

# define execution entrypoint
CMD ["tor -f /hidden_service/torrc"]
