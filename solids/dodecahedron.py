#!/usr/bin/python3

# A very lazy and perverse way to compute the vertices of a Dodecahedron.

from math import cos, sin, tau
import random
import scipy.optimize

from vector import Vector

def rz(phi, r, z):
    return Vector(r * cos(phi), r * sin(phi), z)

def points(h1, h2, r):
    row1 = tuple(rz(i * tau / 5, 1, 0 ) for i in range(5))
    row2 = tuple(rz(i * tau / 5, r, h1) for i in range(5))
    row3 = tuple(rz((i + 0.5) * tau / 5, r, h2) for i in range(5))
    row4 = tuple(rz((i + 0.5) * tau / 5, 1, h1 + h2) for i in range(5))
    return row1, row2, row3, row4

def quality(h1, h2, r):
    rows = points(h1, h2, r)
    d1 = rows[0][0].dist(rows[0][1])
    d2 = rows[0][0].dist(rows[1][0])
    d3 = rows[1][0].dist(rows[2][0])
    diff2 = d2 - d1
    diff3 = d3 - d1
    v1 = rows[1][0] - rows[0][0]
    v2 = rows[2][0] - rows[0][0]
    v3 = rows[0][1] - rows[0][0]
    c = v1.cross(v2).dot(v3)
    return diff2 * diff2 + diff3 * diff3 + 100 * c * c

res = scipy.optimize.minimize(lambda x: quality(x[0], x[1], x[2]),
                              [1, 1.6, 1.6], tol=1e-24, method='Powell',
                              options = {'maxiter': 10000})
print(res)
h1, h2, r = res.x
print(points(h1, h2, r))
