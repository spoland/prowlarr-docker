# Stage 1: builder
FROM debian:bookworm-slim AS builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget tar ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/share/locale

RUN wget --content-disposition 'http://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64' && \
    tar -xvzf Prowlarr*.linux*.tar.gz -C /tmp/ && \
    mv /tmp/Prowlarr /tmp/prowlarr_extracted && \
    rm Prowlarr*.linux*.tar.gz

# Stage 2: final
FROM mcr.microsoft.com/dotnet/runtime:9.0-bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -m prowlarr && \
    mkdir -p /var/lib/prowlarr && \
    chown prowlarr:prowlarr /var/lib/prowlarr && \
    apt-get update && \
    apt-get install -y --no-install-recommends libsqlite3-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/share/locale

COPY --from=builder --chown=prowlarr:prowlarr /tmp/prowlarr_extracted /opt/Prowlarr

USER prowlarr
WORKDIR /opt/Prowlarr
ENTRYPOINT ["/opt/Prowlarr/Prowlarr", "-nobrowser", "-data=/var/lib/prowlarr/"]
EXPOSE 9696
