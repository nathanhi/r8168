FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's#Types: deb#Types: deb deb-src#g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's#Components: main#Components: main non-free#g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get build-dep -y r8168-dkms
