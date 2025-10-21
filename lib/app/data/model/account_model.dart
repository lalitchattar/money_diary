class Account {
  int? id;
  String name;
  String type; // e.g. 'bank', 'wallet', 'credit_card', 'fd', 'rd', etc.
  String? category; // 'asset', 'liability', 'investment'
  String? institutionName;
  String? accountNumber;
  double balance;
  double? creditLimit;
  double? interestRate;
  double? outstandingBalance;
  String? dueDate;
  String? billingDate;
  int transactionCount;
  bool showInNetWorth;
  bool isActive;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  Account({
    this.id,
    required this.name,
    required this.type,
    this.category,
    this.institutionName,
    this.accountNumber,
    this.balance = 0.0,
    this.creditLimit,
    this.interestRate,
    this.outstandingBalance,
    this.dueDate,
    this.billingDate,
    this.transactionCount = 0,
    this.showInNetWorth = false,
    this.isActive = true,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert model to Map (for SQLite insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'category': category,
      'institution_name': institutionName,
      'account_number': accountNumber,
      'balance': balance,
      'credit_limit': creditLimit,
      'interest_rate': interestRate,
      'outstanding_balance': outstandingBalance,
      'due_date': dueDate,
      'billing_date': billingDate,
      'transaction_count': transactionCount,
      'is_active': isActive ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'show_in_net_worth': showInNetWorth ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create model from Map (when fetching from SQLite)
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      category: map['category'],
      institutionName: map['institution_name'],
      accountNumber: map['account_number'],
      balance: (map['balance'] ?? 0.0).toDouble(),
      creditLimit: map['credit_limit'] != null ? (map['credit_limit'] as num).toDouble() : null,
      interestRate: map['interest_rate'] != null ? (map['interest_rate'] as num).toDouble() : null,
      outstandingBalance: map['outstanding_balance'] != null ? (map['outstanding_balance'] as num).toDouble() : null,
      dueDate: map['due_date'],
      billingDate: map['billing_date'],
      transactionCount: map['transaction_date'] ?? 0,
      showInNetWorth: map['show_in_net_worth'] == 1,
      isActive: map['is_active'] == 1,
      isDeleted: map['is_deleted'] == 1,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
