#! /usr/bin/env python3
import torch

print("Is CUDA available?", torch.cuda.is_available())
print("Number of CUDA devices:", torch.cuda.device_count())
print("Current CUDA device:", torch.cuda.current_device())
print("Name of current CUDA device:", torch.cuda.get_device_name(torch.cuda.current_device()))
