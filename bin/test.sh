#!/bin/sh
# docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
docker run --runtime=nvidia --rm gpuenv:py3 nvidia-smi
