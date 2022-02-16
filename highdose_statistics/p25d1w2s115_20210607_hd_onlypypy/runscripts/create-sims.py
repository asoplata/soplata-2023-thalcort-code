#!/bin/python

import os
import random
import shutil

iterations = 199

prefix = 'p25d1w2s115'
suffix = '_20210607_hd_onlypypy'

with open('master-runscript.sh', 'w') as mf:
    mf.write('#!/bin/bash\n\nmatlab -r ' + prefix + 'i001' + suffix + '\n')

with open('master-runscript.sh', 'a') as mf:
    for ii in range(iterations):
        newfile = prefix + 'i{0:03}'.format(ii+2) + suffix + '.m'
        shutil.copyfile(prefix + 'i001' + suffix + '.m', newfile)

        # from https://stackoverflow.com/questions/4128144/replace-string-within-file-contents/4128199#4128199
        with open(newfile) as ff:
            newtext = ff.read().replace('2222',str(random.randrange(9999999)))

        with open(newfile,'w') as ff:
            ff.write(newtext)

        mf.write('matlab -r {}\n'.format(os.path.splitext(newfile)[0]))

os.system("chmod +x master-runscript.sh")


