#!/bin/bash

# 创建容器或运行存在的容器，并进入交互命令行
SHELL_FOLDER="$( dirname "${BASH_SOURCE[0]}" )"
# 容器卷目录，保存下载的模型
VOLUMES=$PWD

#容器名，存在则启动，否则创建
CONTAINER_NAME=higgs-audio-tts

# 检查专属网络是否创建，用于OpenWebui+ollama的语音交互。可以直接用容器名和端口作为主机名及端口进行内部通信，无需NAT路由
DOCKER_NET=openwebui-net

source ${SHELL_FOLDER}/common.sh
# 传递给容器的默认命令行
declare -a CMD_ARG=( 'python' 'app.py')

if [ $NV_GPU -eq 0 ]; then #没有gpu支持
    CMD_ARG=
fi

cli_common
#docker exec -it ${CONTAINER_NAME} /bin/bash
docker logs -f ${CONTAINER_NAME}
:<<'EOF'

 #python3 webui.py --api

EOF
