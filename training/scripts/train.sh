#!/bin/sh

script_dir=`dirname $0`
main_dir=$script_dir/../
data_dir=$main_dir/data
working_dir=$main_dir/model

#language-independent variables (toolkit locations)
. $main_dir/../vars

#language-dependent variables (source and target language)
. $main_dir/vars

THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device,gpuarray.preallocate=0.8 python $nematus_home/nematus/nmt.py \
    --model $working_dir/model.npz \
    --datasets $data_dir/corpus.bpe.$src $data_dir/corpus.bpe.$trg \
    --valid_datasets $data_dir/newstest2013.bpe.$src $data_dir/newstest2013.bpe.$trg \
    --dictionaries $data_dir/corpus.bpe.$src.json $data_dir/corpus.bpe.$trg.json \
    --external_validation_script $script_dir/validate.sh \
    --reload \
    --dim_word 512 \
    --dim 1024 \
    --lrate 0.0001 \
    --optimizer adam \
    --maxlen 50 \
    --batch_size 80 \
    --valid_batch_size 40 \
    --validFreq 10000 \
    --dispFreq 1000 \
    --saveFreq 30000 \
    --sampleFreq 10000 \
    --tie_decoder_embeddings \
    --layer_normalisation \
    --dec_base_recurrence_transition_depth 8 \
    --enc_recurrence_transition_depth 4

