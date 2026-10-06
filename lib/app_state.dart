import 'package:flutter/material.dart';

import 'core/data/demo_seed_data.dart';
import 'features/onboarding/domain/guidance_step.dart';

const stages = [
  'Rooting',
  'Veg',
  'Flower',
  'Harvested',
  'Drying',
  'Curing',
  'Packaged',
];

String nextStageLabel(String stage) {
  switch (stage) {
    case 'Seedling':
    case 'Rooting':
      return 'Veg';
    case 'Veg':
      return 'Flower';
    case 'Flower':
      return 'Harvested';
    case 'Harvested':
      return 'Drying';
    case 'Drying':
      return 'Curing';
    case 'Curing':
      return 'Packaged';
    default:
      return stage;
  }
}

/// Button label for "Move to …" — shorter than stage enum where needed.
String moveToButtonLabel(String nextStage) {
  switch (nextStage) {
    case 'Harvested':
      return 'Harvest';
    default:
      return nextStage;
  }
}

class GrowBatch {
  GrowBatch({
    required this.id,
    required this.code,
    required this.strain,
    required this.stage,
    required this.plants,
    required this.area,
    required this.day,
    required this.progress,
    required this.traceCode,
    this.motherId,
    this.motherCode,
    this.started = 'Jul 19, 2026',
    this.archived = false,
  });

  final String id;
  final String code;
  final String strain;
  String stage;
  int plants;
  String area;
  int day;
  double progress;
  final String traceCode;
  final String? motherId;
  final String? motherCode;
  final String started;
  bool archived;
}

class JournalEntry {
  JournalEntry({
    required this.batchId,
    required this.title,
    required this.subtitle,
    required this.when,
    required this.ago,
    this.meta,
    this.kind = 'note',
    this.imageUrl,
  });

  final String batchId;
  final String title;
  final String subtitle;
  final String when;
  final String ago;
  final String? meta;
  final String kind;
  final String? imageUrl;
}

class GrowTask {
  GrowTask({
    required this.id,
    required this.title,
    required this.batchId,
    required this.batchLabel,
    this.done = false,
    this.confidence,
  });

  final String id;
  final String title;
  final String batchId;
  final String batchLabel;
  bool done;
  String? confidence;
}

class StockItem {
  StockItem({
    required this.id,
    required this.strain,
    required this.size,
    required this.sku,
    required this.qty,
    required this.harvest,
    required this.batchCode,
  });

  final String id;
  final String strain;
  final String size;
  final String sku;
  int qty;
  final String harvest;
  final String batchCode;
}

class GrowArea {
  GrowArea({
    required this.id,
    required this.name,
    required this.kind,
    this.capacity,
    this.enabled = true,
  });

  final String id;
  String name;
  String kind;
  String? capacity;
  bool enabled;
}

class MotherPlant {
  MotherPlant({
    required this.id,
    required this.code,
    required this.strain,
    required this.status,
  });

  final String id;
  final String code;
  final String strain;
  final String status;
}

class SeedLot {
  SeedLot({
    required this.id,
    required this.name,
    required this.strain,
    required this.qty,
  });

  final String id;
  final String name;
  final String strain;
  final int qty;
}

class StoreOrder {
  StoreOrder({
    required this.id,
    required this.client,
    required this.status,
    required this.total,
    required this.when,
  });

  final String id;
  final String client;
  String status;
  final String total;
  final String when;
}

class Invoice {
  Invoice({
    required this.id,
    required this.number,
    required this.client,
    required this.amount,
    required this.status,
  });

  final String id;
  final String number;
  final String client;
  final String amount;
  String status;
}

class ClientRecord {
  ClientRecord({
    required this.id,
    required this.name,
    required this.license,
    required this.email,
  });

  final String id;
  final String name;
  final String license;
  final String email;
}

class Payment {
  Payment({
    required this.id,
    required this.client,
    required this.amount,
    required this.when,
    required this.method,
  });

  final String id;
  final String client;
  final String amount;
  final String when;
  final String method;
}

class LogField {
  LogField({
    required this.name,
    required this.enabled,
    this.type = 'Notes',
    this.unit,
    this.emoji = '📝',
  });

  final String name;
  bool enabled;
  final String type;
  final String? unit;
  final String emoji;
}

class InputItem {
  InputItem({
    required this.name,
    required this.unit,
    this.enabled = true,
  });

  final String name;
  final String unit;
  bool enabled;
}

class StrainItem {
  StrainItem({
    required this.name,
    required this.type,
    required this.flowerDays,
    this.enabled = true,
  });

  final String name;
  final String type;
  final String flowerDays;
  bool enabled;
}

class AppState extends ChangeNotifier {
  bool loggedIn = false;
  bool offline = false;
  bool lightTheme = true;
  String route = '/';
  final List<String> history = ['/'];
  String email = 'demo@growops.app';
  String growerName = 'Demo Grower';
  String workspace = 'Demo Farm';

  /// First-time walkthrough — shown after login until completed/skipped.
  bool guidanceCompleted = false;
  int guidanceStep = 0;

  bool get showGuidance => loggedIn && !guidanceCompleted;

  String searchBatches = '';
  String searchStock = '';
  String batchFilter = 'Active';
  String geneticsTab = 'Strains';
  String? selectedBatchId;

  final stagesList = stages;

