import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/common_widgets.dart';
import 'features/admin_dashboard/admin_dashboard_page.dart';
import 'features/pdf_viewer/pdf_viewer.dart';
import 'features/profiles/person_profile_page.dart';
import 'features/profiles/profile_data.dart';
import 'features/sectors/sector_data.dart';
import 'features/sectors/sector_detail_page.dart';
import 'features/user_dashboard/user_dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // clean URLs: "/" and "/super-admin"
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  runApp(
    AppStartupGate(
      supabaseUrl: supabaseUrl,
      supabasePublishableKey: supabasePublishableKey,
    ),
  );
}

class AppStartupGate extends StatefulWidget {
  const AppStartupGate({
    this.api,
    this.supabaseClient,
    this.supabaseUrl = '',
    this.supabasePublishableKey = '',
    super.key,
  });

  final ApiClient? api;
  final SupabaseClient? supabaseClient;
  final String supabaseUrl;
  final String supabasePublishableKey;

  @override
  State<AppStartupGate> createState() => _AppStartupGateState();
}

class _AppStartupGateState extends State<AppStartupGate> {
  late final ApiClient _api;
  SupabaseClient? _supabaseClient;
  bool _videoFinished = false;
  bool _supabaseFinished = false;

  @override
  void initState() {
    super.initState();
    _supabaseClient = widget.supabaseClient;
    _api =
        widget.api ??
        ApiClient(
          accessTokenProvider: () async =>
              _supabaseClient?.auth.currentSession?.accessToken,
        );
    if (_supabaseClient != null) {
      _supabaseFinished = true;
    } else if (widget.supabaseUrl.isNotEmpty &&
        widget.supabasePublishableKey.isNotEmpty) {
      unawaited(_initializeSupabase());
    } else {
      _supabaseFinished = true;
    }
  }

  Future<void> _initializeSupabase() async {
    try {
      await Supabase.initialize(
        url: widget.supabaseUrl,
        publishableKey: widget.supabasePublishableKey,
        authOptions: const FlutterAuthClientOptions(detectSessionInUri: false),
      ).timeout(const Duration(seconds: 15));
      _supabaseClient = Supabase.instance.client;
    } catch (error, stackTrace) {
      debugPrint('Supabase initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() => _supabaseFinished = true);
      }
    }
  }

  void _handleSplashComplete() {
    if (!mounted || _videoFinished) {
      return;
    }
    setState(() => _videoFinished = true);
  }

  @override
  Widget build(BuildContext context) {
    final ready = _videoFinished && _supabaseFinished;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: ready
          ? VoterFinderApp(
              key: const ValueKey('voter-finder-app'),
              api: _api,
              supabaseClient: _supabaseClient,
            )
          : Directionality(
              key: const ValueKey('intro-video'),
              textDirection: TextDirection.ltr,
              child: AppVideoLoadingScreen(onComplete: _handleSplashComplete),
            ),
    );
  }
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
