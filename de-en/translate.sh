#!/bin/bash

cur_dir=`dirname $0`
. $cur_dir/../vars

$cur_dir/preprocess.sh | \
THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device python $nematus_home/nematus/translate.py \
     -m model.npz \
     -k 12 -n -p 1 --suppress-unk | \
$cur_dir/postprocess.sh
