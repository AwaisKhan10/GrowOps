import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

class BatchesScreen extends StatelessWidget {
  const BatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final filters = ['Active', 'Drying', 'Curing', 'Packaged', 'Harvested'];
    var list = app.activeBatches;
    if (app.batchFilter != 'Active') {
      list = list.where((b) => b.stage == app.batchFilter).toList();
    }
    final q = app.searchBatches.toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (b) =>
                b.code.toLowerCase().contains(q) ||
                b.strain.toLowerCase().contains(q) ||
                b.stage.toLowerCase().contains(q) ||
                b.area.toLowerCase().contains(q),
          )
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoHeader(
          title: 'Batches',
          trailing: HeaderAddButton(onTap: () => app.go('/new-batch')),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              TextField(
                onChanged: (v) {
                  app.searchBatches = v;
                  app.notifyListeners();
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Try "batches harvested in March" or "blue dream"',
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((f) {
                    final selected = app.batchFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Material(
                        color: selected ? GoColors.forest : GoColors.card,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: selected ? GoColors.forest : GoColors.line,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            app.batchFilter = f;
                            app.notifyListeners();
                          },
                          customBorder: const StadiumBorder(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              f,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : GoColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              ...list.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BatchCard(batch: b),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BatchDetailScreen extends StatelessWidget {
  const BatchDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final batch = app.batchById(id);
    if (batch == null) {
      return const Center(child: Text('Batch not found'));
    }

    final entries = app.journal.where((j) => j.batchId == batch.id).toList();
    final stageIndex = () {
      final i = stages.indexOf(batch.stage);
      if (i >= 0) return i;
      if (batch.stage == 'Seedling') return 0;
      return 0;
    }();
    final next = nextStageLabel(batch.stage);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        Row(
          children: [
            IconButton(onPressed: app.back, icon: const Icon(Icons.arrow_back)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(batch.code, style: Theme.of(context).textTheme.headlineMedium),
                  Text(batch.strain, style: const TextStyle(color: GoColors.muted)),
                ],
              ),
            ),
            const SyncedBadge(),
            IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BatchCard(batch: batch, compact: true, showMove: false),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stage timeline', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < stages.length; i++)
                    StageChip(stages[i], small: true),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Current: ${batch.stage} · step ${stageIndex + 1}/${stages.length}',
                style: const TextStyle(color: GoColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SoftButton(
              label: 'Log today',
              icon: Icons.edit_note,
              filled: true,
              onTap: () {
                app.selectedBatchId = batch.id;
                app.go('/log');
              },
            ),
            const SizedBox(width: 8),
            SoftButton(
              label: 'Move to ${moveToButtonLabel(next)}',
              trailingIcon: Icons.arrow_forward,
              outlined: true,
              compact: true,
              onTap: () => app.advanceStage(batch),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Traceability', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(batch.traceCode),
              Text('Started ${batch.started}', style: const TextStyle(color: GoColors.muted)),
              TextButton(
                onPressed: () => app.go('/trace/${batch.traceCode}'),
                child: const Text('Open full trace'),
              ),
            ],
          ),
        ),
        const SectionLabel('Recent activity', asTitle: true),
        ...entries.take(8).map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(e.subtitle),
                  if (e.meta != null) Text(e.meta!, style: const TextStyle(color: GoColors.muted)),
                  Text('${e.when} · ${e.ago}', style: const TextStyle(color: GoColors.muted, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NewBatchScreen extends StatefulWidget {
  const NewBatchScreen({super.key});

  @override
  State<NewBatchScreen> createState() => _NewBatchScreenState();
}

class _NewBatchScreenState extends State<NewBatchScreen> {
  late final TextEditingController strain;
  late final TextEditingController area;
  late final TextEditingController plants;

  @override
  void initState() {
    super.initState();
    strain = TextEditingController(text: 'Wedding Cake');
    area = TextEditingController(text: 'Tent 1');
    plants = TextEditingController(text: '12');
  }

  @override
  void dispose() {
    strain.dispose();
    area.dispose();
    plants.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'New batch', showBack: true),
        const SizedBox(height: 16),
        TextField(
          controller: strain,
          decoration: const InputDecoration(labelText: 'Strain'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: area,
          decoration: const InputDecoration(labelText: 'Grow area'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: plants,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Plant count'),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => app.addBatch(
            strain: strain.text.trim().isEmpty ? 'Unknown' : strain.text.trim(),
            area: area.text.trim().isEmpty ? 'Unassigned' : area.text.trim(),
            plants: int.tryParse(plants.text.trim()) ?? 1,
          ),
          child: const Text('Create batch'),
        ),
      ],
    );
  }
}
