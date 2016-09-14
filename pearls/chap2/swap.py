import array
import math
import cProfile


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


derp = array.array("i", range(10000))
def profile_reverse():
    for i in range(10000):
        reverse_swap(derp, 700)

def profile_juggle():
    for i in range(10000):
        juggle_swap(derp, 700)

def profile_juggle_uninlined():
    for i in range(10000):
        juggle_swap_uninlined(derp, 700)


a = cProfile.run("profile_reverse()")
b = cProfile.run("profile_juggle()")
c = cProfile.run("profile_juggle_uninlined()")

