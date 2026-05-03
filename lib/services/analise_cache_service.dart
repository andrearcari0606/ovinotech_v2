class AnaliseCacheService {

  static final Map<int, dynamic> _cache = {};

  static getAnalise(int animalId) {
    return _cache[animalId];
  }

  static setAnalise(int animalId, dynamic resultado) {
    _cache[animalId] = resultado;
  }

  static clear(int animalId) {
    _cache.remove(animalId);
  }

  static clearAll() {
    _cache.clear();
  }
}