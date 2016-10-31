export HADOOP_HOME=/usr/local/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# function myIPv4 { echo `ip addr list eth0 | grep "inet " | cut -d' ' -f6 | cut -d/ -f1` }
