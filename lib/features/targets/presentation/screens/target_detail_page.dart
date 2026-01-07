import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/core/utils/platform_file_utils.dart';
import 'package:aplikasi_targetku/features/targets/presentation/providers/target_detail_provider.dart';
import 'package:aplikasi_targetku/features/transactions/presentation/widgets/add_transaction_modal.dart';

class TargetDetailPage extends ConsumerWidget {
  final int targetId;
  const TargetDetailPage({super.key, required this.targetId});

  void _deleteTarget(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Target?"),
        content: const Text("Apakah Anda yakin ingin menghapus target ini? Semua riwayat tabungan akan ikut terhapus permanen."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final repo = ref.read(targetRepositoryProvider);
              await repo.deleteTarget(targetId);
              if (context.mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Target dihapus"), backgroundColor: Colors.red));
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(targetDetailProvider(targetId));
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: stateAsync.when(
        data: (state) {
          final target = state.target;
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

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.indigo,
                leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.pop()),
                actions: [
                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.white), onPressed: () => _deleteTarget(context, ref)),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(target.name, style: const TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black45, blurRadius: 5)])),
                  background: imageProvider != null
                      ? Image(image: imageProvider, fit: BoxFit.cover)
                      : Container(color: Colors.indigo.shade300, child: const Icon(Icons.image, size: 64, color: Colors.white54)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text("Terkumpul", style: TextStyle(color: Colors.grey.shade600)),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormatter.format(state.currentBalance),
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
                          ),
                          const SizedBox(height: 4),
                          Text("dari ${currencyFormatter.format(target.targetAmount)}", style: TextStyle(color: Colors.grey.shade500)),
                          const SizedBox(height: 20),
                          LinearProgressIndicator(
                            value: state.progress,
                            minHeight: 12,
                            backgroundColor: Colors.grey.shade200,
                            color: state.progress >= 1.0 ? Colors.green : Colors.indigo,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          const SizedBox(height: 8),
                          Text("${(state.progress * 100).toInt()}% Tercapai", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text("Riwayat Transaksi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              if (state.transactions.isEmpty)
                const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(32.0), child: Center(child: Text("Belum ada transaksi. Yuk nabung!"))))
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tx = state.transactions[index];
                      final isIncrease = tx.type == TransactionType.increase;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isIncrease ? Colors.green.shade50 : Colors.red.shade50,
                          child: Icon(isIncrease ? Icons.arrow_downward : Icons.arrow_upward, color: isIncrease ? Colors.green : Colors.red),
                        ),
                        title: Text(isIncrease ? "Menabung" : "Penarikan"),
                        subtitle: Text(tx.description ?? DateFormat('dd MMM yyyy').format(tx.date)),
                        trailing: Text("${isIncrease ? '+' : '-'} ${currencyFormatter.format(tx.amount)}", style: TextStyle(color: isIncrease ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                      );
                    },
                    childCount: state.transactions.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
        error: (err, stack) => Center(child: Text("Error: $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: stateAsync.when(
        data: (state) {
          // Sembunyikan tombol jika sudah selesai
          if (state.target.status == TargetStatus.completed) return null;
          return FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                // Pastikan mengirim data penting ke Modal
                builder: (context) => AddTransactionModal(
                  targetId: targetId, 
                  currentBalance: state.currentBalance, 
                  targetAmount: state.target.targetAmount
                ),
              );
            },
            label: const Text("Catat Transaksi"),
            icon: const Icon(Icons.edit_note),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          );
        },
        loading: () => null,
        error: (_,__) => null,
      ),
    );
  }
}