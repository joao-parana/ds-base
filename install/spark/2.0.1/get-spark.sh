#!/bin/bash

# Error stop this shell
set -e

export SPARK_VERSION=2.0.1
export SPARK_HOST_DOWNLOAD=d3kbcqa49mib13.cloudfront.net

curl -O  http://$SPARK_HOST_DOWNLOAD/spark-$SPARK_VERSION-bin-without-hadoop.tgz && \
curl -O https://www.apache.org/dist/spark/KEYS && \
curl -O http://www.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz.asc && \
gpg --verify spark-$SPARK_VERSION-bin-without-hadoop.tgz.asc spark-$SPARK_VERSION-bin-without-hadoop.tgz && \
split -b 49000000 spark-$SPARK_VERSION-bin-without-hadoop.tgz && \
rm spark-$SPARK_VERSION-bin-without-hadoop.tgz
