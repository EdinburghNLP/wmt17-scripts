#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

# src and trg language
src=en
trg=tr

# remove BPE, detruecase, detokenize
sed 's/\@\@ //g' | \
$moses_scripts/recaser/detruecase.perl | \
$moses_scripts/tokenizer/detokenizer.perl -l $trg
