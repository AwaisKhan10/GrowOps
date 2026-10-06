import 'package:flutter/material.dart';

import '../app_state.dart';
import '../core/feedback/app_snackbar.dart';
import '../theme.dart';
import '../widgets.dart';

class GeneticsScreen extends StatelessWidget {
  const GeneticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(
          title: 'Genetics',
          showBack: true,
          trailing: IconButton(
            onPressed: () {
              app.strains.insert(0, 'New Strain ${app.strains.length + 1}');
              app.notifyListeners();
              AppSnackbar.showSuccess(context, 'Strain added (demo)');
            },
            icon: const CircleAvatar(backgroundColor: GoColors.forest, child: Icon(Icons.add, color: Colors.white)),
          ),
        ),
        Row(
          children: [
            _tab(app, 'Strains', Icons.eco),
            _tab(app, 'Seed Lots', Icons.science_outlined),
            _tab(app, 'Mothers', Icons.park_outlined),
          ],
        ),
        const SizedBox(height: 12),
        if (app.geneticsTab == 'Strains')
          ...app.strains.map((s) {
            final count = app.batches.where((b) => b.strain == s).length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Text('$count batches', style: const TextStyle(color: GoColors.muted)),
                  ],
                ),
              ),
            );
          }),
        if (app.geneticsTab == 'Seed Lots')
          ...app.seedLots.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GoCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${s.strain} · ${s.qty} seeds'),
                  ),
                ),
              )),
        if (app.geneticsTab == 'Mothers')
          ...app.mothers.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GoCard(
                  onTap: () => app.go('/mothers/${m.id}'),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(m.code, style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text('${m.strain} · ${m.status}'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              )),
      ],
    );
  }

  Widget _tab(AppState app, String label, IconData icon) {
    final selected = app.geneticsTab == label;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: ChoiceChip(
          avatar: Icon(icon, size: 16, color: selected ? Colors.white : GoColors.forest),
          label: Text(label),
          selected: selected,
          selectedColor: GoColors.forest,
          labelStyle: TextStyle(color: selected ? Colors.white : GoColors.ink, fontSize: 12),
          onSelected: (_) {
            app.geneticsTab = label;
            app.notifyListeners();
          },
        ),
      ),
    );
  }
}

class AreasScreen extends StatefulWidget {
  const AreasScreen({super.key});
  @override
  State<AreasScreen> createState() => _AreasScreenState();
}

class _AreasScreenState extends State<AreasScreen> {
  final name = TextEditingController();
  String kind = 'Tunnel';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'Grow areas', showBack: true),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add a new area', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(controller: name, decoration: const InputDecoration(hintText: 'e.g. Tunnel B, Veg room, Tent 2')),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Indoor', 'Outdoor', 'Tunnel', 'Greenhouse']
                    .map((k) => ChoiceChip(
                          label: Text(k),
                          selected: kind == k,
                          selectedColor: GoColors.forest,
                          labelStyle: TextStyle(color: kind == k ? Colors.white : GoColors.ink),
                          onSelected: (_) => setState(() => kind = k),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: GoColors.forestSoft),
                  onPressed: () {
                    if (name.text.trim().isEmpty) return;
                    app.areas.add(GrowArea(id: 'a${app.areas.length + 1}', name: name.text.trim(), kind: kind));
                    name.clear();
                    app.notifyListeners();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add area'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...app.areas.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GoCard(
                onTap: () => app.go('/areas/${a.id}'),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  a.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              StageChip(a.kind, small: true),
                            ],
                          ),
                          Text(
                            '${app.areaBatches(a)} batches · ${app.areaPlants(a)} plants',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: GoColors.muted),
                          ),
                          Text(
                            app.areaStages(a).join('  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: GoColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final ctrl = TextEditingController(text: a.name);
                        final updated = await showDialog<String>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Rename area'),
                            content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Area name')),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                              FilledButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('Save')),
                            ],
                          ),
                        );
                        if (updated != null && updated.isNotEmpty) {
                          final old = a.name;
                          a.name = updated;
                          for (final b in app.batches) {
                            if (b.area == old) b.area = updated;
                          }
                          app.notifyListeners();
                          AppSnackbar.showSuccess(context, 'Area updated');
                        }
                      },
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        app.areas.remove(a);
                        app.notifyListeners();
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class AreaDetailScreen extends StatelessWidget {
  const AreaDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final area = app.areas.firstWhere((a) => a.id == id, orElse: () => app.areas.first);
    final batches = app.batches.where((b) => b.area == area.name).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(title: area.name, subtitle: area.kind, showBack: true),
        ...batches.map((b) => Padding(padding: const EdgeInsets.only(bottom: 10), child: BatchCard(batch: b))),
      ],
    );
  }
}

