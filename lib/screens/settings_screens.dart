import 'package:flutter/material.dart';

import '../app_state.dart';
import '../core/theme/app_text_styles.dart';
import '../theme.dart';
import '../widgets.dart';

class SettingsRouter extends StatelessWidget {
  const SettingsRouter({super.key, required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    switch (route) {
      case '/settings/daily-log':
        return const DailyLogFieldsScreen();
      case '/settings/strains':
        return const StrainsSettingsScreen();
      case '/settings/rooms':
        return const RoomsSettingsScreen();
      case '/settings/inputs':
        return const InputsSettingsScreen();
      case '/settings/units':
        return const UnitsSettingsScreen();
      default:
        return const SettingsHomeScreen();
    }
  }
}

// ── Settings hub ─────────────────────────────────────────────────────────────

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final items = [
      (
        Icons.checklist_rtl,
        'Daily Log',
        'Fields growers see when logging',
        '${app.logFields.length}',
        '/settings/daily-log',
      ),
      (
        Icons.spa_outlined,
        'Strains',
        'Names, type, flowering days',
        '${app.strainItems.length}',
        '/settings/strains',
      ),
      (
        Icons.door_front_door_outlined,
        'Rooms',
        'Mother, clone, veg, flower, dry, packaging',
        '${app.areas.length}',
        '/settings/rooms',
      ),
      (
        Icons.science_outlined,
        'Inputs',
        'Nutrients, amendments, sprays',
        '${app.inputItems.length}',
        '/settings/inputs',
      ),
      (
        Icons.straighten,
        'Units & Measurement',
        'Weight, volume, EC/PPM, waste reasons',
        null,
        '/settings/units',
      ),
    ];

    return GoPageScaffold(
      title: 'Settings',
      children: [
        for (final item in items) ...[
          _SettingsHubCard(
            icon: item.$1,
            title: item.$2,
            subtitle: item.$3,
            count: item.$4,
            onTap: () => app.go(item.$5),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SettingsHubCard extends StatelessWidget {
  const _SettingsHubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.count,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GoCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.forest, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title()),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall()),
              ],
            ),
          ),
          if (count != null) ...[
            Text(count!, style: AppTextStyles.bodySmall()),
            const SizedBox(width: 4),
          ],
          const Icon(Icons.chevron_right, color: AppColors.muted),
        ],
      ),
    );
  }
}

class _AddOutlineButton extends StatelessWidget {
  const _AddOutlineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 20, color: AppColors.ink),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.body(weight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _forestSwitch(bool value, ValueChanged<bool> onChanged) {
  return Switch.adaptive(
    value: value,
    activeThumbColor: Colors.white,
    activeTrackColor: AppColors.forest,
    onChanged: onChanged,
  );
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: AppTextStyles.chip(color: AppColors.muted)),
    );
  }
}

// ── Daily Log ────────────────────────────────────────────────────────────────

class DailyLogFieldsScreen extends StatelessWidget {
  const DailyLogFieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Daily Log fields',
      children: [
        for (var i = 0; i < app.logFields.length; i++) ...[
          _DailyLogFieldCard(
            field: app.logFields[i],
            onToggle: (v) {
              app.logFields[i].enabled = v;
              app.notifyListeners();
            },
            onMoveUp: i == 0
                ? null
                : () {
                    final item = app.logFields.removeAt(i);
                    app.logFields.insert(i - 1, item);
                    app.notifyListeners();
                  },
            onMoveDown: i == app.logFields.length - 1
                ? null
                : () {
                    final item = app.logFields.removeAt(i);
                    app.logFields.insert(i + 1, item);
                    app.notifyListeners();
                  },
          ),
          const SizedBox(height: 10),
        ],
        _AddOutlineButton(
          label: 'Add field',
          onTap: () {
            app.logFields.add(
              LogField(name: 'Custom field', enabled: true, type: 'Notes'),
            );
            app.notifyListeners();
          },
        ),
      ],
    );
  }
}

class _DailyLogFieldCard extends StatelessWidget {
  const _DailyLogFieldCard({
    required this.field,
    required this.onToggle,
    this.onMoveUp,
    this.onMoveDown,
  });

  final LogField field;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    return GoCard(
      child: Row(
        children: [
          Column(
            children: [
              InkWell(
                onTap: onMoveUp,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 20,
                  color: onMoveUp == null ? AppColors.line : AppColors.muted,
                ),
              ),
              InkWell(
                onTap: onMoveDown,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: onMoveDown == null ? AppColors.line : AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Text(field.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.name,
                  style: AppTextStyles.body(weight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _MetaChip(field.type),
                    if (field.unit != null) _MetaChip(field.unit!),
                  ],
                ),
              ],
            ),
          ),
          _forestSwitch(field.enabled, onToggle),
        ],
      ),
    );
  }
}

// ── Strains ──────────────────────────────────────────────────────────────────

