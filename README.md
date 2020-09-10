# CuCalc = CUDA + CoCalc Docker container

CoCalc rebased ontop of tensorflow and cuda.

This repository contains a recipe to make a CoCalc container image that adds
CUDA support and the following machine learning applications

- Keras
- PyTorch
- Tensorflow
- Theano

## Dependencies
- sed (*should* work with either GNU or BSD)
- [Nvidia Docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

## Building
Clone this repository *and* the cocalc-docker subrepository

```
$ git clone https://github.com/alan-turing-institute/CuCalc --recurse-submodules
```

Build the container image

```
$ make build
```

CoCalc downloads and installs a large set of packages. As a result building the
container may take approximately an hour to finish.

Run the set of tests in `tests` with

```
$ make test
```
