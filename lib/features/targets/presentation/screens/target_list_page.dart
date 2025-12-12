import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/features/targets/presentation/providers/target_list_provider.dart';
import 'package:aplikasi_targetku/features/targets/presentation/widgets/target_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    // 1. Ambil data dari Provider
    final AsyncValue<List<TargetEntity>> targetsAsync =
        ref.watch(targetListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Off-white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Pejuang Mimpi! 👋',
              style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Fokus ke tujuanmu.',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('User'),
              accountEmail: Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                child: Text('U'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                context.go('/auth');
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Fitur Premium'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                context.go('/about');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: In Progress
          _buildList(targetsAsync, TargetStatus.inProgress),
          // Tab 2: Completed
          _buildList(targetsAsync, TargetStatus.completed),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Navigasi ke Halaman Buat Target
                context.pushNamed('create-target');
              },
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  // Widget List Builder
  Widget _buildList(
      AsyncValue<List<TargetEntity>> asyncValue, TargetStatus status) {
    return asyncValue.when(
      data: (allTargets) {
        // Filter list berdasarkan status tab
        final filteredTargets =
            allTargets.where((t) => t.status == status).toList();

        if (filteredTargets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  status == TargetStatus.inProgress
                      ? "Belum ada target impian."
                      : "Belum ada target yang selesai.",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
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
                // UPDATE: Navigasi ke Halaman Detail dengan membawa ID
                context.pushNamed(
                  'target-detail',
                  pathParameters: {'id': target.id.toString()},
                );
              },
            );
          },
        );
      },
      // Tampilan Error
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Terjadi kesalahan: $err', textAlign: TextAlign.center),
        ),
      ),
      // Tampilan Loading
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}