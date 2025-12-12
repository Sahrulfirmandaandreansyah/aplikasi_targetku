import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';

part 'target_entity.freezed.dart';

@freezed
class TargetEntity with _$TargetEntity {
  const factory TargetEntity({
    required int id,
    required String name,
    required double targetAmount,
    String? imageUrl,
    required double plannedAmount,
    required PlanFrequency planFrequency,
    required TargetStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _TargetEntity;
}