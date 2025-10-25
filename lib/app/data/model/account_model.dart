import 'dart:convert';

class Account {
  final int? id;
  final String type;
  final String name;
  final String? accountNumber;
  final double initialBalance;
  final double currentBalance;
  final String? icon;
  final bool includeInNetWorth;
  final int transactionCount;
  final bool isActive;
  final bool isDeleted;

  // 🔸 Type-specific fields
  final double? creditLimit;
  final double? outstandingBalance;
  final double? interestRate;
  final String? billingDate;
  final String? dueDate;
  final double? maxUtilisationRatio;
  final bool? alertEnabled;

  final String? contactName;
  final String? contactNumber;
  final String? contactEmail;

  final String? memberName;
  final String? relation;

  Account({
    this.id,
    required this.type,
    required this.name,
    this.accountNumber,
    this.initialBalance = 0.0,
    this.currentBalance = 0.0,
    this.icon,
    required this.includeInNetWorth,
    this.transactionCount = 0,
    this.isActive = true,
    this.isDeleted = false,
    this.creditLimit,
    this.outstandingBalance,
    this.interestRate,
    this.billingDate,
    this.dueDate,
    this.maxUtilisationRatio,
    this.alertEnabled,
    this.contactName,
    this.contactNumber,
    this.contactEmail,
    this.memberName,
    this.relation,
  });

  // -------------------------
  // 🔹 CopyWith
  // -------------------------
  Account copyWith({
    int? id,
    String? type,
    String? name,
    String? accountNumber,
    double? initialBalance,
    double? currentBalance,
    String? icon,
    bool? includeInNetWorth,
    int? transactionCount,
    bool? isActive,
    bool? isDeleted,
    double? creditLimit,
    double? outstandingBalance,
    double? interestRate,
    String? billingDate,
    String? dueDate,
    double? maxUtilisationRatio,
    bool? alertEnabled,
    String? contactName,
    String? contactNumber,
    String? contactEmail,
    String? memberName,
    String? relation,
  }) {
    return Account(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      icon: icon ?? this.icon,
      includeInNetWorth: includeInNetWorth ?? this.includeInNetWorth,
      transactionCount: transactionCount ?? this.transactionCount,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      creditLimit: creditLimit ?? this.creditLimit,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      interestRate: interestRate ?? this.interestRate,
      billingDate: billingDate ?? this.billingDate,
      dueDate: dueDate ?? this.dueDate,
      maxUtilisationRatio: maxUtilisationRatio ?? this.maxUtilisationRatio,
      alertEnabled: alertEnabled ?? this.alertEnabled,
      contactName: contactName ?? this.contactName,
      contactNumber: contactNumber ?? this.contactNumber,
      contactEmail: contactEmail ?? this.contactEmail,
      memberName: memberName ?? this.memberName,
      relation: relation ?? this.relation,
    );
  }

  // -------------------------
  // 🔹 Generic methods (common fields)
  // -------------------------
  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json['id'] as int?,
    type: json['type'] as String,
    name: json['name'] as String,
    accountNumber: json['account_number'] as String?,
    initialBalance: (json['initial_balance'] ?? 0).toDouble(),
    currentBalance: (json['current_balance'] ?? 0).toDouble(),
    icon: json['icon'] as String?,
    includeInNetWorth: (json['include_in_net_worth'] == 1),
    transactionCount: json['transaction_count'] ?? 0,
    isActive: (json['is_active'] == 1),
    isDeleted: (json['is_deleted'] == 1),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'account_number': accountNumber,
      'initial_balance': initialBalance,
      'current_balance': currentBalance,
      'icon': icon,
      'include_in_net_worth': includeInNetWorth ? 1 : 0,
      'transaction_count': transactionCount,
      'is_active': isActive ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  // -------------------------
  // 🔹 Bank / Cash / Wallet
  // -------------------------
  Map<String, dynamic> toBankMap() => toMap();
  factory Account.fromBankJson(Map<String, dynamic> json) => Account.fromJson(json);

  // -------------------------
  // 🔹 Credit Card
  // -------------------------
  Map<String, dynamic> toCreditCardMap() {
    final map = toMap();
    map.addAll({
      'credit_limit': creditLimit,
      'outstanding_balance': outstandingBalance,
      'billing_date': billingDate,
      'due_date': dueDate,
      'max_utilisation_ratio': maxUtilisationRatio,
      'alert_enabled': alertEnabled == true ? 1 : 0,
    });
    return map;
  }

  factory Account.fromCreditCardJson(Map<String, dynamic> json) {
    final acc = Account.fromJson(json);
    return acc.copyWith(
      creditLimit: (json['credit_limit'] as num?)?.toDouble(),
      outstandingBalance: (json['outstanding_balance'] as num?)?.toDouble(),
      billingDate: json['billing_date'] as String?,
      dueDate: json['due_date'] as String?,
      maxUtilisationRatio: (json['max_utilisation_ratio'] as num?)?.toDouble(),
      alertEnabled: json['alert_enabled'] == 1,
    );
  }

  // -------------------------
  // 🔹 Lending
  // -------------------------
  Map<String, dynamic> toLendingMap() {
    final map = toMap();
    map.addAll({
      'contact_name': contactName,
      'contact_number': contactNumber,
      'contact_email': contactEmail,
    });
    return map;
  }

  factory Account.fromLendingJson(Map<String, dynamic> json) {
    final acc = Account.fromJson(json);
    return acc.copyWith(
      contactName: json['contact_name'] as String?,
      contactNumber: json['contact_number'] as String?,
      contactEmail: json['contact_email'] as String?,
    );
  }

  // -------------------------
  // 🔹 Family Account
  // -------------------------
  Map<String, dynamic> toFamilyMap() {
    final map = toMap();
    map.addAll({
      'member_name': memberName,
      'relation': relation,
    });
    return map;
  }

  factory Account.fromFamilyJson(Map<String, dynamic> json) {
    final acc = Account.fromJson(json);
    return acc.copyWith(
      memberName: json['member_name'] as String?,
      relation: json['relation'] as String?,
    );
  }

  // -------------------------
  // 🔹 Line of Credit
  // -------------------------
  Map<String, dynamic> toLoCMap() {
    final map = toMap();
    map.addAll({
      'credit_limit': creditLimit,
      'initial_balance': initialBalance,
    });
    return map;
  }

  factory Account.fromLoCJson(Map<String, dynamic> json) {
    final acc = Account.fromJson(json);
    return acc.copyWith(
      creditLimit: (json['credit_limit'] as num?)?.toDouble(),
      initialBalance: (json['initial_balance'] as num?)?.toDouble(),
    );
  }
}
