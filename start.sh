#!/bin/bash
# start.sh

# 生成 IdP 证书（如果不存在）
if [ ! -f /opt/shibboleth-idp/credentials/idp.key ]; then
  echo "Generating IdP certificate..."
  /opt/shibboleth-idp/bin/keygen.sh \
    --hostname "${IDP_HOSTNAME:-localhost}" \
    --uriAltName "https://${IDP_HOSTNAME:-localhost}/idp/shibboleth" \
    --lifetime 10 \
    --certfile /opt/shibboleth-idp/credentials/idp.crt \
    --keyfile /opt/shibboleth-idp/credentials/idp.key
  chown tomcat:tomcat /opt/shibboleth-idp/credentials/idp.*
fi

# 启动 Tomcat
catalina.sh run
