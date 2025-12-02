FROM node:24-alpine
RUN apk add --no-cache bash
ENV SHELL=/bin/bash
RUN npm install -g @anthropic-ai/claude-code
# Setup proper user
RUN addgroup -g 1234 claude && \
    adduser -u 1234 -G claude -s /bin/sh -D claude
# Provide OAuth credentials
COPY credentials/ /home/claude/
# Required for credentials to be uptaken
RUN chown -R claude:claude /home/claude/
WORKDIR /home/claude/project
USER claude
# Run claude as the default command
ENTRYPOINT ["claude"]
