/// Centralized route path constants.
///
/// Mirrors the existing string routing in [AppShell] for Phase 3 migration.
abstract final class AppRoutes {
  // Auth
  static const auth = '/auth';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';

  // Main tabs
  static const home = '/';
  static const batches = '/batches';
  static const tasks = '/tasks';
  static const inventory = '/inventory';
  static const more = '/more';

  static const mainTabs = [home, batches, tasks, inventory, more];

  // Cultivation
  static const log = '/log';
  static const newBatch = '/new-batch';
  static const scan = '/scan';
  static const harvest = '/harvest';
  static const drying = '/drying';
  static const curing = '/curing';
  static const packaging = '/packaging';
  static const genetics = '/genetics';
  static const areas = '/areas';

  // Sales
  static const salesOrders = '/sales/orders';
  static const salesOrdersNew = '/sales/orders/new';
  static const salesInvoices = '/sales/invoices';
  static const salesInvoicesNew = '/sales/invoices/new';
  static const salesClients = '/sales/clients';
  static const salesPayments = '/sales/payments';

  // Reports & settings
  static const reports = '/reports';
  static const settings = '/settings';
  static const settingsDailyLog = '/settings/daily-log';
  static const settingsStrains = '/settings/strains';
  static const settingsRooms = '/settings/rooms';
  static const settingsInputs = '/settings/inputs';
  static const settingsUnits = '/settings/units';

  // Workspace
  static const workspace = '/workspace';
  static const profile = '/profile';
  static const workspaceInvite = '/workspace/invite';
  static const workspaceActivity = '/workspace/activity';
  static const workspaceNew = '/workspace/new';

  static String batchDetail(String id) => '/batches/$id';
  static String inventoryDetail(String id) => '/inventory/$id';
  static String areaDetail(String id) => '/areas/$id';
  static String motherDetail(String id) => '/mothers/$id';
  static String trace(String code) => '/trace/$code';
  static String invoiceDetail(String id) => '/sales/invoices/$id';
  static String clientDetail(String id) => '/sales/clients/$id';
}
