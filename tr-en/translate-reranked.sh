#!/bin/bash

model_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $model_dir/../vars

# temporary files
tmpfile_src=`mktemp`
tmpfile_nbest=`mktemp`
tmpfile_reverse=`mktemp`

./preprocess.sh > $tmpfile_src

#left-to-right n-best list
THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device python $nematus_home/nematus/translate.py < $tmpfile_src \
     -m model.l2r.ens{1,2,3,4}.npz \
     -k 50 -p 2 --n-best --suppress-unk > $tmpfile_nbest

#need to reverse the source file
../scripts/reverse.py < $tmpfile_src > $tmpfile_reverse

#rescoring
../scripts/reverse_nbest.py < $tmpfile_nbest | \
THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device python $nematus_home/nematus/rescore.py  \
     -m model.r2l.ens{1,2,3,4}.npz \
     -b 10 -s $tmpfile_reverse | \
../scripts/rerank_normalize.py 50 1 | \
../scripts/reverse.py | \
./postprocess.sh

rm $tmpfile_src
rm $tmpfile_nbest
rm $tmpfile_reverse
