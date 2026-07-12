```dockerfile
# If you bump this tag, also update the literal in uninstall.sh.
FROM node:22-slim

# git/curl/less are baseline dev tools; jq and gh are reached for by Claude's
# built-in workflows. ca-certificates is needed for HTTPS.
#
# python3, make, and g++ are required by node-gyp when an npm package does not
# provide a compatible prebuilt native binary.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    curl \
    less \
    jq \
    gh \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Explicitly tell node-gyp which Python executable to use.
ENV PYTHON=/usr/bin/python3

# Override at build time with --build-arg CLAUDE_CODE_VERSION=2.x.y to pin a
# specific version. Default "latest" tracks whatever is current on npm.
ARG CLAUDE_CODE_VERSION=latest

# When CLAUDE_CODE_VERSION=latest, install.sh passes CACHEBUST=$(date +%s) to
# force a fresh refetch. For pinned versions, the version literal itself is the
# cache key, so install.sh skips CACHEBUST and this layer caches normally.
ARG CACHEBUST=1
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# We DO NOT use `USER node` here. Instead, we pass
# `--user "$(id -u):$(id -g)"` dynamically at runtime in the `claude-pod`
# script. This ensures file permission alignment between the host and the
# container, especially on Linux environments.
#
# Create a dedicated, globally writable home directory for the dynamic runtime
# user.
RUN mkdir -p /home/claude-pod \
    && chmod 777 /home/claude-pod

# Interactive-shell setup, appended to /etc/bash.bashrc. Only interactive bash
# sources this file, so none of it touches the non-interactive
# `claude-pod claude ...` path.
RUN cat >> /etc/bash.bashrc <<'EOF'

# Colored prompt: green label, blue path.
PS1='\[\e[1;32m\]claude-pod\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

# Enable conventional command coloring when output is a terminal.
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
EOF

CMD ["bash"]
```
