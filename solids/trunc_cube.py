#!/usr/bin/python3

from math import *
from scipy.spatial import ConvexHull
from vector import Vector

# ratio * sqrt(2) = 1 - 2 * ratio
# ratio * (2 + sqrt(2)) = 1
# ratio = 1 / (2 + sqrt(2))
# ratio = (2 - sqrt(2)) / 2 = 1 - sqrt(0.5)
r1 = 1 - sqrt(0.5)
r2 = sqrt(0.5)

cube = []
for x in 0,1:
    for y in 0,1:
        for z in 0,1:
            cube.append(Vector(x,y,z))

points = []
for maj in cube:
    for min in cube:
        if maj != min and abs(maj.dist(min) - 1) < 0.01:
            points.append(maj * r2 + min * r1)

hull = ConvexHull(points)
#print(hull.vertices)
#print(hull.simplices)

print('scale(sqrt(2) * 50) polyhedron(points=[')

for x, y, z in points:
    print(f'[{x},{y},{z}],')

print('], faces = [')

for a, b, c in hull.simplices:
    print(f'[{a},{b},{c}],')

print(']);')
