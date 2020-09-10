Dockerfile.cocalc:
	wget https://raw.githubusercontent.com/sagemathinc/cocalc-docker/master/Dockerfile -O Dockerfile.cocalc

Dockerfile.cucalc: Dockerfile.cocalc
	sed 's|^FROM ubuntu:20.04|FROM tensorflow/tensorflow:latest-gpu|' Dockerfile.cocalc > Dockerfile.cucalc

build: Dockerfile.cucalc
	docker build -t cucalc -f Dockerfile.cucalc .
