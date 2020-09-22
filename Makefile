Dockerfile:
	# Rebase onto tensorflow container
	sed 's|^FROM ubuntu:20.04|FROM tensorflow/tensorflow:latest-gpu|' ./cocalc-docker/Dockerfile > Dockerfile
	# Update maintainer label
	sed -i'' 's|^MAINTAINER .*|LABEL maintainer="researchengineering@turing.ac.uk"|' Dockerfile
	# IJulia installation
	sed -i'' "/^# Install IJulia kernel/a RUN julia -e 'ENV[\"JUPYTER\"] = \"/usr/local/bin/jupyter\"; ENV[\"JULIA_PKGDIR\"] = \"/opt/julia/share/julia/site\"; using Pkg; Pkg.add(\"IJulia\");' \\\ \n  && mv /root/.local/share/jupyter/kernels/julia-* /usr/local/share/jupyter/kernels" Dockerfile
	# Install theano, keras and pytorch
	sed -i'' '/^CMD \/root\/run.py/i RUN pip3 install theano keras torch\n' Dockerfile
	# Restore default bashrc
	sed -i'' '/^RUN echo "umask 077" >> \/etc\/bash.bashrc/i RUN cp /etc/skel/.bashrc /etc/bash.bashrc\n' Dockerfile

build: Dockerfile
	docker build -t cucalc -f Dockerfile ./cocalc-docker

test: build
	docker run -v "$$(pwd)/tests":/tests --gpus all cucalc /tests/run_all.sh

clean:
	rm -f Dockerfile
