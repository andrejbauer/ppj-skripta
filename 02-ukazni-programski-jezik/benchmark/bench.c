#include <stdio.h>

int main() {
  /* The sum of primes below n */
  const long n = 1000000 ;
  printf("%ld\n", n);
  long s = 0 ;
  long k = 2 ;
  int i ;
  int isPrime ;
  while (k < n) {
    i = 2 ;
    isPrime = 1 ;
    while ((isPrime == 1) && (i * i < k + 1)) {
        if (k % i == 0) {
          isPrime = 0 ;
        } else { }
        i = i + 1 ;
    }
    if (isPrime == 1) {
      s = s + k;
    }
    else { }
    k = k + 1 ;
  }
  printf("%ld\n", s);
}
