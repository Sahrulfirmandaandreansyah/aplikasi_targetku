import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/settings/presentation/providers/user_profile_provider.dart';
import 'package:aplikasi_targetku/features/settings/presentation/providers/user_settings_provider.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/features/targets/presentation/providers/target_list_provider.dart';
import 'package:aplikasi_targetku/features/targets/presentation/widgets/target_card_widget.dart';

class TargetListPage extends ConsumerStatefulWidget {
  const TargetListPage({super.key});

  @override
  ConsumerState<TargetListPage> createState() => _TargetListPageState();
}

class _TargetListPageState extends ConsumerState<TargetListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<TargetEntity>> targetsAsync = ref.watch(targetListProvider);
    final userName = ref.watch(userNameProvider);
    final isPremium = ref.watch(isPremiumProvider);

    // Ambil inisial nama (Huruf pertama)
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.indigo),
        // Gunakan Row untuk mensejajarkan Teks dan Avatar
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $userName! 👋',
                    style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Fokus ke tujuanmu.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
            // --- AVATAR DI DASHBOARD (PENGGANTI KOTAK X) ---
            GestureDetector(
              onTap: () {
                // Klik avatar untuk buka drawer
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.indigo.shade50,
                child: Text(
                  initial,
                  style: const TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.indigo,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.indigo,
          tabs: const [
            Tab(text: 'Sedang Berjalan'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      
      // --- DRAWER (MENU PROFIL) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              accountName: Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Row(
                children: [
                  Icon(
                    isPremium ? Icons.verified : Icons.stars,
                    color: isPremium ? Colors.amber : Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(isPremium ? 'Premium Member' : 'Starter Plan'),
                ],
              ),
              // Avatar di dalam Drawer
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  initial,
                  style: const TextStyle(fontSize: 28, color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Ganti Nama'),
              onTap: () {
                Navigator.pop(context);
                context.pushNamed('edit-profile');
              },
            ),
            if (!isPremium)
              ListTile(
                leading: const Icon(Icons.diamond_outlined, color: Colors.orange),
                title: const Text('Upgrade Premium', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(isPremiumProvider.notifier).setPremiumStatus(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Selamat! Anda sekarang Premium 🌟")),
                  );
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                Navigator.pop(context);
                context.push('/about');
              },
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(targetsAsync, TargetStatus.inProgress),
          _buildList(targetsAsync, TargetStatus.completed),
        ],
      ),

      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                targetsAsync.whenData((targets) {
                  final activeCount = targets.where((t) => t.status == TargetStatus.inProgress).length;
                  if (!isPremium && activeCount >= 3) {
                     showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Batas Tercapai 🔒"),
                        content: const Text("User gratis hanya bisa membuat 3 target aktif. Upgrade ke Premium?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Nanti")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ref.read(isPremiumProvider.notifier).setPremiumStatus(true);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upgrade Berhasil!")));
                            }, 
                            child: const Text("Upgrade", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold))
                          ),
                        ],
                      )
                     );
                  } else {
                     context.pushNamed('create-target');
                  }
                });
              },
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildList(AsyncValue<List<TargetEntity>> asyncValue, TargetStatus status) {
    return asyncValue.when(
      data: (allTargets) {
        final filteredTargets = allTargets.where((t) => t.status == status).toList();

        if (filteredTargets.isEmpty) {
          final isProgressTab = status == TargetStatus.inProgress;
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isProgressTab ? Icons.rocket_launch_rounded : Icons.emoji_events_rounded,
                      size: 80, 
                      color: Colors.indigo.shade300
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isProgressTab ? "Mulai Mimpimu!" : "Belum Ada Pencapaian",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isProgressTab 
                      ? "Tekan tombol + untuk membuat target\ntabungan pertamamu." 
                      : "Selesaikan targetmu dan lihat\nriwayatnya di sini.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, height: 1.5),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredTargets.length,
          itemBuilder: (context, index) {
            final target = filteredTargets[index];
            return TargetCardWidget(
              target: target,
              onTap: () {
                if (status == TargetStatus.completed) {
                   context.pushNamed('target-completed', extra: target);
                } else {
                   context.pushNamed('target-detail', pathParameters: {'id': target.id.toString()});
                }
              },
            );
          },
        );
      },
      error: (err, stack) => Center(child: Text('Terjadi kesalahan: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}