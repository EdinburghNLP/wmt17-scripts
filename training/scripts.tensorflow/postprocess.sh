#!/bin/sh
# Distributed under MIT license

# this sample script postprocesses the MT output,
# including merging of BPE subword units,
# detruecasing, and detokenization

script_dir=`dirname $0`
main_dir=$script_dir/../

#language-independent variables (toolkit locations)
. $main_dir/../vars

#language-dependent variables (source and target language)
. $main_dir/vars

sed -r 's/\@\@ //g' |
$moses_scripts/recaser/detruecase.perl |
$moses_scripts/tokenizer/detokenizer.perl -l $trg
