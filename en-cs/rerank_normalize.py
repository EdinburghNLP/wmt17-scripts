#!/usr/bin/python
# -*- coding: utf-8 -*-
# Author: Rico Sennrich
# Distributed under MIT license

import sys
from collections import defaultdict

if __name__ == '__main__':

    if len(sys.argv) != 3:
        sys.stderr.write("usage: %s K ALPHA\n" % sys.argv[0])
        sys.exit(1)
    k = float(sys.argv[1])
    alpha = float(sys.argv[2])

    cur = 0
    best_score = float('inf')
    best_sent = ''
    idx = 0
    for line in sys.stdin:
        num, sent, scores = line.split(' ||| ')

        # new input sentence: print best translation of previous sentence, and reset stats
        if int(num) > cur:
            print best_sent
            #print best_score
            cur = int(num)
            best_score = float('inf')
            best_sent = ''
            idx = 0

        #only consider k-best hypotheses
        if idx >= k:
            continue

        if len(sent.split()) == 0:
            continue

        score = sum(map(float, scores.split())) / (len(sent.split()))**alpha
        if score < best_score:
            best_score = score
            best_sent = sent.strip()

        idx += 1

    # end of file; print best translation of last sentence
    print best_sent
#    print best_score

