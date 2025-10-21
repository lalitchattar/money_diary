import 'dart:math';

class AccountDepositDetails {
  int? id;
  int accountId;
  String depositType; // 'fd' or 'rd'
  double principalAmount;
  double? recurringAmount;
  DateTime startDate;
  DateTime maturityDate;
  double interestRate;
  String compoundingFrequency; // quarterly, yearly, etc.
  int? termMonths;
  double? currentValue;
  double? maturityValue;
  String? notes;

  AccountDepositDetails({
    this.id,
    required this.accountId,
    required this.depositType,
    required this.principalAmount,
    this.recurringAmount,
    required this.startDate,
    required this.maturityDate,
    required this.interestRate,
    this.compoundingFrequency = 'quarterly',
    this.termMonths,
    this.currentValue,
    this.maturityValue,
    this.notes,
  });

  /// Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'deposit_type': depositType,
      'principal_amount': principalAmount,
      'recurring_amount': recurringAmount,
      'start_date': startDate.toIso8601String(),
      'maturity_date': maturityDate.toIso8601String(),
      'interest_rate': interestRate,
      'compounding_frequency': compoundingFrequency,
      'term_months': termMonths,
      'current_value': currentValue,
      'maturity_value': maturityValue,
      'notes': notes,
    };
  }

  /// Create model from Map (when reading from SQLite)
  factory AccountDepositDetails.fromMap(Map<String, dynamic> map) {
    return AccountDepositDetails(
      id: map['id'],
      accountId: map['account_id'],
      depositType: map['deposit_type'] ?? 'fd',
      principalAmount: (map['principal_amount'] ?? 0.0).toDouble(),
      recurringAmount: map['recurring_amount'] != null
          ? (map['recurring_amount'] as num).toDouble()
          : null,
      startDate: DateTime.parse(map['start_date']),
      maturityDate: DateTime.parse(map['maturity_date']),
      interestRate: (map['interest_rate'] ?? 0.0).toDouble(),
      compoundingFrequency: map['compounding_frequency'] ?? 'quarterly',
      termMonths: map['term_months'],
      currentValue: map['current_value'] != null
          ? (map['current_value'] as num).toDouble()
          : null,
      maturityValue: map['maturity_value'] != null
          ? (map['maturity_value'] as num).toDouble()
          : null,
      notes: map['notes'],
    );
  }

  /// Optional: Compute maturity value (you can extend this logic)
  double computeMaturityValue() {
    final years = (termMonths ?? 0) / 12.0;
    final rate = interestRate / 100.0;

    if (depositType == 'fd') {
      // Compound interest for Fixed Deposit
      const n = 4; // Quarterly compounding
      return principalAmount * (pow((1 + rate / n), n * years));
    } else {
      // Approximation for RD (you can refine this later)
      const n = 4;
      final r = rate / 12.0;
      final t = termMonths ?? 0;
      return (recurringAmount ?? 0) *
          ((pow(1 + r, t) - 1) / (1 - pow(1 + r, -1 / 12)));
    }
  }
}
