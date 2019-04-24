FROM openjdk:7-jre

# https://confluence.atlassian.com/display/STASH/Stash+home+directory
#
# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
ENV STASH_HOME=/var/atlassian/application-data/stash \
	RUN_USER=daemon \
	RUN_GROUP=daemon \
	STASH_INSTALL_DIR=/opt/atlassian/stash \
	STASH_VERSION=3.11.4 \
	MYSQL_CONNECTOR_VERSION=5.1.47

# Install git, download and extract Stash and create the required directory layout.
# Try to limit the number of RUN instructions to minimise the number of layers that will need to be created.
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends git mariadb-client \
	&& mkdir -p ${STASH_INSTALL_DIR} \
    && curl -L --silent -o /tmp/atlassian-stash-${STASH_VERSION}.tar.gz https://downloads.atlassian.com/software/stash/downloads/atlassian-stash-${STASH_VERSION}.tar.gz \
	&& tar -xz --strip=1 -C "$STASH_INSTALL_DIR" -f /tmp/atlassian-stash-${STASH_VERSION}.tar.gz \
    && mkdir -p ${STASH_INSTALL_DIR}/conf/Catalina \
    && chmod -R 700 ${STASH_INSTALL_DIR}/conf/Catalina \
    && chmod -R 700 ${STASH_INSTALL_DIR}/logs \
    && chmod -R 700 ${STASH_INSTALL_DIR}/temp \
    && chmod -R 700 ${STASH_INSTALL_DIR}/work \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${STASH_INSTALL_DIR}/conf \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${STASH_INSTALL_DIR}/logs \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${STASH_INSTALL_DIR}/temp \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${STASH_INSTALL_DIR}/work \
	&& export MYSQL_FILE=mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz \
	&& curl -L --silent -o /tmp/${MYSQL_FILE} https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_FILE} \
	&& tar -zx --strip-components=1 -C /tmp -f /tmp/$MYSQL_FILE \
	&& cp -v /tmp/mysql-connector-java*.jar ${STASH_INSTALL_DIR}/lib/ \
	&& rm -rf /tmp/* \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

USER ${RUN_USER}:${RUN_GROUP}

VOLUME ["${STASH_HOME}"]

# HTTP Port
EXPOSE 7990

# SSH Port
EXPOSE 7999

WORKDIR $STASH_INSTALL_DIR

# Run in foreground
CMD ["./bin/start-stash.sh", "-fg"]
