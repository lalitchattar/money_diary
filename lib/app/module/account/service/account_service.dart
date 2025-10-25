

import '../../../data/model/account_group_model.dart';
import '../../../data/model/account_model.dart';
import '../../../data/repository/account_repository.dart';


class AccountService {
  final repo = AccountRepository();

  Future<List<Account>> getAllAccounts() async {
    final rows = await repo.getAllAccounts();
    return rows.map((row) => Account.fromJson(row)).toList();
  }

  Future<List<AccountGroup>> getAccountsGroupedByType() async {
    final accounts = await getAllAccounts();
    final Map<String, List<Account>> grouped = {};

    for (var acc in accounts) {
      grouped.putIfAbsent(acc.type, () => []).add(acc);
    }

    return grouped.entries.map((e) => AccountGroup(type: e.key, accounts: e.value)).toList();
  }

  Future<Account> addAccount(Account account) async {
    final id = await repo.insert(account.toMap());
    return account.copyWith(id: id);
  }

  Future<void> updateAccount(Account account) async {
    if (account.id != null) {
      await repo.update(account.id!, account.toMap());
    }
  }

  Future<void> deleteAccount(int id) async {
    await repo.softDelete(id);
  }

  Future<List<Account>> getAccountsByType(String type) async {
    final rows = await repo.getByType(type);
    return rows.map((row) => Account.fromJson(row)).toList();
  }
}
