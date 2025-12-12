import 'package:aplikasi_targetku/features/auth/presentation/pages/auth_page.dart';
import 'package:aplikasi_targetku/core/presentation/pages/about_page.dart'; // Import the AboutPage
import 'package:aplikasi_targetku/features/targets/presentation/screens/target_completed_page.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_targetku/features/targets/presentation/screens/target_list_page.dart';
import 'package:aplikasi_targetku/features/targets/presentation/screens/add_target_page.dart';
import 'package:aplikasi_targetku/features/targets/presentation/screens/target_detail_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/auth',
  routes: [
     GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/about', // Add the new About page route
      name: 'about',
      builder: (context, state) => const AboutPage(),
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
            return TargetCompletedPage(target: target);
          },
        ),
      ],
    ),
  ],
);