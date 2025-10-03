FROM ubuntu:24.04
RUN apt update && apt install -y nodejs npm
RUN npm install -g @anthropic-ai/claude-code
# Setup proper user
RUN groupadd -f -g 1234 claude && \
    useradd -u 1234 -g 1234 -ms /bin/bash claude
# Provide OAuth credentials
COPY credentials/ /home/claude/
# Required for credentials to be uptaken
RUN chown -R claude:claude /home/claude/
WORKDIR /home/claude/project
USER claude
# Run claude as the default command
ENTRYPOINT ["claude"]
