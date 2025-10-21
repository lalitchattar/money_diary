class Label {
  int? id;
  String name;
  String color;
  bool isActive;
  bool isDeleted;
  int transactionCount;

  Label({
    this.id,
    required this.name,
    required this.color,
    this.isActive = true,
    this.isDeleted = false,
    this.transactionCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'is_active': isActive ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'transaction_count': transactionCount,
    };
  }

  factory Label.fromMap(Map<String, dynamic> map) {
    return Label(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      isActive: map['is_active'] == 1,
      isDeleted: map['is_deleted'] == 1,
      transactionCount: map['transaction_count'] ?? 0,
    );
  }
}