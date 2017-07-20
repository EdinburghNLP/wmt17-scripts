#!/bin/sh

# this sample script postprocesses the MT output,
# including merging of BPE subword units,
# detruecasing, and detokenization

script_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $script_dir/../vars

#language-dependent variables (source and target language)
. $script_dir/vars

sed -r 's/\@\@ //g' |
$moses_scripts/recaser/detruecase.perl |
$moses_scripts/tokenizer/detokenizer.perl -l $trg
