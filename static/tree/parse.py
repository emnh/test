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


class SimpleNode(object):

    def __init__(self, **kw):
        self.__dict__.update(kw)
        self.children = collections.OrderedDict()
        super(SimpleNode, self).__init__()

    @property
    def children(self):
        return self._children

    @children.setter
    def children(self, value):
        self._children = value

class Tree(object):

    def __init__(self, NodeCls = SimpleNode):
        self.NodeCls = NodeCls
        self.root = self.NodeCls(path='/', title='')

    def ensurePath(self, path, key):
        def rec(components, parent):
            name, *rest = components
            if not name in parent.children:
                parent.children[name] = self.NodeCls(path=path, title=name, key=key)
            if rest:
                rec(rest, parent.children[name])
        components = path.split("/")[1:]
        return rec(components, self.root)

def mkfancytree(tree, path, extraClasses):
    ft = []
    od = tree.children
    for k, v in sorted(od.items()):
        node = {
                'title': k,
                'key': v.key,
                'extraClasses': ' '.join(extraClasses(v.key))
               }
        if v.children:
            node.update({
                    'folder': True,
                    'children': mkfancytree(v, path + '/' + k, extraClasses)
                    })
            node['extraClasses'] = ''
            # only give class to parents if all children have it
            if any((c['extraClasses'] == 'duplicate') for c in node['children']):
                node['extraClasses'] = 'some_duplicate'
            if all((c['extraClasses'] == 'first') for c in node['children']):
                node['extraClasses'] = 'first'
            if all((c['extraClasses'] == 'duplicate') for c in node['children']):
                node['extraClasses'] = 'duplicate'
            if all((c['extraClasses'] == 'unique') for c in node['children']):
                node['extraClasses'] = 'unique'
        ft.append(node)
    return ft

def main():
    'entry point'
    fname = sys.argv[1]

    with open(fname, encoding='utf-8', errors='ignore') as f:
        content = f.readlines()

    #content = content[:1000]

    t = Tree()
    hashes = {}
    classes = {}

    i = 0
    linect = len(content)
    for line in content:
        if '/' in line:
            i += 1
            #if i % int(linect / 100) == 0:
            #    print('%d%% done' % (i * 100 / linect))
            match = re.search('/.*', line)
            path = match.group(0)
            t.ensurePath(path, i)

            md5sum = line.split("  ", 1)[0]
            if not md5sum in hashes:
                hashes[md5sum] = [i]
                classes[i] = ['unique']
            else:
                firsti = hashes[md5sum][0]
                classes[firsti] = ['first'] # first of duplicate set
                hashes[md5sum].append(i)
                classes[i] = ['duplicate']

    ft = mkfancytree(t.root, '/', lambda key: classes[key])
    #pprint(ft)
    print(json.dumps(ft))

if __name__ == '__main__':
    main()

