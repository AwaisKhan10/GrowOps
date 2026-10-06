import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// One step in the first-time app tour.
class GuidanceStep extends Equatable {
  const GuidanceStep({
    required this.title,
    required this.body,
    required this.icon,
    required this.route,
  });

  final String title;
  final String body;
  final IconData icon;
  final String route;

  @override
  List<Object?> get props => [title, body, icon, route];
}

abstract final class GuidanceCatalog {
  static const steps = <GuidanceStep>[
    GuidanceStep(
      title: 'Dashboard',
      body: 'Your daily snapshot — focus batch, recent timeline and stage moves at a glance.',
      icon: Icons.home_outlined,
      route: '/',
    ),
    GuidanceStep(
      title: 'Batches',
      body: 'Every grow batch lives here. Tap one to see plants, environment and full history.',
      icon: Icons.spa_outlined,
      route: '/batches',
    ),
    GuidanceStep(
      title: 'Tasks',
      body: "Today's to-dos across all batches — watering, feeding, checks and stage moves.",
      icon: Icons.checklist_outlined,
      route: '/tasks',
    ),
    GuidanceStep(
      title: 'Inventory',
      body: 'Track dried, cured and packaged stock with full traceability back to the batch.',
      icon: Icons.inventory_2_outlined,
      route: '/inventory',
    ),
    GuidanceStep(
      title: 'Quick Log',
      body: 'Hit the green Log button any time to record a watering, feeding, photo or note in seconds.',
      icon: Icons.edit_note_outlined,
      route: '/',
    ),
  ];
}
