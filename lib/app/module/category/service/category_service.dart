
import 'package:money_diary/app/data/repository/category_repository.dart';

import '../../../data/model/category_model.dart';
import '../../../utils/app_logger.dart';

class CategoryService {

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
    'assets/icons/family.png'
  ];

  var repo = CategoryRepository();

  Future<List<Category>> getAllCategories() async {
    try{
      return await repo.getAllCategories();
    } catch(e, stack) {
      appLogger.e('Error creating category:', error: e, stackTrace: stack);
      return [];
    }

  }

  Future<Category?> createCategory(String name, String type, String icon) async {
    var category = Category(name: name.trim(), type: type, icon: icon);
    try {
      return await repo.createCategory(category);
    } catch (e, stack) {
      appLogger.e('Error creating category:', error: e, stackTrace: stack);
      rethrow;
    }
  }


  Future<bool> isNameExists(String categoryName, String categoryType) async {
    final category = await repo.getCategoryByName(categoryName.trim(), categoryType);
    return category != null;
  }

  Future<void> updateCategory(Category category, List<String>? fieldsToUpdate) async {
    try {
      await repo.updateCategory(category, fieldsToUpdate: fieldsToUpdate);
    } catch (e, stack) {
      appLogger.e('Error updating category:', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<Category?> getCategory(int id) async {
    return await repo.getCategory(id);
  }

  Future<Category?> getCategoryByName(String name, String categoryType) async {
    return await repo.getCategoryByName(name, categoryType);
  }

  Future<void> deactivateCategory(int id) => repo.deactivateCategory(id);
  Future<void> activateCategory(int id) => repo.activateCategory(id);
  Future<void> deleteCategory(int id) => repo.deleteCategory(id);


}