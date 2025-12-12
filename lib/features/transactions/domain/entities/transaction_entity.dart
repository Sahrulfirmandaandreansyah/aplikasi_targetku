import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';

part 'transaction_entity.freezed.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required int id,
    required int targetId,
    required double amount,
    required TransactionType type,
    String? description,
    required DateTime date,
  }) = _TransactionEntity;
}