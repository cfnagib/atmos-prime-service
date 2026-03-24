def get_primes(start: int, end: int) -> list[int]:
    if end < 2 or start > end:
        return []

    limit = end + 1
    sieve = [True] * limit
    sieve[0] = False
    if limit > 1:
        sieve[1] = False

    for i in range(2, int(limit**0.5) + 1):
        if sieve[i]:
            for j in range(i * i, limit, i):
                sieve[j] = False

    return [n for n in range(max(start, 2), limit) if sieve[n]]
