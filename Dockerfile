# agent dockerfile
FROM praqma/network-multitool
RUN apk update && \
    apk add --no-cache curl && \
    rm -rf /var/cache/apk/*

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

CMD ["tail", "-f", "/dev/null"]