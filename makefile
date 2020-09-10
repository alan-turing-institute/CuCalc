Dockerfile.cucalc:
	sed 's|^FROM ubuntu:20.04|FROM tensorflow/tensorflow:latest-gpu|' ./cocalc-docker/Dockerfile > Dockerfile

build: Dockerfile.cucalc
	docker build -t cucalc -f Dockerfile ./cocalc-docker
