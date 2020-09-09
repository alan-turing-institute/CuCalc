# Start from the official SageMath docker image (https://github.com/sagemathinc/cocalc-docker/blob/master/Dockerfile)
# Note that this is currently using Ubuntu 20.04 as the base image
FROM sagemathinc/cocalc

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get install --no-install-recommends nvidia-driver-450

RUN apt-get install --no-install-recommends \
    cuda-10-1 \
    libcudnn7=7.6.5.32-1+cuda10.1  \
    libcudnn7-dev=7.6.5.32-1+cuda10.1

RUN sudo apt-get install -y --no-install-recommends \
    libnvinfer6=6.0.1-1+cuda10.1 \
    libnvinfer-dev=6.0.1-1+cuda10.1 \
    libnvinfer-plugin6=6.0.1-1+cuda10.1

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

Run pip3 install tensorflow

# Clean up apt files
RUN apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Install Julia kernel then list all available kernels
RUN julia -e 'using Pkg; Pkg.add("IJulia");' && \
    mv /root/.local/share/jupyter/kernels/julia-* /usr/local/share/jupyter/kernels && \
    jupyter kernelspec list

# Install packages into system Python: Theano, Keras and PyTorch
RUN pip3 install theano keras torch

# Add tests for installed Python packages
COPY tests /tests

# Start CuCalc
CMD /root/run.py

ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

EXPOSE 22 80 443
