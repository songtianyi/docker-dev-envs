FROM daocloud.io/library/ubuntu:wily-20160706

MAINTAINER songtianyi <songtianyi630@163.com>
# for mxnet inference by golang in production

RUN echo "deb http://mirrors.aliyun.com/ubuntu xenial main restricted universe multiverse\n" > /etc/apt/sources.list

# Pick up some dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		clang \
		git \
		telnet \
	        build-essential \
		libatlas-base-dev \
		libopencv-dev \
		libopenblas-dev \
		unzip \
		vim \
		ca-certificates \
		wget \
		&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
		

# Build mxnet
RUN mkdir -p /root/MXNet/
RUN cd /root/MXNet/ && git clone https://github.com/dmlc/mxnet.git --recursive
RUN cd /root/MXNet/mxnet && git checkout v0.8.0
RUN cd /root/MXNet/mxnet && make -j2
RUN ln -s /root/MXNet/mxnet/lib/libmxnet.so /usr/lib/libmxnet.so

RUN wget https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
RUN tar -xvf go1.7.linux-amd64.tar.gz
RUN mv go /usr/local/
