FROM alpine:3.4

# Este dockerfile foi baseado inicialmente no trabalho do gustavonalle @ github.
# Funcionalidades disponíveis nesta imagem:
# bash, curl, gcc, ssh, git, supervisor, Java 8, Hadoop, Hive e Spark

MAINTAINER "João Antonio Ferreira" <joao.parana@gmail.com>`

ENV REFRESHED_AT 2016-10-31

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk upgrade --update && apk add --update \
    maven curl openjdk8 openssh bash cracklib-words supervisor procps \
    && apk add --no-cache curl curl-dev libxml2-dev gcc g++ git coreutils \
    && rm /var/cache/apk/*

ARG root_passwd=change_this

ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_VERSION 2.7.3
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HIVE_HOME /usr/local/hive
ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV ROOT_PASSWD $root_passwd
ENV SPARK_DIST_CLASSPATH /usr/local/hadoop/etc/hadoop:/usr/local/hadoop/share/hadoop/common/lib/*:/usr/local/hadoop/share/hadoop/common/*:/usr/local/hadoop/share/hadoop/hdfs:/usr/local/hadoop/share/hadoop/hdfs/lib/*:/usr/local/hadoop/share/hadoop/hdfs/*:/usr/local/hadoop/share/hadoop/yarn/lib/*:/usr/local/hadoop/share/hadoop/yarn/*:/usr/local/hadoop/share/hadoop/mapreduce/lib/*:/usr/local/hadoop/share/hadoop/mapreduce/*:/contrib/capacity-scheduler/*.jar
ENV SPARK_HOME  /usr/local/spark
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

ENV PATH $SPARK_HOME/bin:$HADOOP_PREFIX/bin:$HIVE_HOME/bin:${JAVA_HOME}/bin:${PATH}

RUN curl "http://mirrors.ukfast.co.uk/sites/ftp.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" | tar -C /usr/local/ -xz | ln -s /usr/local/hadoop-$HADOOP_VERSION/ /usr/local/hadoop

ADD hadoop_home.sh /etc/profile.d/hadoop_home.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Invocar com '--build-arg': docker build --build-arg root_passwd=verySecret .
# RUN echo "root_passwd is $root_passwd"
# RUN echo "root:$root_passwd" | chpasswd

USER root

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

RUN sed -i -e 's/JAVA=\$JAVA_HOME\/bin\/java/JAVA=\/usr\/lib\/jvm\/default-jvm\/bin\/java/' /usr/local/hadoop/etc/hadoop/yarn-env.sh
RUN sed -i -e 's/export JAVA_HOME=${JAVA_HOME}/export JAVA_HOME=\/usr\/lib\/jvm\/default-jvm\//' /usr/local/hadoop/etc/hadoop/hadoop-env.sh

ADD conf /usr/local/yarn/conf

RUN env && echo "Conteúdo de /usr/local/yarn" && find /usr/local/yarn

# Copy Spark 2.0.1 to temp folder
COPY install /tmp/
# Install Spark
RUN cd /tmp/spark/2.0.1/ && \
    cat xaa xab xac > spark-2.0.1-bin-without-hadoop.tgz && \
    cd /usr/local/ && \
    tar -xzf /tmp/spark/2.0.1/spark-2.0.1-bin-without-hadoop.tgz && \
    ls -lat . && \
    mv spark-2.0.1-bin-without-hadoop spark

# O comando ENV abaixo não expandiu o classpath
# ENV SPARK_DIST_CLASSPATH $(/usr/local/hadoop/bin/hadoop classpath)

RUN env | grep SPARK

RUN curl -O http://ftp.unicamp.br/pub/apache/hive/hive-2.1.0/apache-hive-2.1.0-bin.tar.gz && \
    cat apache-hive-2.1.0-bin.tar.gz | tar -C /usr/local/ -xz && \
    ls -la /usr/local/ && \
    mv /usr/local/apache-hive-2.1.0-bin /usr/local/hive

EXPOSE 22 80 8020 8030 8031 8032 8033 8042 8080 8088 9000 9001 50010 50020 50030 50065 50060 50070 50075 50090 50470 50475

# CMD [ "", "" ]
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
