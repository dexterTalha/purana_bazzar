
import 'package:purana_bazzar/models/ad_model.dart';

import 'favourite_storage.dart';

class AdsFavorites {

  FavoritesStorage storage = FavoritesStorage();
  List<AdModel> favorites = [];

  Future<List<AdModel>> readAllFavorites() async {
    favorites = await storage.readFavorites();
    return favorites;
  }

  Future addFavorite(AdModel ad) async {
    if (!favorites.any((p) => p.id == ad.id)) {
      favorites.add(ad);
      await storage.writeFavorites(favorites);
    }
  }

  Future removeFavorite(AdModel ad) async {
    favorites.removeWhere((p) => p.id == ad.id);

    await storage.writeFavorites(favorites);
  }

  bool isFavorite(AdModel ad) {
    return favorites.any((p) => p.id == ad.id);
  }
}