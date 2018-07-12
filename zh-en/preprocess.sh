#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

#language-dependent variables (source and target language)
. $model_dir/vars

export PYTHONPATH=$jieba_home
python -m jieba -d | \
$bpe_scripts/apply_bpe.py -c $model_dir/bpe.model.$src
