#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

./preprocess.sh | \
THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device python $nematus_home/nematus/translate.py \
     -m model.l2r.ens1.npz \
     -k 12 -n -p 1 --suppress-unk | \
./postprocess.sh
