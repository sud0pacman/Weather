import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_now/data/source/local/favourite_entity.dart';
import 'package:weather_now/utils/constants.dart';

class HiveHelper {
  static const String _favouriteBoxName = "favourites";

  HiveHelper() {
    _initDb();
  }

  Future<void> _initDb() async {
    // Initialize Hive if it hasn't been initialized
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(FavouriteEntityAdapter().typeId)) {
      Hive.registerAdapter(FavouriteEntityAdapter());
    }
    // Open the box for FavouriteEntity
    await Hive.openBox<FavouriteEntity>(_favouriteBoxName);
  }

  // Future<int> addFavourite(FavouriteEntity favourite) async {
  //   final box = Hive.box<FavouriteEntity>(_favouriteBoxName);
  //   // Save the entity and return its index
  //   return await box.add(favourite);
  // }

  // Future<List<FavouriteEntity>> getAllFavourites() async {
  //   final box = Hive.box<FavouriteEntity>(_favouriteBoxName);
  //   return box.values.toList(); // Return all stored entities
  // }

  // Future<void> deleteFavourite(int index) async {
  //   final box = Hive.box<FavouriteEntity>(_favouriteBoxName);
  //   await box.deleteAt(index); // Delete the record by index
  // }

  // FavouriteEntity? getByLatLon(double lat, double lon) {
  //   final box = Hive.box<FavouriteEntity>(_favouriteBoxName);
  //
  //   // Search for the entity with the given latitude and longitude
  //   return box.values.cast<FavouriteEntity?>().firstWhere(
  //         (favourite) => favourite?.lat == lat && favourite?.lon == lon,
  //     orElse: () => null, // Return null if no match is found
  //   );
  // }
}
