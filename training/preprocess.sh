#!/bin/sh

# this sample script preprocesses a sample corpus, including tokenization,
# truecasing, and subword segmentation.
# for application to a different language pair,
# change source and target prefix, optionally the number of BPE operations,

script_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $script_dir/../vars


#language-dependent variables (source and target language)
. $script_dir/vars

# number of merge operations. Network vocabulary should be slightly larger (to include characters),
# or smaller if the operations are learned on the joint vocabulary
bpe_operations=90000

#minimum number of times we need to have seen a character sequence in the training text before we merge it into one unit
#this is applied to each training text independently, even with joint BPE
bpe_threshold=50

# tokenize
for prefix in corpus newstest2013 newstest2014 newstest2015 newstest2016
 do
   cat data/$prefix.$src | \
   $moses_sripts/tokenizer/normalize-punctuation.perl -l $src | \
   $moses_scripts/tokenizer/tokenizer.perl -a -l $src > data/$prefix.tok.$src

   cat data/$prefix.$trg | \
   $moses_scripts/tokenizer/normalize-punctuation.perl -l $trg | \
   $moses_scripts/tokenizer/tokenizer.perl -a -l $trg > data/$prefix.tok.$trg

 done

# clean empty and long sentences, and sentences with high source-target ratio (training corpus only)
$moses_scripts/training/clean-corpus-n.perl data/corpus.tok $src $trg data/corpus.tok.clean 1 80

# train truecaser
$moses_scripts/recaser/train-truecaser.perl -corpus data/corpus.tok.clean.$src -model model/truecase-model.$src
$moses_scripts/recaser/train-truecaser.perl -corpus data/corpus.tok.clean.$trg -model model/truecase-model.$trg

# apply truecaser (cleaned training corpus)
for prefix in corpus
 do
  $moses_scripts/recaser/truecase.perl -model model/truecase-model.$src < data/$prefix.tok.clean.$src > data/$prefix.tc.$src
  $moses_scripts/recaser/truecase.perl -model model/truecase-model.$trg < data/$prefix.tok.clean.$trg > data/$prefix.tc.$trg
 done

# apply truecaser (dev/test files)
for prefix in newstest2013 newstest2014 newstest2015 newstest2016
 do
  $moses_scripts/recaser/truecase.perl -model model/truecase-model.$src < data/$prefix.tok.$src > data/$prefix.tc.$src
  $moses_scripts/recaser/truecase.perl -model model/truecase-model.$trg < data/$prefix.tok.$trg > data/$prefix.tc.$trg
 done

# train BPE
$bpe_scripts/learn_joint_bpe_and_vocab.py -i data/corpus.tc.$src data/corpus.tc.$trg --write-vocabulary data/vocab.$src data/vocab.$trg -s $bpe_operations -o model/$src$trg.bpe

# apply BPE

for prefix in corpus newstest2013 newstest2014 newstest2015 newstest2016
 do
  $bpe_scripts/apply_bpe.py -c model/$src$trg.bpe --vocabulary data/vocab.$src --vocabulary-threshold $bpe_threshold < data/$prefix.tc.$src > data/$prefix.bpe.$src
  $bpe_scripts/apply_bpe.py -c model/$src$trg.bpe --vocabulary data/vocab.$trg --vocabulary-threshold $bpe_threshold < data/$prefix.tc.$trg > data/$prefix.bpe.$trg
 done

# build network dictionary
$nematus_home/data/build_dictionary.py data/corpus.bpe.$src data/corpus.bpe.$trg