class MotherDetailScreen extends StatelessWidget {
  const MotherDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final m = app.mothers.firstWhere((e) => e.id == id, orElse: () => app.mothers.first);
    final linked = app.batches.where((b) => b.motherId == m.id).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(title: m.code, subtitle: '${m.strain} · ${m.status}', showBack: true),
        GoCard(child: Text('Mother tag ${m.code}. Clones taken from this plant stay traceable into batches.')),
        const SectionLabel('Linked batches'),
        ...linked.map((b) => Padding(padding: const EdgeInsets.only(bottom: 10), child: BatchCard(batch: b))),
      ],
    );
  }
}

class HarvestScreen extends StatefulWidget {
  const HarvestScreen({super.key});
  @override
  State<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<HarvestScreen> {
  String? batchId;
  final wet = TextEditingController();
  final trim = TextEditingController();
  final waste = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    batchId ??= app.focusBatch.id;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'Harvest', showBack: true),
        Text(
          'Batch',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.inkOf(context),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: app.activeBatches
              .map(
                (b) => _DarkSafeChoiceChip(
                  label: b.code,
                  selected: batchId == b.id,
                  onSelected: () => setState(() => batchId = b.id),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Weights',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.inkOf(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(controller: wet, decoration: const InputDecoration(labelText: 'Wet weight (g)')),
        const SizedBox(height: 8),
        TextField(controller: trim, decoration: const InputDecoration(labelText: 'Trim weight (g)')),
        const SizedBox(height: 8),
        TextField(controller: waste, decoration: const InputDecoration(labelText: 'Waste (g)')),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => app.completeHarvest(
            batchId: batchId!,
            wet: wet.text,
            trim: trim.text,
            waste: waste.text,
          ),
          child: const Text('Complete harvest'),
        ),
        const SizedBox(height: 8),
        Text(
          'Batch will move to Drying automatically.',
          style: TextStyle(color: AppColors.mutedOf(context)),
        ),
      ],
    );
  }
}

class DryingScreen extends StatelessWidget {
  const DryingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final drying = app.batches.where((b) => b.stage == 'Drying').toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'Drying', showBack: true),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daily drying check', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Record RH, temperature and stem snap for lots in drying.'),
              const SizedBox(height: 8),
              const TextField(decoration: InputDecoration(labelText: 'RH %')),
              const SizedBox(height: 8),
              const TextField(decoration: InputDecoration(labelText: 'Temperature °C')),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  if (drying.isNotEmpty) {
                    app.addLog(batchId: drying.first.id, activity: 'Check', notes: 'Drying room check', meta: '62% RH');
                  }
                },
                child: const Text('Save drying check'),
              ),
            ],
          ),
        ),
        const SectionLabel('Lots in drying'),
        if (drying.isEmpty) const Text('No batches in drying.'),
        ...drying.map((b) => Padding(padding: const EdgeInsets.only(bottom: 10), child: BatchCard(batch: b))),
      ],
    );
  }
}

class CuringScreen extends StatelessWidget {
  const CuringScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final curing = app.batches.where((b) => b.stage == 'Curing').toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'Curing', showBack: true),
        const GoCard(child: Text('Burp jars, log humidity, and move lots to packaging when moisture is stable.')),
        const SectionLabel('Lots in curing'),
        if (curing.isEmpty) const Text('No batches in curing yet. Advance a drying lot to start.'),
        ...curing.map((b) => Padding(padding: const EdgeInsets.only(bottom: 10), child: BatchCard(batch: b))),
      ],
    );
  }
}

class PackagingScreen extends StatefulWidget {
  const PackagingScreen({super.key});
  @override
  State<PackagingScreen> createState() => _PackagingScreenState();
}

