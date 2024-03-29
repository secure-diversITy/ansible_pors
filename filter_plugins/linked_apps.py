#!/bin/env python
#########################################################################################
#
# find and return all enabled apps for each target group
#
#########################################################################################

import os
import re

# the PORS variable file
pors_varfile = os.path.expanduser("~/.pors/vars")

class FilterModule(object):
    def filters(self):
        return {
            'link_app_list': link_app_list
        }

def get_data_path():
    f = open(pors_varfile, 'r')
    for line in map(str.strip,f.read().splitlines()):
        line = line.split('=')
        if 'export DATADIR' == line[0]:
            data_path = line[1].strip('"')
            # we do not go on once found
            break
        elif re.match('^#(\s+)?export DATADIR', line[0]) is not None:
            # we do not break here as the user might has appended
            # instead of outcommenting
            data_path = line[1].strip('"')
    return data_path

def link_app_list(app, target_env):
    data_path = get_data_path()
    print(data_path)
    base_dir = data_path + '/inventories/' + target_env + '/group_vars/'
    eapp = {}
    mopp = {}
    overalldict = {}
    rolepath = 'apps'
    tgroups = os.listdir(base_dir)
    filecontent = []

    for capp in app:
        for tgroup in tgroups:
            fullpath = base_dir + tgroup + "/" + capp
            if os.path.isfile(fullpath):
                filecontent = open(fullpath).read()
            if filecontent:
                if re.search("\s+install:\s+[tT]rue",filecontent) or re.search("\s+delete:\s+[tT]rue",filecontent):
                    if not capp in mopp:
                        mopp[capp] = {"role":rolepath + "/" + capp, "tags":""}
                        mopp[capp]['tags'] = tgroup
                    else:
                        mopp[capp]['tags'] += ", " + tgroup

    return mopp.values()
