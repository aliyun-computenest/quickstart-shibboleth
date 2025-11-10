# Dockerfile
FROM tomcat:10.1.20-jdk17-openjdk-slim

# 安装工具
RUN apt-get update && \
    apt-get install -y wget unzip gnupg ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 下载 Shibboleth IdP v5.2.1（官方最新稳定版）
ENV IDP_VERSION=5.2.1
RUN wget https://shibboleth.net/downloads/identity-provider/${IDP_VERSION}/shibboleth-identity-provider-${IDP_VERSION}.zip -O /tmp/idp.zip && \
    unzip /tmp/idp.zip -d /tmp/ && \
    rm /tmp/idp.zip

# 预配置安装参数
COPY install.properties /tmp/

# 安装 IdP 到 /opt/shibboleth-idp
RUN /tmp/shibboleth-identity-provider-${IDP_VERSION}/bin/install.sh \
    -Didp.src.dir=/tmp/shibboleth-identity-provider-${IDP_VERSION} \
    -Didp.target.dir=/opt/shibboleth-idp \
    -Didp.merge.properties=/tmp/install.properties \
    -Didp.host.name=localhost \
    -Didp.scope=example.com \
    -Didp.keystore.password=changeit \
    -Didp.sealer.password=changeit

# 清理临时文件
RUN rm -rf /tmp/shibboleth-identity-provider-${IDP_VERSION} /tmp/install.properties

# 设置权限
RUN chown -R tomcat:tomcat /opt/shibboleth-idp

# 暴露端口
EXPOSE 8080 8443

# 启动脚本
COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