class _PackagingScreenState extends State<PackagingScreen> {
  String size = '3.5g';
  final qty = TextEditingController(text: '10');
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'Packaging', showBack: true),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pack-size generator',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.inkOf(context),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['1g', '3.5g', '7g', '14g']
                    .map(
                      (s) => _DarkSafeChoiceChip(
                        label: s,
                        selected: size == s,
                        onSelected: () => setState(() => size = s),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              TextField(controller: qty, decoration: const InputDecoration(labelText: 'Quantity')),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  final n = app.stock.length + 1;
                  app.stock.insert(
                    0,
                    StockItem(
                      id: 'i$n',
                      strain: app.focusBatch.strain,
                      size: size,
                      sku: 'GK-${app.focusBatch.code}-$size-00$n',
                      qty: int.tryParse(qty.text) ?? 1,
                      harvest: 'Harvest today',
                      batchCode: app.focusBatch.code,
                    ),
                  );
                  app.notifyListeners();
                  AppSnackbar.showSuccess(context, 'SKU generated and added to stock');
                  app.go('/inventory');
                },
                child: const Text('Generate SKU + QR'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuickLogScreen extends StatefulWidget {
  const QuickLogScreen({super.key});
  @override
  State<QuickLogScreen> createState() => _QuickLogScreenState();
}

class _QuickLogScreenState extends State<QuickLogScreen> {
  String? batchId;
  final selected = <String>{};
  final notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    batchId ??= app.selectedBatchId ?? app.focusBatch.id;
    final actions = app.logFields.where((f) => f.enabled).map((f) => f.name).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick log', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  Text('Tap what you did. We save it instantly.', style: TextStyle(color: GoColors.muted)),
                ],
              ),
            ),
            IconButton(onPressed: app.back, icon: const Icon(Icons.close)),
          ],
        ),
        OutlinedButton.icon(
          onPressed: () {
            app.addLog(batchId: batchId!, activity: 'Photo', notes: 'Field photo captured');
            AppSnackbar.showSuccess(context, 'Photo logged');
          },
          icon: const Icon(Icons.photo_camera),
          label: const Text('Add a photo · optional'),
        ),
        const SizedBox(height: 12),
        const Text('Batch', style: TextStyle(fontWeight: FontWeight.w700)),
        Wrap(
          spacing: 8,
          children: app.activeBatches
              .map((b) => ChoiceChip(
                    label: Text(b.code),
                    selected: batchId == b.id,
                    selectedColor: GoColors.forest,
                    labelStyle: TextStyle(color: batchId == b.id ? Colors.white : GoColors.ink),
                    onSelected: (_) => setState(() => batchId = b.id),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        const Text('What did you do?', style: TextStyle(fontWeight: FontWeight.w700)),
        const Text('Tap one or more', style: TextStyle(color: GoColors.muted, fontSize: 12)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actions
              .map((a) => FilterChip(
                    label: Text(a),
                    selected: selected.contains(a),
                    onSelected: (v) => setState(() {
                      if (v) {
                        selected.add(a);
                      } else {
                        selected.remove(a);
                      }
                    }),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        TextField(controller: notes, decoration: const InputDecoration(hintText: 'More details (optional)')),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            for (final a in selected) {
              app.addLog(batchId: batchId!, activity: a, notes: notes.text);
            }
            if (selected.isEmpty) {
              app.addLog(batchId: batchId!, activity: 'Note', notes: notes.text);
            }
            app.go('/');
          },
          child: const Text('Save log'),
        ),
      ],
    );
  }
}

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'Scan QR', subtitle: 'Demo codes — tap to simulate', showBack: true),
        const GoCard(
          child: Text(
            'Camera not available in this preview. Tap any sample QR below to simulate a scan. Batch and package scans add a timeline entry so you can see live updates.',
          ),
        ),
        const SectionLabel('Batch QR codes'),
        ...app.batches.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GoCard(
                onTap: () {
                  app.addLog(batchId: b.id, activity: 'Scan', notes: 'Scanned ${b.traceCode}');
                  app.go('/batches/${b.id}');
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(b.code, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${b.traceCode}\n${b.stage}'),
                ),
              ),
            )),
        const SectionLabel('Package QR codes'),
        ...app.stock.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GoCard(
                onTap: () => app.go('/inventory/${s.id}'),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${s.strain} · ${s.size}'),
                  subtitle: Text(s.sku),
                  trailing: Text('×${s.qty}'),
                ),
              ),
            )),
        const SectionLabel('Mother plant tags'),
        ...app.mothers.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GoCard(
                onTap: () => app.go('/mothers/${m.id}'),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(m.code, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${m.strain} · ${m.status}'),
                ),
              ),
            )),
      ],
    );
  }
}

class TraceScreen extends StatelessWidget {
  const TraceScreen({super.key, required this.code});
  final String code;
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final batch = app.batches.where((b) => b.traceCode == code || b.code == code).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(title: 'Trace', subtitle: code, showBack: true),
        GoCard(
          child: Text(
            'Genealogy: Mother → Clone → Growth cycle → Harvest → Package.\nCode $code is the seed-to-sale identifier for this record.',
          ),
        ),
        if (batch.isNotEmpty) BatchCard(batch: batch.first),
      ],
    );
  }
}

/// Choice chip whose label stays readable in both light and dark themes.
class _DarkSafeChoiceChip extends StatelessWidget {
  const _DarkSafeChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      selectedColor: AppColors.forest,
      backgroundColor: AppColors.chipFillOf(context),
      side: BorderSide(
        color: selected ? AppColors.forest : AppColors.lineOf(context),
      ),
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.inkOf(context),
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
