import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class IconPreloader {
  static Future<void> preloadAll(BuildContext context) async {
    await Future.wait([
      _preloadAssetIcons(context),
      _preloadAppDirectoryImages(context),
    ]);
  }

  // ✅ Preload bundled asset icons
  static Future<void> _preloadAssetIcons(BuildContext context) async {
    final icons = [
      'assets/icons/cake.png',
      'assets/icons/pastry.png',
      'assets/icons/chocolate.png',
      'assets/icons/pet-care.png',
      'assets/icons/pet-food.png',
      'assets/icons/decoration.png',
      'assets/icons/concert.png',
      'assets/icons/anniversary.png',
      'assets/icons/celebration.png',
      'assets/icons/card.png',
      'assets/icons/fireworks.png',
      'assets/icons/pets.png',
      'assets/icons/furniture.png',
      'assets/icons/festival.png',
      'assets/icons/gold.png',
      'assets/icons/game-console.png',
      'assets/icons/card-game.png',
      'assets/icons/circus-tent.png',
      'assets/icons/cricket.png',
      'assets/icons/kite.png',
      'assets/icons/investment.png',
      'assets/icons/computer.png',
      'assets/icons/webinar.png',
      'assets/icons/tuition.png',
      'assets/icons/airplane.png',
      'assets/icons/train.png',
      'assets/icons/amusement.png',
      'assets/icons/sweets.png',
      'assets/icons/ice-cream.png',
      'assets/icons/bus.png',
      'assets/icons/interior-design.png',
      'assets/icons/cafe.png',
      'assets/icons/coffee.png',
      'assets/icons/kitchen.png',
      'assets/icons/cook.png',
      'assets/icons/maid.png',
      'assets/icons/child.png',
      'assets/icons/security-guard.png',
      'assets/icons/ambulance.png',
      'assets/icons/fire-vehicle.png',
      'assets/icons/temple.png',
      'assets/icons/flower-pot.png',
      'assets/icons/bouquet.png',
      'assets/icons/gardening.png',
      'assets/icons/agriculture.png',
      'assets/icons/chemical.png',
      'assets/icons/beauty.png',
      'assets/icons/bills.png',
      'assets/icons/books.png',
      'assets/icons/carpenter.png',
      'assets/icons/cashback.png',
      'assets/icons/categories.png',
      'assets/icons/cashback.png',
      'assets/icons/construction.png',
      'assets/icons/courier.png',
      'assets/icons/dinner.png',
      'assets/icons/discount.png',
      'assets/icons/dividend.png',
      'assets/icons/doctor.png',
      'assets/icons/donation.png',
      'assets/icons/education.png',
      'assets/icons/electrician.png',
      'assets/icons/electricity.png',
      'assets/icons/electronics.png',
      'assets/icons/entertainment.png',
      'assets/icons/fast_food.png',
      'assets/icons/fine.png',
      'assets/icons/food-and-drink.png',
      'assets/icons/freelance.png',
      'assets/icons/fuel.png',
      'assets/icons/gadgets.png',
      'assets/icons/gas.png',
      'assets/icons/gift.png',
      'assets/icons/groceries.png',
      'assets/icons/health.png',
      'assets/icons/housekeeping.png',
      'assets/icons/insurance.png',
      'assets/icons/interest.png',
      'assets/icons/iron.png',
      'assets/icons/jewellery.png',
      'assets/icons/kids.png',
      'assets/icons/lottery.png',
      'assets/icons/maintenance.png',
      'assets/icons/medicine.png',
      'assets/icons/milk.png',
      'assets/icons/movie.png',
      'assets/icons/necklace.png',
      'assets/icons/parking.png',
      'assets/icons/recharge.png',
      'assets/icons/rent.png',
      'assets/icons/salary.png',
      'assets/icons/sale.png',
      'assets/icons/saving.png',
      'assets/icons/sell.png',
      'assets/icons/shopping.png',
      'assets/icons/stationery.png',
      'assets/icons/t-shirts.png',
      'assets/icons/tax.png',
      'assets/icons/taxi.png',
      'assets/icons/television.png',
      'assets/icons/toy.png',
      'assets/icons/trading.png',
      'assets/icons/transport.png',
      'assets/icons/travel.png',
      'assets/icons/utility.png',
      'assets/icons/vacation.png',
      'assets/icons/vegetable.png',
      'assets/icons/voucher.png',
      'assets/icons/vegetable.png',
      'assets/icons/voucher.png',
      'assets/icons/water-tap.png',
      'assets/icons/wedding.png',
      'assets/icons/plates.png',
      'assets/icons/cookware.png',
      'assets/icons/bank.png',
      'assets/icons/dollar.png',
      'assets/icons/wallet.png',
      'assets/icons/borrow.png',
      'assets/icons/credit.png',
      'assets/icons/line-of-credit.png',
      'assets/icons/retirement.png',
      'assets/icons/brokerage.png',
      'assets/icons/investment.png',
      'assets/icons/bitcoin.png',
      'assets/icons/loan.png',
      'assets/icons/mortgage.png',
      'assets/icons/debt.png',
      'assets/icons/assets.png',
      'assets/icons/family.png',
      'assets/icons/default_merchant.png'
    ];

    await Future.wait(
      icons.map((path) => precacheImage(AssetImage(path), context)),
    );
  }

  // ✅ Preload user or app directory images (e.g., saved category/merchant icons)
  static Future<void> _preloadAppDirectoryImages(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final appDir = Directory(directory.path);

    if (!appDir.existsSync()) return;

    final imageFiles = appDir
        .listSync(recursive: true)
        .where((f) => f is File && _isImageFile(f.path))
        .cast<File>()
        .toList();

    await Future.wait(
      imageFiles.map((file) => precacheImage(FileImage(file), context)),
    );
  }

  // Helper function to check image file extensions
  static bool _isImageFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
  }
}
