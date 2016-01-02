#####################################################################
## SWIFT ##
FROM ubuntu:14.04
MAINTAINER Gene Crucean <genecrucean+hub.docker.com@gmail.com>

ENV SWIFT_VERSION 2.2-SNAPSHOT-2015-12-31-a
ENV SWIFT_PLATFORM ubuntu14.04
ENV FILE_LOCATION /FILES

# Install related packages
RUN apt-get update && \
    apt-get install -y build-essential wget clang libssl-dev libedit-dev python2.7 python2.7-dev libevent-dev libicu52 libicu-dev libsqlite3-dev libxml2 git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Swift keys
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import - && \
    gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

# Install Swift Ubuntu 14.04 Snapshot
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM && \
    SWIFT_URL=https://swift.org/builds/$(echo "$SWIFT_PLATFORM" | tr -d .)/swift-$SWIFT_VERSION/$SWIFT_ARCHIVE_NAME.tar.gz && \
    wget $SWIFT_URL && \
    wget $SWIFT_URL.sig && \
    gpg --verify $SWIFT_ARCHIVE_NAME.tar.gz.sig && \
    tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz --directory / --strip-components=1 && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/*

# Set Swift Path
ENV PATH /usr/bin:$PATH

# Print Installed Swift Version
RUN swift --version

#####################################################################
## PERFECT ##
WORKDIR $FILE_LOCATION
ADD src/ $FILE_LOCATION/src/

RUN git clone https://github.com/PerfectlySoft/Perfect.git
WORKDIR $FILE_LOCATION/Perfect/PerfectLib
RUN make \
    && make install

WORKDIR $FILE_LOCATION/Perfect/PerfectServer
RUN make \
    && ln -s $FILE_LOCATION/Perfect/PerfectServer/perfectserverhttp /usr/local/bin/perfectserverhttp \
    && ln -s $FILE_LOCATION/Perfect/PerfectServer/perfectserverfcgi /usr/local/bin/perfectserverfcgi


#############################
WORKDIR $FILE_LOCATION

# Clone swift proj.
ENV PROJ_REPO https://github.com/crewshin/swift-router.git
RUN git clone $PROJ_REPO

# Expose some ports.
EXPOSE 80 443 8181

# Run app.
ENTRYPOINT ["perfectserverhttp"]
