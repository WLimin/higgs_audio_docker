#!/bin/bash
# 只定义了函数，需要外部定义变量：
# VOLUMES
# CONTAINER_NAME
# DOCKER_NET
# LINK_MODELS
# CMD_ARG
# EXTEND_ENV
#CONTAINER_USER

# 重复利用其它项目已经下载的模型，可以全部移动到${VOLUMES}/models目录下。若不需要，设置为空
LINK_MODELS=$"
"
#额外的容器变量
EXTEND_ENV=''

CONTAINER_USER=webui

# 宿主机是否有 nvidia GPU
which nvidia-smi
if [ $? -eq 0 ]; then #有gpu支持
    NV_GPU=1
else
    NV_GPU=0
fi

cli_common() {
    # 检查专属网络是否创建，用于OpenWebui+ollama的语音交互
    docker network ls --format '{{.Name}}' | grep "${DOCKER_NET}"
    if [ $? -ne 0 ]; then
        docker network create ${DOCKER_NET}
    fi

    #是否存在容器，存在则启动，否则创建
    NS=$(docker ps -a --format '{{json .Names}},{{json .State}}' | grep "${CONTAINER_NAME}")
    if [ $? -eq 0 ]; then
        # 已存在
        docker start ${CONTAINER_NAME}
    else
        # 不存在
        # 宿主机是否有 nvidia GPU
        if [ $NV_GPU -eq 1 ]; then #有gpu支持
            RUN_USE_GPU="--name ${CONTAINER_NAME} " #"--gpus all -e 'PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True'"
        else
            RUN_USE_GPU="--name ${CONTAINER_NAME} "
        fi
        # Debug: force use CPU
        #RUN_USE_GPU="--name ${CONTAINER_NAME} "
        # 提供的服务。由于暂时不打算提供模型共享，可以选择api用于对话服务。webui界面主要完成语音复刻和测试。
        #CAPABILITIES=api|web|all
        CAPABILITIES=api
        docker run -itd $RUN_USE_GPU \
            --network=${DOCKER_NET} \
            -p 7860:7860 -p 7870:7870 \
            --user $(id -u):$(id -g) \
            -e CAPABILITIES=${CAPABILITIES} \
            -v ${VOLUMES}/models:/app/models \
            -v ${VOLUMES}/models/huggingface:/home/$CONTAINER_USER/.cache/huggingface \
            $EXTEND_ENV \
            $LINK_MODELS \
         higgs-audio  "${CMD_ARG[@]}"
    fi
}

#            -e NLTK_DATA="/app/Speech-AI-Forge/models/nltk_data" \

