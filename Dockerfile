# Start from the official SageMath docker image (https://github.com/sagemathinc/cocalc-docker/blob/master/Dockerfile)
# Note that this is currently using Ubuntu 20.04 as the base image
FROM sagemathinc/cocalc

# Add the NVIDIA machine-learning repository, implicitly trusting the signing key from download.nvidia.com
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - 2> /dev/null && \
    add-apt-repository "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /"


# Install useful utilities missing in original CoCalc image
# CUDA 9.2 is not officially supported on ubuntu 18.04 yet, we use the ubuntu 17.10 repository for CUDA instead.
        # gnupg2 curl ca-certificates \
        # nano gnuplot \
        # g++-5 gcc-5 \
        # libglib2.0-0 libxext6 libsm6 libxrender1 \
        # mercurial subversion \
        # epstool && \

# Add the CUDA repos, implicitly trusting the signing key from download.nvidia.com
# # Note that there is no machine-learning repo for Ubuntu 20.04 yet
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends && \
#     curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - 2> /dev/null && \
#     # echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-cuda.list && \
#     add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" && \
#     # echo "http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
#     add-apt-repository "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" && \
#     rm -rf /var/lib/apt/lists/*


# Install the NVidia CUDA toolkit and driver from the main Ubuntu repository
# Note that we have to specify the driver version
RUN apt-get update && \
    apt-get install -y \
      nvidia-cuda-toolkit \
      nvidia-headless-440 \
      nvidia-utils-440

# Install CuDNN from the NVidia machine-learning repository
# Note that we have to specify the library version
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libcudnn7=7.6.5.32-1+cuda10.1 \
      libcudnn7-dev=7.6.5.32-1+cuda10.1

# Clean up apt files
RUN apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# List the version of CUDA that we have installed
RUN nvcc -V && \
    which nvidia-smi && \
    nvidia-smi 2> /dev/null || echo "No NVidia card detected!"

# Install packages into system Python: tensorflow, Theano, Keras and PyTorch
RUN pip3 install tensorflow>2.0 theano keras torch

# Test installed Python packages
COPY tests /tests
RUN python3 /tests/theano_gputest.py
RUN python3 /tests/tensorflow_gputest.py


# #Install Anaconda
# RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
#     wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
#     /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#     rm ~/anaconda.sh

# #Install Python packages (incl. Theano, Keras and PyTorch)
# RUN /opt/conda/bin/conda install -y ipykernel matplotlib pydot-ng theano pygpu bcolz paramiko keras seaborn graphviz scikit-learn cudatoolkit numba
# RUN /opt/conda/bin/conda create -n xeus python=3.6 ipykernel xeus-cling -c QuantStack -c conda-forge
# RUN /opt/conda/bin/conda create -n pytorch python=3.6 ipykernel pytorch torchvision cuda90 -c pytorch

# ENV PATH /opt/conda/bin:${PATH}
# ENV PATH /usr/local/cuda/bin:${PATH}
# RUN echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> /cocalc/src/smc_pyutil/smc_pyutil/templates/linux/bashrc && \
#     echo 'export PATH=/opt/conda/bin${PATH:+:${PATH}}' >> /cocalc/src/smc_pyutil/smc_pyutil/templates/linux/bashrc

# #Add Conda kernel to Jupyter
# RUN python -m ipykernel install --prefix=/usr/local/ --name "anaconda_kernel"

# #Start CuCalc

# CMD /root/run.py

# EXPOSE 80 443
