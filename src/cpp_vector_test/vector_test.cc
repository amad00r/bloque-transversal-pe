#include <iostream>
#include <vector>
#include <chrono>
#include "mergesort.hh"
using namespace std;

int main() {
    unsigned size;
    cin >> size;
    vector<int> v(size);
    for (int &x : v) cin >> x;

    auto start = chrono::high_resolution_clock::now();
    mergesort(v);
    auto end = chrono::high_resolution_clock::now();

    cout << chrono::duration_cast<chrono::milliseconds>(end - start).count() << endl;
}