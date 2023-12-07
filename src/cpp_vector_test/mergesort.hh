using namespace std;

void __merge(vector<int> &v, int l, int m, int r) {
    vector<int> tmp(r - l + 1);
    int i = l;
    int j = m + 1;
    int k = 0;
    while (i <= m and j <= r) {
        if (v[i] <= v[j]) tmp[k++] = v[i++];
        else tmp[k++] = v[j++];
    }
    while (i <= m) tmp[k++] = v[i++];
    while (j <= r) tmp[k++] = v[j++];
    for (k = 0; k <= r - l; ++k) v[l + k] = tmp[k];
}

void __mergesort(vector<int> &v, int l, int r) {
    if (l < r) {
        int m = (l + r)/2;
        __mergesort(v, l, m);
        __mergesort(v, m + 1, r);
        __merge(v, l, m, r);
    }
}

void mergesort(vector<int> &v) {
    __mergesort(v, 0, v.size() - 1);
}