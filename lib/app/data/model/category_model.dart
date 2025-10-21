class Category {
  int? id;
  String name;
  String type; //Income, Expense or Bill
  String? icon;
  bool isActive;
  bool isDeleted;
  int transactionCount;

  Category({
    this.id,
    required this.name,
    required this.type,
    this.icon,
    this.isActive = true,
    this.isDeleted = false,
    this.transactionCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'is_active': isActive ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'transaction_count': transactionCount,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      icon: map['icon'],
      isActive: map['is_active'] == 1,
      isDeleted: map['is_deleted'] == 1,
      transactionCount: map['transaction_count'] ?? 0,
    );
  }
}