# THE UNIVERSITY OF EDINBURGH'S WMT17 SYSTEMS
-------------------------------------------

This directory contains some of the University of Edinburgh's
submissions to the WMT17 shared translation task, and a 'training'
directory with scripts to preprocess and train your own model.

If you are accessing this through a git repository, it will contain all scripts and documentation,
but no model files - the models are accessible at http://data.statmt.org/wmt17_systems

Use the git repository to keep track of changes to this directory: https://github.com/EdinburghNLP/wmt17-scripts

REQUIREMENTS
------------

The models use the following software:

 - moses decoder (scripts only; no compilation required) https://github.com/moses-smt/mosesdecoder
 - nematus (theano version): https://github.com/EdinburghNLP/nematus/tree/theano
 - subword-nmt https://github.com/rsennrich/subword-nmt

Please set the appropriate paths in the 'vars' file.


DOWNLOAD INSTRUCTIONS
---------------------

you can download all files in this directory with this command:

```
wget -r -e robots=off -nH -np -R index.html* http://data.statmt.org/wmt17_systems/
```

to download just one language pair (such as en-de), execute:

```
wget -r -e robots=off -nH -np -R index.html* http://data.statmt.org/wmt17_systems/en-de/
```

to download just a single model (approx 2GB) and the corresponding translation scripts, ignoring ensembles, execute:

```
wget -r -e robots=off -nH -np -R *ens2* -R *ens3* -R *ens4* -R *r2l* -R translate-ensemble.sh -R translate-reranked.sh -R index.html* http://data.statmt.org/wmt17_systems/en-de/
```

if you only download selected language pairs or models, you should also download these files which are shared:

```
wget -r -e robots=off -nH -np -R index.html* http://data.statmt.org/wmt17_systems/scripts/ http://data.statmt.org/wmt17_systems/vars
```


USAGE INSTRUCTIONS: PRE-TRAINED MODELS
--------------------------------------

first, ensure that all requirements are present, and that the path names in the 'vars' file are up-to-date.
If you want to decode on a GPU, you can also update the 'device' variable in that file.

each subdirectory comes with several scripts translate-*.sh.

For translation with a single model, execute:

```
./translate-single.sh < your_input_file > your_output_file
```

the input should be UTF-8 plain text in the source language, one sentence per line.

We also provide ensembles of left-to-right models:

```
./translate-ensemble.sh < your_input_file > your_output_file
```

For some language pairs, we built models that use right-to-left models for reranking:

```
./translate-reranked.sh < your_input_file > your_output_file
```

We used systems that include ensembles and right-to-left reranking for
our official submissions; result may vary slightly from the official
submissions due to post-submission improvements - see the shared task
description for more details.

USAGE INSTRUCTIONS: TRAINING SCRIPTS
------------------------------------

For training your own models, follow the instructions in `training/README.md`

LICENSE
-------

All scripts in this directory are distributed under MIT license.

The use of the models provided in this directory is permitted under
the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
license (CC BY-NC-SA 3.0):
https://creativecommons.org/licenses/by-nc-sa/3.0/

Attribution - You must give appropriate credit [please use the
citation below], provide a link to the license, and indicate if
changes were made. You may do so in any reasonable manner, but not in
any way that suggests the licensor endorses you or your use.

NonCommercial - You may not use the material for commercial purposes.

ShareAlike - If you remix, transform, or build upon the material, you
must distribute your contributions under the same license as the
original.


REFERENCE
---------

The models are described in the following publication:

Rico Sennrich, Alexandra Birch, Anna Currey, Ulrich Germann, Barry Haddow, Kenneth Heafield, Antonio Valerio Miceli Barone, and Philip Williams (2017).
"The University of Edinburgh’s Neural MT Systems for WMT17".
In: _Proceedings of the Second Conference on Machine Translation, Volume 2: Shared Task Papers_.
Copenhagen, Denmark.

<pre class=bibtex>
@inproceedings{uedin-nmt:2017,
    address = "Copenhagen, Denmark",
    author = "Sennrich, Rico and Birch, Alexandra and Currey, Anna and 
              Germann, Ulrich and Haddow, Barry and Heafield, Kenneth and 
              {Miceli Barone}, Antonio Valerio and Williams, Philip",
    booktitle = "{Proceedings of the Second Conference on Machine Translation, 
                 Volume 2: Shared Task Papers}",
    title = "{The University of Edinburgh's Neural MT Systems for WMT17}",
    year = "2017"
}
</pre>
