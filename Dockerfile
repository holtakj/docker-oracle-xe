FROM oraclelinux:latest
LABEL MAINTAINER="Adrian Png <adrian.png@fuzziebrain.com>"

ENV \
  # The only environment variable that should be changed!
  ORACLE_PASSWORD=Oracle18 \
  # DO NOT CHANGE 
  ORACLE_DOCKER_INSTALL=true \
  ORACLE_SID=XE \
  ORACLE_BASE=/opt/oracle \
  ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
  RUN_FILE=runOracle.sh \
  EM_REMOTE_ACCESS=enableEmRemoteAccess.sh \
  ORACLE_XE_RPM=oracle-database-xe-18c-1.0-1.x86_64.rpm
    

COPY ./files/*.rpm /tmp/

RUN yum install -y oracle-database-preinstall-18c && \
  yum install -y /tmp/${ORACLE_XE_RPM} && \
  rm -rf /tmp/${ORACLE_XE_RPM}

COPY ./scripts/*.sh ${ORACLE_BASE}/scripts/

RUN chmod a+x ${ORACLE_BASE}/scripts/*.sh && \
  mkdir -p ${ORACLE_BASE}/oradata && \
  chown oracle.oinstall ${ORACLE_BASE}/oradata

# 1521: Oracle listener
# 5500 Oracle Enterprise Manager (EM) Express listener.
EXPOSE 1521 5500

VOLUME [ "${ORACLE_BASE}/oradata" ]

CMD exec ${ORACLE_BASE}/scripts/${RUN_FILE}