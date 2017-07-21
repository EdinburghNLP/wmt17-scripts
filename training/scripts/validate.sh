#!/bin/sh

# this script evaluates the current model on newstest2013,
# using detokenized BLEU (equivalent to evaluation with
# mteval-v13a.pl).

# If BLEU improves, the model is copied to model.npz.best_bleu

script_dir=`dirname $0`
main_dir=$script_dir/../
data_dir=$main_dir/data
working_dir=$main_dir/model

#language-independent variables (toolkit locations)
. $main_dir/../vars

#language-dependent variables (source and target language)
. $main_dir/vars

dev_prefix=newstest2013
dev=$dev_prefix.bpe.$src
ref=$dev_prefix.$trg
prefix=$working_dir/model.npz


# decode
THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device,gpuarray.preallocate=0.1 time python $nematus_home/nematus/translate.py \
     -m $prefix.dev.npz \
     -i $data_dir/$dev -o $working_dir/$dev.output.dev -k 5 -n -p 1 --suppress-unk


$script_dir/postprocess.sh < $working_dir/$dev.output.dev > $working_dir/$dev.output.postprocessed.dev


## get BLEU
BEST=`cat ${prefix}_best_bleu || echo 0`
$nematus_home/data/multi-bleu-detok.perl $data_dir/$ref < $working_dir/$dev.output.postprocessed.dev >> ${prefix}_bleu_scores
BLEU=`$nematus_home/data/multi-bleu-detok.perl $data_dir/$ref < $working_dir/$dev.output.postprocessed.dev | cut -f 3 -d ' ' | cut -f 1 -d ','`
BETTER=`echo "$BLEU > $BEST" | bc`

echo "BLEU = $BLEU"

if [ "$BETTER" = "1" ]; then
  echo "new best; saving"
  echo $BLEU > ${prefix}_best_bleu
  cp ${prefix}.dev.npz ${prefix}.best_bleu
  cp ${prefix}.dev.npz.json ${prefix}.best_bleu.json
fi

