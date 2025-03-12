FROM nsys/ubuntu:latest
LABEL org.opencontainers.image.authors="Tomas Hrdlicka <tomas@hrdlicka.co.uk>"

ENV NSYS_DOCKER_DIR=/opt/nsys-docker

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install htop && \
    apt-get -y install mc && \
    apt-get -y install openjdk-8-jdk && \
    apt-get autoclean && \
    echo "\n\nJAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/environment && \
    mkdir -p $NSYS_DOCKER_DIR

ENV TERM=xterm
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

WORKDIR $NSYS_DOCKER_DIR

ADD nsys-setup.sh ./
ADD nsys-launcher.sh ./

RUN ./nsys-setup.sh

EXPOSE 9060
EXPOSE 9080

VOLUME ["/var/nsys/application-data"]

CMD ["sh", "nsys-launcher.sh"]
