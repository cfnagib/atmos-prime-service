import math

def get_primes(start: int, end: int):
    """
    High-Performance Prime Generation using the Sieve of Eratosthenes.
    
    DESIGN CHOICE:
    Instead of trial division (O(n*sqrt(n))), I implemented the Sieve algorithm 
    which operates at O(n log log n) complexity. For a space logistics platform 
    handling large telemetry datasets, this efficiency is critical to minimize 
    latency and compute costs.
    """
    if start > end or end < 2:
        return []
    
    limit = end + 1
    sieve = [True] * limit
    sieve[0] = sieve[1] = False
    
    # We only need to sieve up to the square root of the end value
    for p in range(2, int(math.sqrt(end)) + 1):
        if sieve[p]:
            # Mark multiples as non-prime starting from p*p
            for i in range(p * p, limit, p):
                sieve[i] = False
                
    return [p for p in range(max(2, start), limit) if sieve[p]]