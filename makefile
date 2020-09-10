Dockerfile.cucalc:
	sed 's|^FROM ubuntu:20.04|FROM tensorflow/tensorflow:latest-gpu|' ./cocalc-docker/Dockerfile > Dockerfile
	sed -i'' '/^CMD \/root\/run.py/i RUN pip3 install theano keras torch\n' Dockerfile

build: Dockerfile.cucalc
	docker build -t cucalc -f Dockerfile ./cocalc-docker

test: build
	docker run -v ./tests:/tests --gpus all cucalc /tests/run_all.sh
