import 'package:get/get.dart';
import 'package:money_diary/app/module/account/service/account_service.dart';

import '../../../data/model/account_group_model.dart';
import '../../../data/model/account_model.dart';

class AccountController extends GetxController {
  var accountGroups = <AccountGroup>[].obs;
  var filteredAccountGroups = <AccountGroup>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs; // reactive list

  var accountService = AccountService();

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();

    // 🔹 Reactively filter groups based on search
    ever(searchQuery, (_) => applyFilter());
  }

  // 🔹 Fetch accounts from DB and group by type
  Future<void> fetchAccounts() async {
    isLoading.value = true;
    try {
      final groups = await accountService.getAccountsGroupedByType();
      accountGroups.assignAll(groups);
      applyFilter(); // apply search filter
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Filter accounts by search query
  void applyFilter() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredAccountGroups.assignAll(accountGroups);
      return;
    }

    final List<AccountGroup> filtered = [];
    for (var group in accountGroups) {
      final accounts = group.accounts
          .where((a) => a.name.toLowerCase().contains(query))
          .toList();
      if (accounts.isNotEmpty) {
        filtered.add(AccountGroup(type: group.type, accounts: accounts));
      }
    }
    filteredAccountGroups.assignAll(filtered);
  }

  void refreshAccountList(String type, Account account) {
    final index = accountGroups.indexWhere((g) => g.type == type);

    if (index != -1) {
      // Wrap inner list in RxList to make it reactive
      final currentAccounts = accountGroups[index].accounts;
      currentAccounts.add(account);
      accountGroups[index] = AccountGroup(
        type: accountGroups[index].type,
        accounts: List<Account>.from(currentAccounts),
      ); // trigger update
    } else {
      accountGroups.add(AccountGroup(type: type, accounts: [account]));
    }

    accountGroups.refresh();
    applyFilter(); // update filtered list as well
  }


  /// Get accounts by type
  List<Account> getAccountsByType(String type) {
    return accountGroups.firstWhereOrNull((g) => g.type == type)?.accounts ??
        [];
  }
}
