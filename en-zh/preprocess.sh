#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

#language-dependent variables (source and target language)
. $model_dir/vars

$moses_scripts/tokenizer/normalize-punctuation.perl -l $src | \
$moses_scripts/tokenizer/tokenizer.perl -a -l $src | \
$moses_scripts/recaser/truecase.perl -model $model_dir/truecase-model.$src | \
$bpe_scripts/apply_bpe.py -c $model_dir/bpe.model.$src
