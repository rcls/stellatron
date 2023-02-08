#!/usr/bin/python3

import math
import numpy.linalg
from vector import Vector

numpy.linalg.solve

'''Convert a number to our canonical golden ratio form'''
def rational(x):
    x10 = x * 10
    rx10 = round(x10)
    fx10 = x10 - rx10
    for n in list(range(-200, 210, 10)) \
        + list(range(-15, 16, 10)) \
        + list(range(-20, 21)):
        ng = n * gold
        rng = round(ng)
        fng = ng - rng
        if abs(fx10 - fng) < 1e-6:
            # x10 = n * gold - rng + rx10
            return n / 10, (rx10 - rng) / 10
    return 0, x

def describe(x):
    #print(rational(x))
    cp, ci = rational(x)
    if cp == int(cp):
        cp = int(cp)
    if ci == int(ci):
        ci = int(ci)
    if cp == 0:
        return f'{ci}'
    if ci == 0:
        ci = ''
    if cp == 1:
        return f'{ci}+ϕ'
    if cp == -1:
        return f'{ci}-ϕ'
    if cp < 0:
        return f'{ci}-{-cp}ϕ'
    return f'{ci}+{cp}ϕ'

def canonical(x):
    cp, ci = rational(x)
    return cp * gold + ci

def canonv(v):
    return Vector(canonical(v[0]), canonical(v[1]), canonical(v[2]))

def tri_intersect(a, b, c):
    return numpy.linalg.solve(
        [[1, 1, 1, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 1, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 1, 1, 1],
         [a[0].x, a[1].x, a[2].x, -b[0].x, -b[1].x, -b[2].x, 0, 0, 0],
         [a[0].y, a[1].y, a[2].y, -b[0].y, -b[1].y, -b[2].y, 0, 0, 0],
         [a[0].z, a[1].z, a[2].z, -b[0].z, -b[1].z, -b[2].z, 0, 0, 0],
         [0, 0, 0, b[0].x, b[1].x, b[2].x, -c[0].x, -c[1].x, -c[2].x],
         [0, 0, 0, b[0].y, b[1].y, b[2].y, -c[0].y, -c[1].y, -c[2].y],
         [0, 0, 0, b[0].z, b[1].z, b[2].z, -c[0].z, -c[1].z, -c[2].z],
         ],
        [1, 1, 1, 0, 0, 0, 0, 0, 0])

gold = (1 + math.sqrt(5)) / 2

def applys(stell, face):
    sa, sb, sc = stell
    A, B, C = face
    return sa * A + sb * B + sc * C

def rotv(v):
    return Vector(v.y, v.z, v.x)

ico_points = [Vector(0, s, t * gold) for s in (1, -1) for t in (1, -1)]
ico_points = ico_points + [rotv(v) for v in ico_points] \
    + [rotv(rotv(v)) for v in ico_points]

assert len(ico_points) == 12

def rott(t):
    return rotv(t[0]), rotv(t[1]), rotv(t[2])
def negt(t):
    return t[2] * -1, t[1] * -1, t[0] * -1

# Ico faces.
# 12 formed by a +-1 edge and another point.
# 8 formed by cycling zeros, one in each octant.
# (1,0,0), (0,1,0), (0,0,1) is anticlockwise looking through the triangle
# at the origin.  (We want anticlockwise faces).

ico_faces = [
    (Vector(-1, 0, gold), Vector( 1, 0, gold), Vector(0, -gold, 1)),
    (Vector( 1, 0, gold), Vector(-1, 0, gold), Vector(0,  gold, 1))]

ico_faces = ico_faces + [rott(t) for t in ico_faces] + \
    [rott(rott(t)) for t in ico_faces]

for sx in -1, 1:
    for sy in -1, 1:
        sz = sx * sy
        ico_faces.append(
            (Vector(0, sy, sz * gold),
             Vector(sx, sy * gold, 0),
             Vector(sx * gold, 0, sz)))

ico_faces = ico_faces + [negt(t) for t in ico_faces]

assert len(ico_faces) == 20

def near(l, x):
    for y in l:
        if abs(x - y) < 1e-10:
            return y
    assert False, x

def p_norm(s):
    return applys(s, ico_faces[0]).norm()

def is_canon(s):
    return abs(s[0]) >= abs(s[1]) >= abs(s[2]) \
        and (s[0] != -s[1] or s[0] >= 0) \
        and (s[1] != -s[2] or s[1] >= 0)

def calc_raw_stell_points():
    stells = {}
    for i in range(1, len(ico_faces)):
        for j in range(i+1, len(ico_faces)):
            try:
                s = tri_intersect(ico_faces[0], ico_faces[i], ico_faces[j])
                if all(abs(x) < 1e15 for x in s):
                    s = canonv(s)
                    assert s[0] == canonical(s[0])
                    assert s[1] == canonical(s[1])
                    assert s[2] == canonical(s[2])
                    if is_canon(s):
                        stells[s] = stells.get(s, 0) + 1
            except numpy.linalg.LinAlgError as e:
                pass

    return sorted(list(stells.items()),
                  key=lambda s: (p_norm(s[0]), abs(s[0][0])))

raw_stell_points = calc_raw_stell_points()

for s, n in raw_stell_points:
    print(describe(s[0]), describe(s[1]), describe(s[2]),
          n,
          p_norm(s) / ico_faces[0][0].norm(),
          sep='\t')

stell_points = set()
for stell, n in raw_stell_points:
    for face in ico_faces:
        stell_points.add(canonv(applys(stell, face)))
        stell_points.add(canonv(applys(stell, rott(face))))
        stell_points.add(canonv(applys(stell, rott(rott(face)))))

coords = []
for stell, n in raw_stell_points:
    for face in ico_faces:
        for c in applys(stell, face):
            coords.append(canonical(abs(c)))

coords.sort()
coords = list(dict.fromkeys(coords))

for c in coords:
    print(describe(c))

ratios = set()
for A in stell_points:
    for B in stell_points:
        ratio = canonical(A.norm() / B.norm())
        if ratio <= 1:
            continue
        if A.dist(B * ratio) < 1e-3:
            ratios.add((ratio, canonical(A.nsq()), canonical(B.nsq())))
print('Ratios')
for r, i, o in ratios:
    print(describe(r), describe(i), describe(o), math.sqrt(i/o))

for c in coords:
    print(describe(c))

rationals = { }
for c in coords:
    fc = c - round(c)
    p, i = rational(fc)
    rationals[p * gold + i] = (p, i)
    rationals[-p * gold - i] = (-p, -i)

for fx in sorted(rationals.keys()):
    p, i = rationals[fx]
    print(f'[{p} * gold + {i}, {p}, {i}], // {fx}')
