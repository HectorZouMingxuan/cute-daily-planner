import 'package:flutter/material.dart';

import 'sync_metadata.dart';

enum ExpenseType {
  income,
  expense;

  String get label => switch (this) {
    ExpenseType.income => 'Income',
    ExpenseType.expense => 'Expense',
  };
}

enum ExpenseCategory {
  food,
  transport,
  shopping,
  bills,
  health,
  study,
  entertainment,
  other;

  String get label => switch (this) {
    ExpenseCategory.food => 'Food',
    ExpenseCategory.transport => 'Transport',
    ExpenseCategory.shopping => 'Shopping',
    ExpenseCategory.bills => 'Bills',
    ExpenseCategory.health => 'Health',
    ExpenseCategory.study => 'Study',
    ExpenseCategory.entertainment => 'Entertainment',
    ExpenseCategory.other => 'Other',
  };

  Color get color => switch (this) {
    ExpenseCategory.food => const Color(0xFFE8A94E),
    ExpenseCategory.transport => const Color(0xFF6BA3B8),
    ExpenseCategory.shopping => const Color(0xFFDFA7A0),
    ExpenseCategory.bills => const Color(0xFFC85B63),
    ExpenseCategory.health => const Color(0xFF9DBB9A),
    ExpenseCategory.study => const Color(0xFFB9A7CF),
    ExpenseCategory.entertainment => const Color(0xFFD8A84E),
    ExpenseCategory.other => const Color(0xFF909890),
  };
}

enum PaymentMethod {
  cash,
  card,
  eWallet,
  bankTransfer,
  other;

  String get label => switch (this) {
    PaymentMethod.cash => 'Cash',
    PaymentMethod.card => 'Card',
    PaymentMethod.eWallet => 'E-Wallet',
    PaymentMethod.bankTransfer => 'Bank Transfer',
    PaymentMethod.other => 'Other',
  };
}

class ExpenseEntry {
  const ExpenseEntry({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.category,
    required this.note,
    required this.date,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final double amount;
  final ExpenseType type;
  final ExpenseCategory category;
  final String note;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  bool get isDeleted => deletedAt != null;

  ExpenseEntry copyWith({
    double? amount,
    ExpenseType? type,
    ExpenseCategory? category,
    String? note,
    DateTime? date,
    PaymentMethod? paymentMethod,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return ExpenseEntry(
      id: id,
      userId: userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'amount': amount,
    'type': type.name,
    'category': category.name,
    'note': note,
    'date': date.toIso8601String(),
    'paymentMethod': paymentMethod.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
    'syncStatus': syncStatus.name,
    'version': version,
  };

  factory ExpenseEntry.fromJson(Map<String, dynamic> json) {
    return ExpenseEntry(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'local-user',
      amount: (json['amount'] as num? ?? 0).toDouble(),
      type: ExpenseType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => ExpenseType.expense,
      ),
      category: ExpenseCategory.values.firstWhere(
        (value) => value.name == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      note: json['note'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      paymentMethod: PaymentMethod.values.firstWhere(
        (value) => value.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.tryParse(json['deletedAt'] as String),
      syncStatus: SyncStatus.values.firstWhere(
        (value) => value.name == json['syncStatus'],
        orElse: () => SyncStatus.localOnly,
      ),
      version: json['version'] as int? ?? 1,
    );
  }
}
