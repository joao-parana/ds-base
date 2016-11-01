# ds-base

> Funcionalidades disponíveis nesta imagem: bash, curl, gcc, ssh, git, supervisor, Java 8, Hadoop, Hive e Spark

## Hadoop

> Para uma introdução ao Hadoop você pode ver este curso multimidia gratuito [http://courses.hadoopinrealworld.com/courses/enrolled/starterkit](http://courses.hadoopinrealworld.com/courses/enrolled/starterkit)

A documentação do **Hadoop 2.7.3** pode ser encontrada no link 
[http://hadoop.apache.org/docs/r2.7.3/](http://hadoop.apache.org/docs/r2.7.3/).

> **Suporte a IPv6**. Atualmente Hadoop não suporta IPv6. Veja [https://issues.apache.org/jira/browse/HADOOP-11890](https://issues.apache.org/jira/browse/HADOOP-11890). Dessa forma é necessário desabilitar esta feature no Linux (Ubuntu 16.04 64 bits).

### Valores padrão para parâmetros de configuração podem ser vistos em [hadoop-yarn-config.md](hadoop-yarn-config.md)

O Hadoop pode rodar nos seguintes modos:

* Local (Standalone) Mode
* Pseudo-Distributed Mode
* Fully-Distributed Mode

### Standalone Mode

Ele já vem configurado para rodar no modo Standalone. Neste caso devemos invocar 
o comando haddop e passar parâmetros como no exemplo abaixo.

```
cd /usr/local/hadoop
mkdir ../master
cp etc/hadoop/*.xml ../master
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar grep ../master /tmp/output 'dfs[a-z.]+'  2> /dev/null
cat /tmp/output/*
```
Esta configuração pode ser vista em [conf/Standalone-Mode](conf/Standalone-Mode)

### single-node no 'Pseudo-Distributed Mode'

O Hadoop pode rodar também num **single-node** no **Pseudo-Distributed Mode** 
onde cada daemon Hadoop roda num processo Java separado.

Neste caso é preciso fazer uma configuração. Veja [conf/Pseudo-Distributed-Mode](conf/Pseudo-Distributed-Mode)



