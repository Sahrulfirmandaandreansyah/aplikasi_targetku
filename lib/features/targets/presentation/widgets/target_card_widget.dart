import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/core/utils/platform_file_utils.dart'; // Pastikan util ini ada
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';

// --- UBAH JADI STREAM PROVIDER ---
final targetBalanceStreamProvider = StreamProvider.family<double, int>((ref, targetId) {
  final txRepo = ref.watch(transactionRepositoryProvider);
  
  // Watch stream dari repository
  return txRepo.watchTransactions(targetId).map((result) {
    return result.fold(
      (failure) => 0.0,
      (transactions) {
        double balance = 0;
        for (var tx in transactions) {
          if (tx.type == TransactionType.increase) {
            balance += tx.amount;
          } else {
            balance -= tx.amount;
          }
        }
        return balance;
      },
    );
  });
});

class TargetCardWidget extends ConsumerWidget {
  final TargetEntity target;
  final VoidCallback onTap;

  const TargetCardWidget({
    super.key,
    required this.target,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // --- GUNAKAN STREAM PROVIDER ---
    final balanceAsync = ref.watch(targetBalanceStreamProvider(target.id));

    ImageProvider? imageProvider;
    if (target.imageUrl != null && target.imageUrl!.isNotEmpty) {
      if (fileExistsSync(target.imageUrl)) {
        if (kIsWeb) {
          imageProvider = NetworkImage(target.imageUrl!);
        } else {
          imageProvider = FileImage(File(target.imageUrl!));
        }
      }
    }

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Gambar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  image: imageProvider != null
                      ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      : null,
                ),
                child: imageProvider == null
                    ? const Icon(Icons.savings_outlined, color: Colors.indigo, size: 32)
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Info & Progress Bar
              Expanded(
                child: balanceAsync.when(
                  data: (currentBalance) {
                    // Logic Progress
                    final double progress = (target.targetAmount > 0)
                        ? (currentBalance / target.targetAmount).clamp(0.0, 1.0)
                        : 0.0;
                    final int percent = (progress * 100).toInt();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          target.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Terkumpul: ${currencyFormatter.format(currentBalance)}",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        
                        // Bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey.shade200,
                                  color: progress >= 1.0 ? Colors.green : Colors.indigo,
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text("$percent%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo)),
                          ],
                        ),
                      ],
                    );
                  },
                  // Tampilan saat loading/error (tetap tampilkan kerangka biar gak kedip)
                  loading: () => const LinearProgressIndicator(), 
                  error: (_, __) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}