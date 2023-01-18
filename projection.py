#!/usr/bin/python3

import stl
import sys
import math

def minmax_r(m):
    by_x = {}

    for xx, yy, zz in zip(list(m.x), list(m.y), list(m.z)):
        for x, y, z in zip(list(xx), list(yy), list(zz)):
            r = math.hypot(y, z)
            m, M = by_x.get(x, (r, r))
            by_x[x] = min(m, r), max(M, r)

    d3 = []
    for x, (y, Y) in by_x.items():
        d3.append((x, y))
        d3.append((x, Y))

    d3.sort()
    return d3

for p in sys.argv[1:]:
    print(p)
    m = stl.mesh.Mesh.from_file(p)
    d3 = minmax_r(m)
    csv = open(p.removesuffix('.stl') + '.csv', 'w')
    for x, y in d3:
        print(x, y, file=csv, sep=',')
