FROM ruby:2.7.1

ENV DEBIAN_FRONTEND=noninteractive \
  NODE_VERSION=10.16.1 \
  CHROMEDRIVER_VERSION=2.42 \
  TIMEZONE=America/Sao_Paulo \
  CODENAME=stretch \
  DISPLAY=:0 \
  LANG=en_US.utf8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8

# Set timezone info
RUN cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# Add postgres source
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $CODENAME-pgdg main" >> \
  /etc/apt/sources.list.d/pgdg.list

# Add chrome source
RUN curl -sS -o - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | \
  apt-key add - && \
  echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Add postgres repository
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -

RUN sed -i '/deb-src/d' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    zip \
    postgresql-client \
    google-chrome-stable \
    locales

# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen

# Install node.js
RUN curl -sSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar xfJ - -C /usr/local --strip-components=1 && \
  npm install yarn -g

# Install ChromeDriver
RUN wget --quiet -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/

WORKDIR /app
