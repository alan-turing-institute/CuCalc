Dockerfile:
	sed 's|^FROM ubuntu:20.04|FROM tensorflow/tensorflow:latest-gpu|' ./cocalc-docker/Dockerfile > Dockerfile
	sed -i 's|^MAINTAINER .*|LABEL maintainer="researchengineering@turing.ac.uk"|' Dockerfile
	sed -i'' '/^CMD \/root\/run.py/i RUN pip3 install theano keras torch\n' Dockerfile
	sed -i'' '/^RUN echo "umask 077" >> \/etc\/bash.bashrc/i RUN cp /etc/skel/.bashrc /etc/bash.bashrc\n' Dockerfile

build: Dockerfile
	docker build -t cucalc -f Dockerfile ./cocalc-docker

test: build
	docker run -v "$$(pwd)/tests":/tests --gpus all cucalc /tests/run_all.sh

clean:
	rm -f Dockerfile
