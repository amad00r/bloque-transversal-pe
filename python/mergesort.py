def __merge(v, l, m, r):
    tmp = list()

    i = l
    j = m + 1
 
    while i <= m and j <= r:
        if v[i] <= v[j]:
            tmp.append(v[i])
            i += 1
        else:
            tmp.append(v[j])
            j += 1

    while i <= m:
        tmp.append(v[i])
        i += 1
    while j <= r:
        tmp.append(v[j])
        j += 1

    k = 0
    while k <= r - l:
        v[l + k] = tmp[k]
        k += 1
 
 
def __mergesort(v, l, r):
    if l < r:
        m = (r + l)//2
        __mergesort(v, l, m)
        __mergesort(v, m + 1, r)
        __merge(v, l, m, r)

def mergesort(v):
    __mergesort(v, 0, len(v) - 1)