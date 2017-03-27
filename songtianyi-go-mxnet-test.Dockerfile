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
		ca-certificates \
		libopenblas-dev \
		wget

# Build mxnet
RUN mkdir -p /root/MXNet/mxnet
COPY ./mxnet /root/MXNet/mxnet/
RUN cd /root/MXNet/mxnet && make -j2
RUN ln -s /root/MXNet/mxnet/lib/libmxnet.so /usr/lib/libmxnet.so

# Golang env
RUN echo 'export GOPATH=$HOME/golang/own' >> /root/.bashrc
RUN echo 'export GOROOT=/usr/local/go' >> /root/.bashrc
RUN echo "alias src=\"cd $GOPATH/src\"" >> /root/.bashrc
RUN sed "/PS1/c PS1='\`date +%H:%M:%S\` ~ '" -i /root/.bashrc

RUN wget https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
RUN tar -xvf go1.7.linux-amd64.tar.gz
RUN mv go /usr/local/


ENV GOPATH /root/golang/own

# get dep
RUN mkdir -p $GOPATH/src/golang.org/x
RUN cd $GOPATH/src/golang.org/x && git clone https://github.com/golang/image && git clone https:////github.com/golang/text && git clone https:////github.com/golang/net
# src
RUN go get github.com/anthonynsimon/bild && go get github.com/songtianyi/go-mxnet-predictor
RUN git config --global user.name "songtianyi"
RUN git config --global user.email "songtianyi630@163.com"


