#!/usr/bin/python3

# A very lazy and perverse way to compute the vertices of an Icosohedron.

from math import cos, sin, tau
import random
import scipy.optimize

from vector import Vector

def rz(phi, r, z):
    return Vector(r * cos(phi), r * sin(phi), z)

def points(h1, h2, r):
    row1 = tuple(rz(i * tau / 3, 1, 0 ) for i in range(3))
    row2 = tuple(rz(i * tau / 3, r, h1) for i in range(3))
    row3 = tuple(rz((i + 0.5) * tau / 3, r, h2) for i in range(3))
    row4 = tuple(rz((i + 0.5) * tau / 3, 1, h1 + h2) for i in range(3))
    return row1, row2, row3, row4

def quality(h1, h2, r):
    rows = points(h1, h2, r)
    d1 = rows[0][0].dist(rows[0][1])
    d2 = rows[0][0].dist(rows[1][0])
    d3 = rows[0][0].dist(rows[2][0])
    d4 = rows[1][0].dist(rows[2][0])
    diff2 = d2 - d1
    diff3 = d3 - d1
    diff4 = d4 - d1
    return diff2 * diff2 + diff3 * diff3 + diff4 * diff4

res = scipy.optimize.minimize(lambda x: quality(x[0], x[1], x[2]),
                              [1, 1, 1], tol=1e-24, method='Powell',
                              options = {'maxiter': 10000})
print(res)
h1, h2, r = res.x
print(points(h1, h2, r))
