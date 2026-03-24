def get_primes(start: int, end: int):
    """
    Generates prime numbers in the range [start, end] using Sieve of Eratosthenes.
    """
    if start > end or end < 2:
        return []
    
    limit = end + 1
    sieve = [True] * limit
    sieve[0] = sieve[1] = False
    
    for p in range(2, int(end**0.5) + 1):
        if sieve[p]:
            for i in range(p * p, limit, p):
                sieve[i] = False
                
    return [p for p in range(max(2, start), limit) if sieve[p]]