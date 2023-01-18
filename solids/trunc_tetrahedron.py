#!/usr/bin/python3

from math import *
from scipy.spatial import ConvexHull

a = (1, 0, 0)
b = (cos(tau / 3), sin(tau / 3), 0)
c = (cos(tau / 3), -sin(tau / 3), 0)

d0 = a[0] - b[0]
d1 = a[1] - b[1]
#print(d0, d1)
height = sqrt(d0 * d0 + d1 * d1  - 1)

d = (0, 0, height)

tetra = [a,b,c,d]
points = []

for maj in tetra:
    for min in tetra:
        if maj != min:
            points.append(tuple((2 * M + m) / 3 for M, m in zip(maj, min)))

hull = ConvexHull(points)
#print(hull.vertices)
#print(hull.simplices)

print('scale(50) polyhedron(points=[')

for x, y, z in points:
    print(f'[{x},{y},{z}],')

print('], faces = [')

for a, b, c in hull.simplices:
    print(f'[{a},{b},{c}],')

print(']);')
