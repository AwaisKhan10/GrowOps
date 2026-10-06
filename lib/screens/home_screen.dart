import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final focus = app.focusBatch;
    final others = app.activeBatches.where((b) => b.id != focus.id).toList();
    final todayTasks = app.tasks.take(4).toList();
    final recent = app.journal.take(4).toList();

    final openTasksCount = app.tasks.where((t) => !t.done).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoHeader(
          title: 'Hi, ${app.growerName.split(' ').first}',
          subtitle: '${app.activeBatches.length} active batches',
          showNotifications: true,
          notificationCount: openTasksCount > 0 ? openTasksCount : 1,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              const SectionLabel('Your grow today'),
              BatchCard(batch: focus, variant: BatchCardVariant.home),
              const SizedBox(height: 10),
              _SuggestionCard(onTap: () => app.go('/tasks')),
              const SectionLabel('Alerts', asTitle: true),
              _AlertCard(
                text: 'WC-C-001 overdue for watering',
                warning: true,
                onView: () => app.go('/batches/b1'),
              ),
              const SizedBox(height: 8),
              _AlertCard(
                text: 'GG-C-002 drying close to target moisture',
                warning: false,
                onView: () => app.go('/batches/b3'),
              ),
              Row(
                children: [
                  const Expanded(child: SectionLabel('Other batches')),
                  TextButton(
                    onPressed: () => app.go('/batches'),
                    child: const Text('See all'),
                  ),
                ],
              ),
              ...others.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BatchCard(batch: b),
                ),
              ),
              const SectionLabel('Today', asTitle: true),
              _TodayTasksCard(tasks: todayTasks),
              const SectionLabel('Recent activity', asTitle: true),
              _RecentActivityCard(entries: recent),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1EEE8),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome, color: GoColors.forest, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "You've fed nutrients ~every 3 days. Want me to set a recurring reminder?",
                  style: TextStyle(
                    color: GoColors.ink,
                    height: 1.35,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.text,
    required this.warning,
    required this.onView,
  });

  final String text;
  final bool warning;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final bg = warning ? const Color(0xFFF8EDE3) : GoColors.card;
    final border = warning ? const Color(0xFFE8CFB8) : GoColors.line;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Row(
          children: [
            Icon(
              warning ? Icons.warning_amber_rounded : Icons.info,
              color: warning ? GoColors.alertIcon : GoColors.forest,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: GoColors.ink,
                  height: 1.3,
                ),
              ),
            ),
            TextButton(
              onPressed: onView,
              style: TextButton.styleFrom(
                foregroundColor: GoColors.ink,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayTasksCard extends StatelessWidget {
  const _TodayTasksCard({required this.tasks});

  final List<GrowTask> tasks;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return GoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < tasks.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                indent: 52,
                color: GoColors.line,
              ),
            InkWell(
              onTap: () => app.toggleTask(tasks[i].id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    _TaskCheck(done: tasks[i].done),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tasks[i].title,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.25,
                          color: tasks[i].done ? GoColors.muted : GoColors.ink,
                          decoration:
                              tasks[i].done ? TextDecoration.lineThrough : null,
                          decorationColor: GoColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskCheck extends StatelessWidget {
  const _TaskCheck({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: GoColors.forest,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: GoColors.forest, width: 1.8),
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.entries});

  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    return GoCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            _TimelineEntry(
              entry: entries[i],
              isLast: i == entries.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.entry,
    required this.isLast,
  });

  final JournalEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(entry.kind);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: style.$1,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(style.$2, size: 14, color: style.$3),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: GoColors.line,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 6 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: GoColors.ink,
                          ),
                        ),
                      ),
                      Text(
                        entry.ago,
                        style: const TextStyle(
                          color: GoColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.subtitle,
                    style: const TextStyle(color: GoColors.muted, height: 1.3),
                  ),
                  if (entry.meta != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      entry.meta!,
                      style: const TextStyle(color: GoColors.muted, height: 1.3),
                    ),
                  ],
                  if (entry.imageUrl != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: _ActivityImage(path: entry.imageUrl!),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    entry.when,
                    style: const TextStyle(
                      color: GoColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData, Color) _styleFor(String kind) {
    final k = kind.toLowerCase();
    if (k.contains('issue')) {
      return (const Color(0xFFF3E0D0), Icons.warning_amber_rounded, GoColors.alertIcon);
    }
    if (k.contains('prun') || k.contains('defol')) {
      return (GoColors.mint, Icons.content_cut, GoColors.forest);
    }
    if (k.contains('photo')) {
      return (const Color(0xFFEDEAE4), Icons.photo_camera, GoColors.muted);
    }
    if (k.contains('check')) {
      return (const Color(0xFFE8DCCF), Icons.assignment_turned_in_outlined, const Color(0xFF6A4A2A));
    }
    if (k.contains('fed') || k.contains('water')) {
      return (GoColors.mint, Icons.science_outlined, GoColors.forest);
    }
    return (GoColors.mint, Icons.notes, GoColors.forest);
  }
}

class _ActivityImage extends StatelessWidget {
  const _ActivityImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: GoColors.photoPlaceholder,
      alignment: Alignment.center,
      child: const Icon(Icons.image, color: Colors.white70, size: 36),
    );

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
