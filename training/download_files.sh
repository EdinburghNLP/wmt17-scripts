#!/bin/bash

script_dir=`dirname $0`

#language-independent variables (toolkit locations)
. $script_dir/../vars

# get EN-DE training data for WMT17

if [ ! -f downloads/de-en.tgz ];
then
  wget http://www.statmt.org/europarl/v7/de-en.tgz -O downloads/de-en.tgz
fi

if [ ! -f downloads/dev.tgz ];
then
  wget http://data.statmt.org/wmt17/translation-task/dev.tgz -O downloads/dev.tgz
fi


# unpack and concatenate
cd downloads/
tar -xf de-en.tgz
tar -xf dev.tgz

cat europarl-v7.de-en.en > ../data/corpus.en
cat europarl-v7.de-en.de > ../data/corpus.de

for year in 2013;
do
  $moses_scripts/ems/support/input-from-sgm.perl < dev/newstest${year}-ref.de.sgm > ../data/newstest$year.de
  $moses_scripts/ems/support/input-from-sgm.perl < dev/newstest${year}-src.en.sgm > ../data/newstest$year.en
done

for year in 2014;
do
  $moses_scripts/ems/support/input-from-sgm.perl < dev/newstest${year}-deen-ref.de.sgm > ../data/newstest$year.de
  $moses_scripts/ems/support/input-from-sgm.perl < dev/newstest${year}-deen-src.en.sgm > ../data/newstest$year.en
done

for year in {2015,2016};
do
  $moses_scripts/ems/support/input-from-sgm.perl < dev/newstest${year}-ende-ref.de.sgm > ../data/newstest$year.de
  $moses_scripts/ems/support/input-from-sgm.perl < dev/newstest${year}-ende-src.en.sgm > ../data/newstest$year.en
done

cd ..
