#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: ft=python ts=4 sw=4 sts=4 et fenc=utf-8
# Original author: "Eivind Magnus Hvidevold" <hvidevold@gmail.com>
# License: GNU GPLv3 at http://www.gnu.org/licenses/gpl.html

'''
parse all paths from a log file into a JSON tree for browsing
'''

import os
import sys
import re
import json
from pprint import pprint
import collections


class Tree(object):

    def __init__(self):

        self.root = {}

    def ensurePath(self, components, parent=None):
        first, *rest = components
        if parent == None:
            parent = self.root
        if not first in parent:
            parent[first] = {}
        if rest:
            self.ensurePath(rest, parent[first])

def mkfancytree(tree):
    ft = []
    od = collections.OrderedDict(sorted(tree.items()))
    for k, v in od.items():
        if v:
            node = {
                    'title': k,
                    'key': k,
                    'folder': True,
                    'children': mkfancytree(v)
                    }
        else:
            node = {
                    'title': k,
                    'key': k
                    }
        ft.append(node)
    return ft

def main():
    'entry point'
    fname = sys.argv[1]

    with open(fname, encoding='utf-8', errors='ignore') as f:
        content = f.readlines()

    #content = content[:20]

    t = Tree()
    for line in content:
        if '/' in line:
            match = re.search('/.*', line)
            path = match.group(0)
            components = path.split("/")[1:]
            t.ensurePath(components)
            #print(components)

    ft = mkfancytree(t.root)
    print(json.dumps(ft))

if __name__ == '__main__':
    main()

