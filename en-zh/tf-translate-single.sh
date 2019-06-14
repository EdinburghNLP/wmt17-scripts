#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

#language-dependent variables (source and target language)
. $model_dir/vars

$model_dir/preprocess.sh | \
CUDA_VISIBLE_DEVICES=$device python3 $nematus_home/nematus/translate.py \
     -m $model_dir/model.l2r.ens1.npz \
     -k 12 -n | \
$model_dir/postprocess.sh
