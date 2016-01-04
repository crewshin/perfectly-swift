#####################################################################
## SWIFT ##
FROM ubuntu:14.04
MAINTAINER Gene Crucean <genecrucean+hub.docker.com@gmail.com>

ENV SWIFT_VERSION 2.2-SNAPSHOT-2015-12-31-a
ENV SWIFT_PLATFORM ubuntu14.04
ENV FILE_LOCATION /FILES

# Install related packages
RUN apt-get update && \
    apt-get install -y build-essential wget clang libssl-dev libedit-dev python2.7 python2.7-dev libevent-dev libicu52 libicu-dev libsqlite3-dev libpq-dev libmysqlclient-dev pkg-config libssl-dev libsasl2-dev libxml2 nano git && \
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

# PerfectLib
WORKDIR $FILE_LOCATION/Perfect/PerfectLib
RUN make \
    && make install

# PerfectServer
WORKDIR $FILE_LOCATION/Perfect/PerfectServer
RUN make \
    && ln -s $FILE_LOCATION/Perfect/PerfectServer/perfectserverhttp /usr/local/bin/perfectserverhttp \
    && ln -s $FILE_LOCATION/Perfect/PerfectServer/perfectserverfcgi /usr/local/bin/perfectserverfcgi

################ Build connectors.
# Postgres.
WORKDIR $FILE_LOCATION/Perfect/Connectors/PostgreSQL
RUN make \
    && ln -s $FILE_LOCATION/Perfect/Connectors/PostgreSQL/PostgreSQL.so /usr/local/lib/PostgreSQL.so

# Mongo. http://api.mongodb.org/c/current/installing.html
WORKDIR $FILE_LOCATION
ENV MONGOC_VERSION 1.3.0
RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/$MONGOC_VERSION/mongo-c-driver-$MONGOC_VERSION.tar.gz \
    && tar xzf mongo-c-driver-$MONGOC_VERSION.tar.gz \
    && cd mongo-c-driver-$MONGOC_VERSION \
    && ./configure && make && make install \
    && rm -f mongo-c-driver-$MONGOC_VERSION.tar.gz && rm -rf mongo-c-driver-$MONGOC_VERSION

WORKDIR $FILE_LOCATION/Perfect/Connectors/MongoDB
RUN make \
    && ln -s $FILE_LOCATION/Perfect/Connectors/MongoDB/MongoDB.so /usr/local/lib/MongoDB.so

# MySQL.
WORKDIR $FILE_LOCATION/Perfect/Connectors/MySQL
RUN make \
    && ln -s $FILE_LOCATION/Perfect/Connectors/MySQL/MySQL.so /usr/local/lib/MySQL.so


#############################
WORKDIR $FILE_LOCATION

# Clone swift proj.
ENV PROJ_REPO https://github.com/crewshin/swift-router.git
RUN git clone $PROJ_REPO

# Build and run proj. Example.
ENV PATH_TO_BUILD_AND_RUN_SCRIPT BuildAndRun.sh
COPY $PATH_TO_BUILD_AND_RUN_SCRIPT .
RUN $PATH_TO_BUILD_AND_RUN_SCRIPT

# Expose some ports.
EXPOSE 80 443 8181

# Run app.
ENTRYPOINT ["perfectserverhttp"]