class StrainsSettingsScreen extends StatelessWidget {
  const StrainsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Strains',
      children: [
        for (final s in app.strainItems) ...[
          GoCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: AppTextStyles.title()),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: [
                          _MetaChip(s.type),
                          _MetaChip(s.flowerDays),
                        ],
                      ),
                    ],
                  ),
                ),
                _forestSwitch(s.enabled, (v) {
                  s.enabled = v;
                  app.notifyListeners();
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        _AddOutlineButton(
          label: 'Add strain',
          onTap: () {
            app.strainItems.add(
              StrainItem(
                name: 'New Strain',
                type: 'Hybrid',
                flowerDays: '63d flower',
              ),
            );
            app.strains.add('New Strain');
            app.notifyListeners();
          },
        ),
      ],
    );
  }
}

// ── Rooms ────────────────────────────────────────────────────────────────────

class RoomsSettingsScreen extends StatelessWidget {
  const RoomsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Rooms',
      children: [
        for (final room in app.areas) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              '${room.kind.toUpperCase()} ROOM',
              style: AppTextStyles.section(),
            ),
          ),
          GoCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: AppTextStyles.body(weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.capacity ?? 'No capacity set',
                        style: AppTextStyles.bodySmall(),
                      ),
                    ],
                  ),
                ),
                _forestSwitch(room.enabled, (v) {
                  room.enabled = v;
                  app.notifyListeners();
                }),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        _AddOutlineButton(
          label: 'Add room',
          onTap: () {
            app.areas.add(
              GrowArea(
                id: 'a${app.areas.length + 1}',
                name: 'New Room',
                kind: 'Custom',
                capacity: 'No capacity set',
              ),
            );
            app.notifyListeners();
          },
        ),
      ],
    );
  }
}

// ── Inputs ───────────────────────────────────────────────────────────────────

class InputsSettingsScreen extends StatelessWidget {
  const InputsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Inputs',
      subtitle: 'Nutrients, amendments, sprays',
      children: [
        for (final item in app.inputItems) ...[
          GoCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTextStyles.body(weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      _MetaChip(item.unit),
                    ],
                  ),
                ),
                _forestSwitch(item.enabled, (v) {
                  item.enabled = v;
                  app.notifyListeners();
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        _AddOutlineButton(
          label: 'Add input',
          onTap: () {
            app.inputItems.add(InputItem(name: 'New input', unit: 'ml'));
            app.inputs.add('New input');
            app.notifyListeners();
          },
        ),
      ],
    );
  }
}

// ── Units ────────────────────────────────────────────────────────────────────

class UnitsSettingsScreen extends StatefulWidget {
  const UnitsSettingsScreen({super.key});

  @override
  State<UnitsSettingsScreen> createState() => _UnitsSettingsScreenState();
}

class _UnitsSettingsScreenState extends State<UnitsSettingsScreen> {
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Units & Measurement',
      children: [
        _UnitChoiceCard(
          label: 'Weight',
          options: const ['g', 'kg'],
          selected: app.unitWeight,
          onSelect: (v) {
            app.unitWeight = v;
            app.notifyListeners();
          },
        ),
        const SizedBox(height: 10),
        _UnitChoiceCard(
          label: 'Volume',
          options: const ['ml', 'L'],
          selected: app.unitVolume,
          onSelect: (v) {
            app.unitVolume = v;
            app.notifyListeners();
          },
        ),
        const SizedBox(height: 10),
        _UnitChoiceCard(
          label: 'Temperature',
          subtitle: 'More units coming soon',
          options: const ['°C'],
          selected: app.unitTemp,
          onSelect: (v) {
            app.unitTemp = v;
            app.notifyListeners();
          },
        ),
        const SizedBox(height: 10),
        _UnitChoiceCard(
          label: 'Nutrient measurement',
          options: const ['EC', 'PPM'],
          selected: app.unitNutrient,
          onSelect: (v) {
            app.unitNutrient = v;
            app.notifyListeners();
          },
        ),
        const SizedBox(height: 10),
        GoCard(
          child: Row(
            children: [
              Text('Plant count', style: AppTextStyles.body()),
              const Spacer(),
              const _MetaChip('plants'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SectionLabel('Waste reasons'),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final reason in app.wasteReasons)
                    InputChip(
                      label: Text(reason),
                      onDeleted: () {
                        app.wasteReasons.remove(reason);
                        app.notifyListeners();
                      },
                      deleteIconColor: AppColors.muted,
                      backgroundColor: AppColors.inputFill,
                      side: BorderSide.none,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _reasonCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Add reason',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: AppColors.forest,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        final t = _reasonCtrl.text.trim();
                        if (t.isEmpty) return;
                        app.wasteReasons.add(t);
                        _reasonCtrl.clear();
                        app.notifyListeners();
                      },
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitChoiceCard extends StatelessWidget {
  const _UnitChoiceCard({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return GoCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body()),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTextStyles.bodySmall()),
                ],
              ],
            ),
          ),
          for (final opt in options) ...[
            const SizedBox(width: 6),
            InkWell(
              onTap: () => onSelect(opt),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == opt
                      ? AppColors.inputFill
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  opt,
                  style: AppTextStyles.label(
                    color: selected == opt ? AppColors.ink : AppColors.muted,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
