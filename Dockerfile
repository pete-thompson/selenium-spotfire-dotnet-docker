ARG DOTNET_VERSION=latest
FROM mcr.microsoft.com/dotnet/core/sdk:${DOTNET_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# Install Kerberos - in case we need it to authenticate to Spotfire
RUN apt-get update && apt-get install -y krb5-user

# Install libgdiplus - we use it to manipulate images
RUN apt-get update && apt-get install -y libgdiplus

 # Install Chrome
 RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    hicolor-icon-theme \
    libcanberra-gtk* \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpango1.0-0 \
    libpulse0 \
    libv4l-0 \
    fonts-symbola \
    --no-install-recommends \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends

# install chromedriver
RUN apt-get update && apt-get install -yqq unzip \
    && wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# Install xvfb
RUN apt-get update && apt-get install -y \
    xvfb

# Clear caches
RUN  apt-get purge --auto-remove -y curl \
    && rm -rf /var/lib/apt/lists/*
