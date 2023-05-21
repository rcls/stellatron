#!/usr/bin/python3

from collections import namedtuple
from math import sqrt

VectorBase = namedtuple('VectorBase', ('x', 'y', 'z'))

class Vector(VectorBase):
    def __add__(self, u):
        return Vector(self.x + u.x, self.y + u.y, self.z + u.z)

    def __sub__(self, u):
        return Vector(self.x - u.x, self.y - u.y, self.z - u.z)

    def __mul__(self, u):
        return Vector(self.x * u, self.y * u, self.z * u)

    def __rmul__(self, u):
        return Vector(u * self.x, u * self.y, u * self.z)

    def __matmul__(self, u):
        return self.dot(u)

    def __str__(self):
        return f'[{self.x}, {self.y}, {self.z}]'

    def dot(self, u):
        return self.x * u.x + self.y * u.y + self.z * u.z

    def cross(self, u):
        return Vector(self.y * u.z - self.z * u.y,
                      self.z * u.x - self.x * u.z,
                      self.x * u.y - self.y * u.x)

    def nsq(self):
        return self.dot(self)

    def norm(self):
        return sqrt(self.nsq())

    def withnorm(self, n):
        return n / self.norm() * self

    def dist(self, u):
        return (self - u).norm()

    def tuple(self):
        return self.x, self.y, self.z
