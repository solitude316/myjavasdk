FROM debian:13.1

# 1. 定義版本變數（方便日後維護）
ARG JDK_VER=23.0.2
ARG JDK_BUILD=6da2a6609d6e406f85c491fcb119101b
ARG JDK_RELEASE=7
ARG MAVEN_VER=3.9.14

# 2. 設定環境變數
ENV JAVA_HOME=/usr/local/jdk-${JDK_VER}
ENV MAVEN_HOME=/usr/local/apache-maven-${MAVEN_VER}
ENV PATH="${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"

# 3. 合併 RUN 指令以減少 Layer 數量並清理快取
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    sudo \
    tar && \
    # 下載並解壓 JDK (直接流式解壓，不產生暫存檔)
    curl -L https://download.java.net/java/GA/jdk${JDK_VER}/${JDK_BUILD}/${JDK_RELEASE}/GPL/openjdk-${JDK_VER}_linux-x64_bin.tar.gz \
    | tar -xzC /usr/local/ && \
    # 下載並解壓 Maven
    curl -L https://dlcdn.apache.org/maven/maven-3/${MAVEN_VER}/binaries/apache-maven-${MAVEN_VER}-bin.tar.gz \
    | tar -xzC /usr/local/ && \
    # 清理 apt 快取減少體積
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 4. 使用者與權限設定
RUN groupadd java && \
    useradd -m -g java -G sudo -s /bin/bash java && \
    echo "java ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/java

# 5. 設定工作目錄與權限
WORKDIR /workspace
RUN chown java:java /workspace

USER java