FROM daocloud.io/library/ubuntu:wily-20160706

MAINTAINER songtianyi <songtianyi630@163.com>

RUN echo "deb http://mirrors.aliyun.com/ubuntu xenial main restricted universe multiverse\n" > /etc/apt/sources.list

# Pick up some dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        clang \
        git \
        inetutils-ping \
        telnet \
        build-essential \
        libatlas-base-dev \
        libopencv-dev \
        python-numpy \
        python-setuptools \
        unzip \
        vim \
        golang \
        ca-certificates \
        libopenblas-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Build mxnet
RUN mkdir -p /root/MXNet/
RUN cd /root/MXNet/ && git clone https://github.com/dmlc/mxnet.git --recursive
RUN cd /root/MXNet/mxnet && make -j2
RUN ln -s /root/MXNet/mxnet/lib/libmxnet.so /usr/lib/libmxnet.so

# Golang env
RUN echo 'export GOPATH=$HOME/golang/own' >> /root/.bashrc
RUN echo 'export GOROOT=/usr/lib/go' >> /root/.bashrc
RUN echo 'alias src=\"cd $GOPATH/src\"' >> /root/.bashrc
RUN sed "/PS1/c PS1='\`date +%H:%M:%S\` ~ '" -i /root/.bashrc
