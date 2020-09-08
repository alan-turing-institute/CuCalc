#! /bin/sh
echo "NVidia SMI"
nvidia-smi

echo "PyTorch"
python3 /tests/test_gpu_pytorch.py

echo "Tensorflow"
python3 /tests/test_gpu_tensorflow.py

echo "Theano"
python3 /tests/test_gpu_theano.py