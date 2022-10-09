# Use a standard Python + Docker image from https://github.com/nikolaik/docker-python-nodejs
FROM nikolaik/python-nodejs:python3.10-nodejs18-bullseye

# Install Git LFS
RUN cd /tmp && \
  curl --silent --location https://github.com/git-lfs/git-lfs/releases/download/v3.2.0/git-lfs-linux-amd64-v3.2.0.tar.gz | tar -xzf - && \
  git-lfs-3.2.0/install.sh && \
  rm -rf git-lfs-3.2.0/

# Install in a shared location
WORKDIR /usr/share/builderrors

# Copy all files not in .dockerignore
COPY . .

# Install builderrors
RUN npm ci && \
  pip install -r requirements.txt && \
  ln -s -t /usr/bin /usr/share/builderrors/builderrors

# Default command is to run builderrors on /src
WORKDIR /src

# Gitlab CI requires CMD, not ENTRYPOINT. It initializes bash and runs the rest of the script
CMD ["builderrors"]
