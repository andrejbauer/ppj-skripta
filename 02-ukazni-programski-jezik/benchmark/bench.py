# The sum of primes below n
n = 1000000
print(n)
s = 0
k = 2
while k < n:
  i = 2
  isPrime = True
  while isPrime and i * i < k + 1:
    if k % i == 0:
        isPrime = False
    else:
        pass
    i = i + 1
  if isPrime:
      s = s + k
  else:
      pass
  k = k + 1
print(s)
