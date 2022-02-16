#!/bin/python

import os
import shutil
import random

iterations = 199

with open('master-runscript.sh', 'w') as mf:
    mf.write('#!/bin/bash\n\nmatlab -r p25d1w2s7i001_tmax_ics\n')

with open('master-runscript.sh', 'a') as mf:
    for ii in range(iterations):
        newfile = 'p25d1w2s7i{0:03}_tmax_ics.m'.format(ii+2)
        shutil.copyfile('p25d1w2s7i001_tmax_ics.m', newfile)

        # from https://stackoverflow.com/questions/4128144/replace-string-within-file-contents/4128199#4128199
        with open(newfile) as ff:
            newtext = ff.read().replace('2222',str(random.randrange(9999999)))

        with open(newfile,'w') as ff:
            ff.write(newtext)

        mf.write('matlab -r {}\n'.format(os.path.splitext(newfile)[0]))
