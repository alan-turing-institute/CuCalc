# Start from the official SageMath docker image (https://github.com/sagemathinc/cocalc-docker/blob/master/Dockerfile)
# Note that this is currently using Ubuntu 20.04 as the base image
FROM sagemathinc/cocalc

# Add the NVIDIA machine-learning and CUDA repositories, implicitly trusting the signing key from download.nvidia.com
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - 2> /dev/null && \
    add-apt-repository "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" && \
    add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /"

# Remove any existing NVidia packages
RUN apt-get update && \
    apt-get --purge remove "*nvidia*"

# Install the NVidia CUDA toolkit and driver from the main Ubuntu repository
# Note that we have to specify the driver version
RUN apt-get update && \
    apt-get install -y \
        cuda-11-0

#   nvidia-cuda-toolkit \
#   nvidia-headless-440 \
#   nvidia-utils-440

# Install CuDNN and TensorRT from the NVidia machine-learning repository
# Note that we have to specify the library version
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libcudnn8=8.0.3.33-1+cuda11.0 \
        libcudnn8-dev=8.0.3.33-1+cuda11.0 \
        libnvinfer7=7.2.0-1+cuda11.0 \
        libnvinfer-dev=7.2.0-1+cuda11.0 \
        libnvinfer-plugin7=7.2.0-1+cuda11.0

# Clean up apt files
RUN apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Ensure that CUDA paths are available
ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# List the version of CUDA that we have installed
RUN nvcc -V && \
    which nvidia-smi && \
    nvidia-smi 2> /dev/null || echo "No NVidia card detected!"

# Install Julia kernel then list all available kernels
RUN julia -e 'using Pkg; Pkg.add("IJulia");' && \
    mv /root/.local/share/jupyter/kernels/julia-* /usr/local/share/jupyter/kernels && \
    jupyter kernelspec list

# Install packages into system Python: tensorflow, Theano, Keras and PyTorch
RUN pip3 install tensorflow>2.0 theano keras torch --no-binary :all:

# Add tests for installed Python packages
COPY tests /tests

# Start CuCalc
CMD /root/run.py

ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

EXPOSE 22 80 443
