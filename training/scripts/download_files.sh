#!/bin/bash

script_dir=`dirname $0`
main_dir=$script_dir/..

#language-independent variables (toolkit locations)
. $script_dir/../vars

# get EN-DE training data for WMT17

if [ ! -f $main_dir/downloads/de-en.tgz ];
then
  wget http://www.statmt.org/europarl/v7/de-en.tgz -O $main_dir/downloads/de-en.tgz
fi

if [ ! -f $main_dir/downloads/dev.tgz ];
then
  wget http://data.statmt.org/wmt17/translation-task/dev.tgz -O $main_dir/downloads/dev.tgz
fi


# unpack and concatenate
tar -xf $main_dir/downloads/de-en.tgz
tar -xf $main_dir/downloads/dev.tgz

cat $main_dir/downloads/europarl-v7.de-en.en > $main_dir/data/corpus.en
cat $main_dir/downloads/europarl-v7.de-en.de > $main_dir/data/corpus.de

for year in 2013;
do
  $moses_scripts/ems/support/input-from-sgm.perl < $main_dir/downloads/dev/newstest${year}-ref.de.sgm > $main_dir/data/newstest$year.de
  $moses_scripts/ems/support/input-from-sgm.perl < $main_dir/downloads/dev/newstest${year}-src.en.sgm > $main_dir/data/newstest$year.en
done

for year in 2014;
do
  $moses_scripts/ems/support/input-from-sgm.perl < $main_dir/downloads/dev/newstest${year}-deen-ref.de.sgm > $main_dir/data/newstest$year.de
  $moses_scripts/ems/support/input-from-sgm.perl < $main_dir/downloads/dev/newstest${year}-deen-src.en.sgm > $main_dir/data/newstest$year.en
done

for year in {2015,2016};
do
  $moses_scripts/ems/support/input-from-sgm.perl < $main_dir/downloads/dev/newstest${year}-ende-ref.de.sgm > $main_dir/data/newstest$year.de
  $moses_scripts/ems/support/input-from-sgm.perl < $main_dir/downloas/dev/newstest${year}-ende-src.en.sgm > $main_dir/data/newstest$year.en
done

cd ..
