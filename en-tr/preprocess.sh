#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

# src and trg language
src=en
trg=tr

$moses_scripts/tokenizer/normalize-punctuation.perl -l $src | \
$moses_scripts/tokenizer/tokenizer.perl -a -l $src | \
$moses_scripts/recaser/truecase.perl -model truecase-model.$src | \
$bpe_scripts/apply_bpe.py -c $src$trg.bpe
