#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

#language-dependent variables (source and target language)
. $model_dir/vars

$model_dir/preprocess.sh | \
THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device python $nematus_home/nematus/translate.py \
     -m /home/bhaddow/experiments/wmt17/cs-en/translate/model.lr.0.fixed.npz \
     -k 12 -n -p 1  | \
$model_dir/postprocess.sh
