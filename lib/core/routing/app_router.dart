import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Imports Pages
import 'package:aplikasi_targetku/core/presentation/pages/about_page.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/features/targets/presentation/screens/add_target_page.dart';
import 'package:aplikasi_targetku/features/targets/presentation/screens/target_completed_page.dart';
import 'package:aplikasi_targetku/features/targets/presentation/screens/target_detail_page.dart';
import 'package:aplikasi_targetku/features/targets/presentation/screens/target_list_page.dart';
import 'package:aplikasi_targetku/core/services/user_preference_service.dart';
import 'package:aplikasi_targetku/features/auth/presentation/pages/onboarding_page.dart'; // Pastikan import ini benar
import 'package:aplikasi_targetku/features/settings/presentation/screens/edit_profile_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Ubah menjadi fungsi agar dipanggil setelah main() selesai init
GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    // Cek status saat router dibuat, bukan saat file di-load
    initialLocation: UserPreferenceService().isFirstRun ? '/onboarding' : '/',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/auth', // Jika AuthPage masih ada, biarkan. Jika diganti Onboarding, hapus saja.
        name: 'auth',
        builder: (context, state) => const OnboardingPage(), // Arahkan ke Onboarding
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const TargetListPage(),
        routes: [
          GoRoute(
            path: 'create-target',
            name: 'create-target',
            builder: (context, state) => const AddTargetPage(),
          ),
          GoRoute(
            path: 'target/:id',
            name: 'target-detail',
            builder: (context, state) {
              final idStr = state.pathParameters['id']!;
              final id = int.parse(idStr);
              return TargetDetailPage(targetId: id);
            },
          ),
          GoRoute(
            path: 'edit-target',
            name: 'edit-target',
            builder: (context, state) {
              final target = state.extra as TargetEntity;
              return AddTargetPage(targetToEdit: target);
            },
          ),
           GoRoute(
          path: 'target-completed',
          name: 'target-completed',
          builder: (context, state) {
            final target = state.extra as TargetEntity;
            return TargetCompletedPage(target: target); // Pastikan importnya benar
            },
          ),
        ],
      ),
    ],
  );
}