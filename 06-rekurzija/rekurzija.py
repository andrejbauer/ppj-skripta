def faktoriela(n):
    if n == 0:
        return 1
    else:
        return n * faktoriela(n - 1)

def telo(f,n):
    if n == 0:
        return 1
    else:
        return n * f (n - 1)

def faktoriela2(n):
    return telo(faktoriela2, n)
