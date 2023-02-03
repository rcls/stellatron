#!/usr/bin/python

from itertools import product
from math import sqrt
from vector import Vector

points = []

phi = (1 + sqrt(5)) / 2
iphi = 1 / phi

names = {0: "0", 1: "+1", -1: "-1",
         phi: "+phi", -phi: "-phi", 1/phi: "+iphi", -1/phi: "-iphi"}

def name(v):
    x, y, z = v
    return f"[{names[x]},{names[y]},{names[z]}]"

for i, j, k in product((1, -1), (1, -1), (1, -1)):
    points.append(Vector(i, j, k))

for i, j in product((phi, -phi), (1/phi, -1/phi)):
    points.append(Vector(i, j, 0))
    points.append(Vector(0, i, j))
    points.append(Vector(j, 0, i))

def near(*pp):
    l = list(points)
    l.sort(key = lambda x: sum((p - x).nsq() for p in pp))
    for x in l[:11]:
        print(name(x))

# Top, clockwise looking down.  ring1 is highest.
ring1 = [Vector(1,1,1), Vector(iphi, 0, phi), Vector(-iphi, 0, phi),
         Vector(-1, 1, 1), Vector(0, phi, iphi)]

ring2 = [Vector(phi, iphi, 0),
         Vector(1, -1, 1),
         Vector(-1, -1, 1),
         Vector(-phi, iphi, 0),
         Vector(0,phi,-iphi)]

ring3 = [Vector(phi, -iphi, 0),
         Vector(0, -phi, +iphi),
         Vector(-phi, -iphi, 0),
         Vector(-1, 1, -1),
         Vector(1, 1, -1)]

ring4 = [Vector(1, -1, -1),
         Vector(0, -phi, -iphi),
         Vector(-1, -1, -1),
         Vector(-iphi, 0, -phi),
         Vector(iphi, 0, -phi)]

#for x, y in zip(ring3, (ring3 + ring3)[4:]):
#    print(x.dist(y))
