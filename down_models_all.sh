#!/bin/bash
#创建 容器 需要的所有模型目录及下载模型
# 2025-07-30 14:18:42
# 外部工具 wget unzip bash

#要下载的模型保存位置，默认当前目录下/models
MOOD_ZOOM=$PWD/models

mkdir_all(){
    mkdir -p ${MOOD_ZOOM}/{ZhenYe234/hubert_base_general_audio,facebook/hubert-base-ls960,higgs-audio-v2-tokenizer,microsoft/wavlm-base-plus,huggingface/hub,higgs-audio-v2-generation-3B-base}
}
#下载指定列表
wget_required_list(){
    if [ "A$1" == "A" ]; then
        MAIN="main"
    else
        MAIN="$1"
    fi
    REQUIRED_URL="${MODEL_REPO_URL}/${MODEL_REPO_ID}/resolve/${MAIN}"
    for Required_File in ${REQUIRED_FILES[@]}; do
        wget -c ${REQUIRED_URL}/${Required_File} -O ${MOOD_ZOOM}/${LOCAL_BASE_DIR}/${Required_File}
    done
}

mkdir_all

#开始下载模型数据
echo "Download bosonai/higgs-audio-v2-generation-3B-base..."
MODEL_REPO_URL="https://hf-mirror.com"
MODEL_REPO_ID="bosonai/higgs-audio-v2-generation-3B-base"
LOCAL_BASE_DIR="higgs-audio-v2-generation-3B-base"
REQUIRED_FILES=( config.json generation_config.json higgs_audio_v2_architecture_combined.png LICENSE model-00002-of-00003.safetensors  model.safetensors.index.json  README.md tokenizer_config.json 
emergent-tts-emotions-win-rate.png  higgs_audio_tokenizer_architecture.png  higgs_audio_v2_open_source_delay_pattern.png  model-00001-of-00003.safetensors  model-00003-of-00003.safetensors  open_source_repo_demo.mp4 special_tokens_map.json  tokenizer.json )
wget_required_list

echo "Download bosonai/higgs-audio-v2-tokenizer..."
MODEL_REPO_URL="https://hf-mirror.com"
MODEL_REPO_ID="bosonai/higgs-audio-v2-tokenizer"
LOCAL_BASE_DIR="higgs-audio-v2-tokenizer"
REQUIRED_FILES=(config.json  higgs_audio_tokenizer_architecture.png  LICENSE  model.pth  README.md )
wget_required_list

echo "Download ZhenYe234/hubert_base_general_audio..."
MODEL_REPO_URL="https://hf-mirror.com"
MODEL_REPO_ID="ZhenYe234/hubert_base_general_audio"
LOCAL_BASE_DIR="ZhenYe234/hubert_base_general_audio"
REQUIRED_FILES=(config.json  model.safetensors )
wget_required_list

echo "Download facebook/hubert-base-ls960..."
MODEL_REPO_URL="https://hf-mirror.com"
MODEL_REPO_ID="facebook/hubert-base-ls960"
LOCAL_BASE_DIR="facebook/hubert-base-ls960"
REQUIRED_FILES=(config.json  preprocessor_config.json  pytorch_model.bin  README.md  tf_model.h5 )
wget_required_list

echo "Download microsoft/wavlm-base-plus..."
MODEL_REPO_URL="https://hf-mirror.com"
MODEL_REPO_ID="microsoft/wavlm-base-plus"
LOCAL_BASE_DIR="microsoft/wavlm-base-plus"
REQUIRED_FILES=(config.json  preprocessor_config.json  pytorch_model.bin  README.md )
wget_required_list

:<<'REM'

用法：
运行本脚本，会在当前目录下创建models目录，并下载几乎用到的所有模型文件。
确保空间够用。

对于docker容器，挂载卷 models 到容器内 /app/models 目录: -v ${VOLUMES}/models:/app/models 。

已知问题
长时间使用 hf-mirror.com 会造成限速。本文件下载调用 wget 支持断点续传。

REM
