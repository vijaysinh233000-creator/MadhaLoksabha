import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/admin_dashboard/admin_dashboard_page.dart';
import 'features/pdf_viewer/pdf_viewer.dart';
import 'features/profiles/person_profile_page.dart';
import 'features/profiles/profile_data.dart';
import 'features/sectors/sector_data.dart';
import 'features/sectors/sector_detail_page.dart';
import 'features/user_dashboard/user_dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // clean URLs: "/" and "/super-admin"
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  SupabaseClient? supabaseClient;
  if (supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
      authOptions: const FlutterAuthClientOptions(detectSessionInUri: false),
    );
    supabaseClient = Supabase.instance.client;
  }
  final api = ApiClient(
    accessTokenProvider: () async =>
        supabaseClient?.auth.currentSession?.accessToken,
  );
  runApp(VoterFinderApp(api: api, supabaseClient: supabaseClient));
}

class VoterFinderApp extends StatelessWidget {
  const VoterFinderApp({this.api, this.supabaseClient, super.key});

  final ApiClient? api;
  final SupabaseClient? supabaseClient;

  @override
  Widget build(BuildContext context) {
    final apiClient = api ?? ApiClient();
    final browserUri = Uri.base;
    final initialRoute =
        browserUri.path + (browserUri.hasQuery ? '?${browserUri.query}' : '');
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<SupabaseClient?>.value(value: supabaseClient),
        Provider<PdfViewer>(create: (_) => PdfViewer(apiClient)),
      ],
      child: MaterialApp(
        title: 'मतदार यादी शोध केंद्र | Voter Finder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        initialRoute: initialRoute,
        onGenerateRoute: (settings) {
          final uri = Uri.tryParse(settings.name ?? '/') ?? Uri(path: '/');
          final profileSlug =
              uri.pathSegments.length == 2 &&
                  uri.pathSegments.first == 'profile'
              ? uri.pathSegments.last
              : null;
          final sectorSlug =
              uri.pathSegments.length == 2 && uri.pathSegments.first == 'sector'
              ? uri.pathSegments.last
              : null;
          final Widget page = switch (uri.path) {
            '/super-admin' ||
            '/super-admin/' ||
            '/admin' ||
            '/admin/' => const AdminDashboardPage(),
            _
                when profileSlug != null &&
                    personProfiles.containsKey(profileSlug) =>
              PersonProfilePage(profile: personProfiles[profileSlug]!),
            _
                when sectorSlug != null &&
                    sectorProfiles.containsKey(sectorSlug) =>
              SectorDetailPage(profile: sectorProfiles[sectorSlug]!),
            _ => UserDashboardPage(
              initialQuery: uri.queryParameters['q'] ?? '',
              initialVillage: uri.queryParameters['village'] ?? '',
            ),
          };
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 180),
          );
        },
      ),
    );
  }
}
