class PremiumService {
  static final PremiumService _instance =
      PremiumService._internal();

  factory PremiumService() => _instance;

  PremiumService._internal();

  bool isPremium = false;

  bool get premiumAtivo => isPremium;

  void ativarPremium() {
    isPremium = true;
  }

  void desativarPremium() {
    isPremium = false;
  }
}