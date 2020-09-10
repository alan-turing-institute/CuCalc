#! /usr/bin/env python3
import torch

print("Is CUDA available?", torch.cuda.is_available())
print("Number of CUDA devices:", torch.cuda.device_count())
if torch.cuda.device_count():
    print("... current CUDA device:", torch.cuda.current_device())
    print("... name of current CUDA device:", torch.cuda.get_device_name(torch.cuda.current_device()))
