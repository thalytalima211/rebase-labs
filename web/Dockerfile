FROM ruby

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg2

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable --no-install-recommends

WORKDIR /web

COPY . .