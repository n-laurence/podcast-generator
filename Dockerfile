FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
        python3-full \
        python3-pip \
        python3-yaml \
        git && \
    rm -rf /var/lib/apt/lists/*

COPY feed.py /usr/bin/feed.py

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]