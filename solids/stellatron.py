#!/usr/bin/python3

import math
import numpy.linalg
from vector import Vector

numpy.linalg.solve

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

def polar(r, i, z):
    theta = math.pi / 3 * i
    return Vector(r * math.cos(theta), r * math.sin(theta), z)

def A(i):
    return polar(       2, i*2,    -gold - 1)
def B(i):
    return polar(gold * 2, i*2 + 1, 1 - gold)
def C(i):
    return polar(gold * 2, i*2,     gold - 1)
def D(i):
    return polar(       2, i*2 + 1, gold + 1)

def ico_points():
    ll = [[], [], [], []]
    ff = [A, B, C, D]
    for i in range(3):
        for l, f in zip(ll, ff):
            l.append(f(i))
    return sum(ll, [])

def calc_ico_faces():
    # We are lazy.
    pp = ico_points()
    faces = []
    assert len(pp) == 12
    for i, p in enumerate(pp):
        for j, q in enumerate(pp[:i]):
            for k, r in enumerate(pp[:j]):
                if abs(p.dist(q) - 3.464) < 0.1 and \
                   abs(p.dist(r) - 3.464) < 0.1 and \
                   abs(q.dist(r) - 3.464) < 0.1:
                    faces.append((p, q, r))
    assert len(faces) == 20
    return faces

#print(ico_faces())

def near(l, x):
    for y in l:
        if abs(x - y) < 1e-10:
            return y
    assert False, x

factors = [1, 2, 3, 4]
factors = factors + [-x for x in factors]
factors = factors + [x / 5 for x in factors]
factors = factors + [0, 1/2, -1/2]
basic = [x + y * gold for x in factors for y in factors]

pA = Vector(1, 0, 0)
pB = Vector(-0.5, math.sqrt(3)/2, 0)
pC = Vector(-0.5, -math.sqrt(3)/2, 0)

def p_norm(s):
    return (pA * s[0] + pB * s[1] + pC * s[2]).norm()

def is_canon(s):
    return abs(s[0]) >= abs(s[1]) >= abs(s[2]) \
        and (s[0] != -s[1] or s[0] >= 0) \
        and (s[1] != -s[2] or s[1] >= 0)

def calc_raw_stell_points():
    faces = calc_ico_faces()
    stells = {}
    for i in range(1, 20):
        for j in range(i+1, 20):
            try:
                s = tri_intersect(faces[0], faces[i], faces[j])
                if all(abs(x) < 1e15 for x in s):
                    s = tuple(near(basic, x) for x in s[0:3])
                    if is_canon(s):
                        stells[s] = stells.get(s, 0) + 1
            except numpy.linalg.LinAlgError as e:
                pass

    return sorted(list(stells.items()),
                  key=lambda s: (p_norm(s[0]), abs(s[0][0])))

raw_stell_points = calc_raw_stell_points()

def rational(x):
    if x == 0:
        return 0, 0
    x10 = abs(x) * 10
    rx10 = round(x10)
    fx10 = x10 - rx10
    sign = x / abs(x)
    for n in range(-10, 200):
        ng = n * gold
        rng = round(ng)
        fng = ng - rng
        if abs(fx10 - fng) < 1e-6:
            # x10 = n * gold - rng + rx10
            return sign * n / 10, sign * (rx10 - rng) / 10
    return 0, x

def describe(x):
    #print(rational(x))
    (cp, ci) = rational(x)
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

for s, n in raw_stell_points:
    print(describe(s[0]), describe(s[1]), describe(s[2]),
          n,
          (A(0) * s[0] + A(1) * s[1] + A(2) * s[2]).norm() / math.sqrt(6 + 3 * gold),
          sep='\t')

def applys(stell, face):
    sa, sb, sc = stell
    (ax, ay, az), (bx, by, bz), (cx, cy, cz) = face
    return Vector(
        (sa*ax + sb*bx + sc*cx),
        (sa*ay + sb*by + sc*cy),
        (sa*az + sb*bx + sc*cz))

def rotv(v):
    return Vector(v.y, v.z, v.x)

raw_ico_points = [Vector(0, s, t * gold) for s in (1, -1) for t in (1, -1)]
raw_ico_points = raw_ico_points + [rotv(v) for v in raw_ico_points] \
    + [rotv(rotv(v)) for v in raw_ico_points]

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

coords = []
for stell, n in raw_stell_points:
    for face in ico_faces:
        for c in applys(stell, face):
            coords.append(abs(c))

coords = list(set(coords))
coords.sort()
print(coords)

for c in sorted(list(set(describe(c) for c in coords))):
    print(c)
