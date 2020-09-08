# Start from the official SageMath docker image (https://github.com/sagemathinc/cocalc-docker/blob/master/Dockerfile)
# Note that this is currently using Ubuntu 20.04 as the base image
FROM sagemathinc/cocalc

# Add the NVIDIA machine-learning and CUDA repositories, implicitly trusting the signing key from download.nvidia.com
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - 2> /dev/null && \
    add-apt-repository "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" && \
    add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /"


# Install the NVidia CUDA toolkit and driver from the main Ubuntu repository
# Note that we have to specify the driver version
RUN apt-get update && \
    apt-get install -y \
        cuda

    #   nvidia-cuda-toolkit \
    #   nvidia-headless-440 \
    #   nvidia-utils-440

# Install CuDNN from the NVidia machine-learning repository
# Note that we have to specify the library version
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libcudnn8=8.0.3.33-1+cuda11.0 \
        libcudnn8-dev=8.0.3.33-1+cuda11.0
        # libcudnn7=7.6.5.32-1+cuda10.1 \
        # libcudnn7-dev=7.6.5.32-1+cuda10.1

# Clean up apt files
RUN apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# List the version of CUDA that we have installed
RUN nvcc -V && \
    which nvidia-smi && \
    nvidia-smi 2> /dev/null || echo "No NVidia card detected!"

# Install Julia kernel then list all available kernels
RUN julia -e 'using Pkg; Pkg.add("IJulia");' && \
    mv /root/.local/share/jupyter/kernels/julia-* /usr/local/share/jupyter/kernels && \
    jupyter kernelspec list

# Install packages into system Python: tensorflow, Theano, Keras and PyTorch
RUN pip3 install tensorflow>2.0 theano keras torch

# Add tests for installed Python packages
COPY tests /tests

# Install CUDA path variables
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# Start CuCalc
CMD /root/run.py

ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

EXPOSE 22 80 443
