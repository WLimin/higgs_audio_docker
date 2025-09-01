#!/bin/bash
# 创建容器镜像
SHELL_FOLDER="$( dirname "${BASH_SOURCE[0]}" )"

docker build --progress=plain -t higgs-audio -f docker/Dockerfile .

