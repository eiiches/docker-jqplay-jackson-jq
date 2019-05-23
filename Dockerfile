FROM golang:1.12.5-stretch as builder

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global grunt-cli bower
RUN groupadd -r build && useradd --no-log-init -m -r -g build build

ENV BUILDDIR $GOPATH/src/github.com/jingweno/jqplay
RUN mkdir -p $BUILDDIR && chown build:build $BUILDDIR

USER build
RUN git clone https://github.com/jingweno/jqplay $BUILDDIR
WORKDIR $BUILDDIR
RUN git reset --hard 929ffc5df87b9cd586a617277bdcbeba85406f93
RUN bin/build

# --- main
FROM openjdk:11.0.3-jdk-slim-stretch
RUN groupadd -r jqplay && useradd --no-log-init -m -r -g jqplay jqplay

COPY --from=builder /go/src/github.com/jingweno/jqplay/public /opt/jqplay/public/
COPY --from=builder /go/src/github.com/jingweno/jqplay/bin/jqplay /opt/jqplay/bin/
ADD http://central.maven.org/maven2/net/thisptr/jackson-jq-cli/0.0.10/jackson-jq-cli-0.0.10.jar /opt/jqplay/jackson-jq-cli.jar
RUN chmod 0644 /opt/jqplay/jackson-jq-cli.jar
COPY jq /opt/jqplay/bin/linux_amd64/jq
RUN chmod 0755 /opt/jqplay/bin/linux_amd64/jq

WORKDIR /opt/jqplay
USER jqplay
ENV PORT 8080
EXPOSE 8080
CMD ["/opt/jqplay/bin/jqplay"]
