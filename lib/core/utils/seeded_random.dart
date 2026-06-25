class SeededRandom {
  int _seed;

  SeededRandom(int seed) : _seed = seed;

  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
