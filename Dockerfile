FROM node:24-alpine
RUN apk add --no-cache bash
ENV SHELL=/bin/bash
RUN npm install -g @google/gemini-cli@latest
# Setup proper user
RUN addgroup -g 1234 gemini && \
    adduser -u 1234 -G gemini -s /bin/sh -D gemini
# Provide OAuth credentials
COPY credentials/ /home/gemini/
# Required for credentials to be uptaken
RUN chown -R gemini:gemini /home/gemini/
WORKDIR /home/gemini/project
USER gemini
ENTRYPOINT ["gemini"]
