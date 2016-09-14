#!python
#cython: language_level=3, boundscheck=False, wraparound=False, initializedcheck=False, nonecheck=False, overflowcheck=False, cdivision=True
import time
import math

cdef int gcd(int a, int b):
    cdef int shift = 0, t
    while (a | b) & 1 == 0:
        a >>= 1
        b >>= 1
        shift += 1

    while a & 1 == 0:
        a >>= 1

    while True:
        while b&1 == 0:
            b >>= 1

        if a > b:
            t = a
            a = b
            b = t

        b = b - a
        if b == 0:
            break

    return a << shift


def nextIndex(start, step, limit):
    return (start + step) % limit


def juggle_swap_uninlined(xs, start):
    length = len(xs)
    gcdresult = math.gcd(length, start)
    for i in range(gcdresult):
        t = xs[i]
        prev = i
        next = i + start
        while next != i:
            xs[prev] = xs[next]
            prev = next
            next = nextIndex(next, start, length)
        xs[prev] = t


cdef int nextIndexc(int start, int step, int limit):
    return (start + step) % limit


cdef void juggle_swap_uninlined_c(int xs[], int start, int length):
    cdef int gcdresult, t, prev, next, i
    gcdresult = gcd(length, start)
    for i in range(gcdresult):
        t = xs[i]
        prev = i
        next = i + start
        while next != i:
            xs[prev] = xs[next]
            prev = next
            next = nextIndexc(next, start, length)
        xs[prev] = t


def juggle_swap(xs, start):
    length = len(xs)
    gcdresult = math.gcd(length, start)
    for i in range(gcdresult):
        t = xs[i]
        prev = i
        next = i + start
        while next != i:
            xs[prev] = xs[next]
            prev = next
            next = (next + start) % length
        xs[prev] = t


cdef void juggle_swap_c(int cc[], int start, int length):
    cdef int gcdresult = gcd(length, start)
    cdef int t, prev, next
    cdef int i
    for i in range(gcdresult):
        t = cc[i]
        prev = i
        next = i + start
        while next != i:
            cc[prev] = cc[next]
            prev = next
            next = (next + start) % length
        cc[prev] = t

def reverse(xs, a, b):
    while b > a:
        t = xs[a]
        xs[a] = xs[b]
        xs[b] = t
        b -= 1
        a += 1

def reverse_swap(xs, start):
    length = len(xs)
    reverse(xs, 0, start - 1)
    reverse(xs, start, length - 1)
    reverse(xs, 0, length - 1)

cdef void reverse_c(int xs[], int a, int b):
    while b > a:
        t = xs[a]
        xs[a] = xs[b]
        xs[b] = t
        b -= 1
        a += 1

cdef void reverse_swap_c(int xs[], int start, int length):
    reverse_c(xs, 0, start - 1)
    reverse_c(xs, start, length - 1)
    reverse_c(xs, 0, length - 1)

cdef int derp[10000]
cdef int i
for i in range(10000):
    derp[i] = i

def profile_reverse():
    for i in range(10000):
        reverse_swap(derp, 700)


def profile_reverse_c():
    for i in range(10000):
        reverse_swap_c(derp, 700, 10000)


def profile_juggle():
    for i in range(10000):
        juggle_swap(derp, 700)


def profile_juggle_c():
    for i in range(10000):
        juggle_swap_c(derp, 700, 10000)


def profile_juggle_uninlined():
    for i in range(10000):
        juggle_swap_uninlined(derp, 700)

def profile_juggle_uninlined_c():
    for i in range(10000):
        juggle_swap_uninlined_c(derp, 700, 10000)


print("Welcome to the Cython Optimized Shuffles")

t1 = time.perf_counter()
profile_reverse()
t2 = time.perf_counter()
print("reverse swap: " + str(t2 - t1) + " seconds.")

t1 = time.perf_counter()
profile_reverse_c()
t2 = time.perf_counter()
print("reverse swap(Cython Optimized): " + str(t2 - t1) + " seconds.")

t1 = time.perf_counter()
profile_juggle()
t2 = time.perf_counter()
print("juggle swap(inlined): " + str(t2 - t1) + " seconds.")

t1 = time.perf_counter()
profile_juggle_c()
t2 = time.perf_counter()
print("juggle swap(inlined, Cython Optimized): " + str(t2 - t1) + " seconds.")

t1 = time.perf_counter()
profile_juggle_uninlined()
t2 = time.perf_counter()
print("juggle swap(uninlined): " + str(t2 - t1) + " seconds.")

t1 = time.perf_counter()
profile_juggle_uninlined_c()
t2 = time.perf_counter()
print("juggle swap(uninlined, Cython Optimized): " + str(t2 - t1) + " seconds.")
