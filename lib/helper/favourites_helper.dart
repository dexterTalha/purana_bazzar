
import 'package:fluttertoast/fluttertoast.dart';
import '../models/ad_model.dart';

import 'favourite_storage.dart';

class AdsFavorites {

  FavoritesStorage storage = FavoritesStorage();
  List<AdModel> favorites = [];

  Future<List<AdModel>> readAllFavorites() async {
    favorites = await storage.readFavorites();
    return favorites;
  }

  Future addFavorite(AdModel ad) async {
    favorites = await readAllFavorites();
    if (!favorites.any((p) => p.id == ad.id)) {
      favorites.add(ad);
      await storage.writeFavorites(favorites);
      Fluttertoast.showToast(msg: "Added to favourites");
    }

  }

  Future removeFavorite(AdModel ad) async {
    await readAllFavorites();
    favorites.removeWhere((p) => p.id == ad.id);
    await storage.writeFavorites(favorites);
    Fluttertoast.showToast(msg: "Removed from favourites");
  }

  bool isFavorite(AdModel ad) {
    return favorites.any((element) => element.id == ad.id);
  }
}