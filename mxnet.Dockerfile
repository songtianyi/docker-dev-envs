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
RUN cd /root/MXNet/mxnet && make -j$(nproc)

# Install python language package
RUN cd /root/MXNet/mxnet/python && python setup.py install
RUN echo "export PYTHONPATH=/root/MXNet/mxnet/python" >> /root/.bashrc

# Golang env
RUN echo 'export GOPATH=$HOME/golang/own' >> /root/.bashrc
RUN echo 'export GOROOT=/usr/lib/go' >> /root/.bashrc
RUN echo 'alias src=$GOPATH/src' >> /root/.bashrc

# Play with some code
ENV GOPATH /root/golang/own
RUN mkdir -p $GOPATH/src/golang.org/x
RUN cd $GOPATH/src/golang.org/x && git clone https://github.com/golang/image
RUN go get github.com/jdeng/gomxnet
RUN go get github.com/disintegration/imaging
RUN go get github.com/songtianyi/go-mxnet
RUN git config --global user.name "songtianyi"
RUN git config --global user.email "songtianyi630@163.com"

