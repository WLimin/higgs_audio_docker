#!/bin/bash
# 目标：容易删除容器且不再次下载
echo "Apply some source file patch..."

:<<'REM_B4'

REM_B4
sed -i -e "s#bosonai/higgs-audio-v2-generation-3B-base#${APP_WORKDIR}/models/higgs-audio-v2-generation-3B-base#g" ${APP_WORKDIR}/app.py
sed -i -e "s#bosonai/higgs-audio-v2-tokenizer#${APP_WORKDIR}/models/higgs-audio-v2-tokenizer#g" ${APP_WORKDIR}/app.py
sed -i -e "s#ZhenYe234/hubert_base_general_audio#${APP_WORKDIR}/models/ZhenYe234/hubert_base_general_audio#g" ${APP_WORKDIR}/higgs_audio/audio_processing/higgs_audio_tokenizer.py
sed -i -e "s#facebook/hubert-base-ls960#${APP_WORKDIR}/models/facebook/hubert-base-ls960#g" ${APP_WORKDIR}/higgs_audio/audio_processing/higgs_audio_tokenizer.py
sed -i -e "s#microsoft/wavlm-base-plus#${APP_WORKDIR}/models/microsoft/wavlm-base-plus#g" ${APP_WORKDIR}/higgs_audio/audio_processing/higgs_audio_tokenizer.py

echo "done."