  late List<GrowBatch> batches;
  late List<JournalEntry> journal;
  late List<GrowTask> tasks;
  late List<StockItem> stock;
  late List<GrowArea> areas;
  late List<MotherPlant> mothers;
  late List<SeedLot> seedLots;
  late List<StoreOrder> orders;
  late List<Invoice> invoices;
  late List<ClientRecord> clients;
  late List<Payment> payments;
  late List<LogField> logFields;
  late List<String> strains;
  late List<StrainItem> strainItems;
  late List<InputItem> inputItems;
  late List<String> inputs;
  late List<String> wasteReasons;
  String unitWeight = 'g';
  String unitVolume = 'L';
  String unitTemp = '°C';
  String unitNutrient = 'EC';

  AppState() {
    resetDemo();
  }

  void resetDemo() {
    strains = DemoSeedData.strains();
    strainItems = DemoSeedData.strainItems();
    inputs = DemoSeedData.inputs();
    inputItems = DemoSeedData.inputItems();
    wasteReasons = DemoSeedData.wasteReasons();
    logFields = DemoSeedData.logFields();
    batches = DemoSeedData.batches();
    journal = DemoSeedData.journal();
    tasks = DemoSeedData.tasks();
    stock = DemoSeedData.stock();
    areas = DemoSeedData.areas();
    mothers = DemoSeedData.mothers();
    seedLots = DemoSeedData.seedLots();
    orders = DemoSeedData.orders();
    invoices = DemoSeedData.invoices();
    clients = DemoSeedData.clients();
    payments = DemoSeedData.payments();
    unitWeight = 'g';
    unitVolume = 'L';
    unitTemp = '°C';
    unitNutrient = 'EC';
    searchBatches = '';
    searchStock = '';
    batchFilter = 'Active';
    geneticsTab = 'Strains';
    selectedBatchId = null;
    guidanceCompleted = false;
    guidanceStep = 0;
    notifyListeners();
  }

  void startGuidance() {
    guidanceCompleted = false;
    guidanceStep = 0;
    go(GuidanceCatalog.steps.first.route);
  }

  void nextGuidanceStep() {
    final steps = GuidanceCatalog.steps;
    if (guidanceStep >= steps.length - 1) {
      completeGuidance();
      return;
    }
    guidanceStep++;
    go(steps[guidanceStep].route);
  }

  void completeGuidance() {
    guidanceCompleted = true;
    guidanceStep = 0;
    go('/');
  }

  List<GrowBatch> get activeBatches =>
      batches.where((b) => !b.archived).toList();

  GrowBatch get focusBatch => batches.firstWhere((b) => b.id == 'b1');

  GrowBatch? batchById(String id) {
    try {
      return batches.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  void go(String path) {
    route = path;
    if (history.isEmpty || history.last != path) {
      history.add(path);
    }
    notifyListeners();
  }

  void back() {
    if (history.length > 1) {
      history.removeLast();
    }
    route = history.last;
    notifyListeners();
  }

  void login() {
    loggedIn = true;
    route = '/';
    history
      ..clear()
      ..add('/');
    // Show tour again only for first session after install/reset.
    if (!guidanceCompleted) {
      guidanceStep = 0;
    }
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    route = '/auth';
    history
      ..clear()
      ..add('/auth');
    notifyListeners();
  }

  void toggleOffline() {
    offline = !offline;
    notifyListeners();
  }

  void toggleTask(String taskId) {
    final task = tasks.where((t) => t.id == taskId).firstOrNull;
    if (task == null) return;
    task.done = !task.done;
    notifyListeners();
  }

  void addLog({
    required String batchId,
    required String activity,
    String notes = '',
    String? meta,
  }) {
    journal.insert(
      0,
      JournalEntry(
        batchId: batchId,
        title: activity,
        subtitle: notes.isEmpty ? activity : notes,
        when: 'Just now',
        ago: 'now',
        meta: meta,
        kind: activity.toLowerCase(),
      ),
    );
    notifyListeners();
  }

  void advanceStage(GrowBatch batch) {
    final next = nextStageLabel(batch.stage);
    if (next == batch.stage) return;
    batch.stage = next;
    addLog(
      batchId: batch.id,
      activity: 'Stage change',
      notes: 'Moved to $next',
    );
  }

  void completeHarvest({
    required String batchId,
    required String wet,
    required String trim,
    required String waste,
  }) {
    final b = batchById(batchId);
    if (b == null) return;
    b.stage = 'Drying';
    addLog(
      batchId: batchId,
      activity: 'Harvest',
      notes: 'Wet $wet g · Trim $trim g · Waste $waste g',
    );
    go('/drying');
  }

  void addBatch({
    required String strain,
    required String area,
    required int plants,
  }) {
    final n = batches.length + 1;
    final code = 'NB-C-${n.toString().padLeft(3, '0')}';
    batches.insert(
      0,
      GrowBatch(
        id: 'b$n${DateTime.now().millisecondsSinceEpoch}',
        code: code,
        strain: strain,
        stage: 'Seedling',
        plants: plants,
        area: area,
        day: 0,
        progress: 0.05,
        traceCode: 'GK-$code',
        started: 'Today',
      ),
    );
    go('/batches');
  }

  int areaBatches(GrowArea area) =>
      batches.where((b) => b.area == area.name && !b.archived).length;

  int areaPlants(GrowArea area) => batches
      .where((b) => b.area == area.name && !b.archived)
      .fold(0, (p, b) => p + b.plants);

  List<String> areaStages(GrowArea area) => batches
      .where((b) => b.area == area.name && !b.archived)
      .map((b) => b.stage.toUpperCase())
      .toSet()
      .toList();
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.notifier!;
  }
}
