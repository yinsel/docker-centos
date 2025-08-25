FROM centos:7.9.2009

RUN \
    # 更换为国内源并清理原有repo
    SOURCE=https://mirrors.cloud.tencent.com/repo/centos7_base.repo && \
    rm -rf /etc/yum.repos.d/* && \
    curl $SOURCE -o /etc/yum.repos.d/CentOS-Base.repo && \
    # 添加epel源
    SOURCE=https://mirrors.cloud.tencent.com/repo/epel-7.repo && \
    curl $SOURCE -o /etc/yum.repos.d/epel-7.repo && \
    # 安装基础工具（仅保留必要组件）
    yum install -y --setopt=install_weak_deps=false \
        wget curl git unzip \
        iproute bind-utils net-tools \
        kde-l10n-Chinese glibc-common && \
    # 配置本地化
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \
    localedef -c -f GBK -i zh_CN zh_CN.gbk && \
    # 配置时区
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    # 安装systemctl替代工具
    wget https://gh-proxy.com/https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/refs/heads/master/files/docker/systemctl.py -O /usr/bin/systemctl && \
    chmod +x /usr/bin/systemctl && \
    # 配置文件打开数和进程数限制
    echo "* soft nofile 65536" >> /etc/security/limits.conf && \
    echo "* hard nofile 65536" >> /etc/security/limits.conf && \
    echo "* soft nproc 65536" >> /etc/security/limits.conf && \
    echo "* hard nproc 65536" >> /etc/security/limits.conf

# 安装Oracle JDK 8
RUN wget https://gh-proxy.com/https://github.com/yinsel/oracle-jdk/releases/download/oracle-jdk/jdk-8u211-linux-x64.rpm -O /tmp/jdk-8u211-linux-x64.rpm && \
    rpm -ivh /tmp/jdk-8u211-linux-x64.rpm && \
    rm -f /tmp/jdk-8u211-linux-x64.rpm && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    yum makecache && \
    rm -rf /tmp/*