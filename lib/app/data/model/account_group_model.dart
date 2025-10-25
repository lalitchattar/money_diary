import 'dart:convert';
import 'account_model.dart';

class AccountGroup {
  final String type;
  final List<Account> accounts;

  AccountGroup({required this.type, required this.accounts});

  factory AccountGroup.fromRow(Map<String, dynamic> row) {
    final List<dynamic> accountList = row['accounts'] != null
        ? List<Map<String, dynamic>>.from(jsonDecode(row['accounts']))
        : [];
    return AccountGroup(
      type: row['type'],
      accounts: accountList.map((a) => Account.fromJson(a)).toList(),
    );
  }

  /// Returns a new AccountGroup with the new account added
  AccountGroup addAccount(Account account) {
    return AccountGroup(
      type: type,
      accounts: [...accounts, account], // create a new list with added account
    );
  }
}
