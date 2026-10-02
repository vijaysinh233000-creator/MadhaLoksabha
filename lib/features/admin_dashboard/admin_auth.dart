import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/models/models.dart';
import '../../core/services/api_client.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';

class AdminAccessController extends ChangeNotifier {
  AdminAccessController({required this.auth, required this.api});

  final SupabaseClient? auth;
  final ApiClient api;
  StreamSubscription<AuthState>? _authSubscription;
  bool _verificationInFlight = false;

  bool loading = true;
  bool busy = false;
  bool authorized = false;
  String? error;

  Future<void> init() async {
    final client = auth;
    if (client == null) {
      loading = false;
      error = 'Admin sign-in is not configured for this build.';
      notifyListeners();
      return;
    }
    _authSubscription = client.auth.onAuthStateChange.listen((state) {
      if (state.session == null) {
        authorized = false;
        loading = false;
        notifyListeners();
      } else if (!authorized && !_verificationInFlight) {
        unawaited(_verifyAdmin());
      }
    });
    if (client.auth.currentSession == null) {
      loading = false;
      notifyListeners();
      return;
    }
    await _verifyAdmin();
  }

  Future<void> signIn(String email, String password) async {
    final client = auth;
    if (client == null || busy) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      await _verifyAdmin();
    } on AuthException catch (e) {
      authorized = false;
      error = e.message;
    } catch (e) {
      authorized = false;
      error = _message(e);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> _verifyAdmin() async {
    if (_verificationInFlight) return;
    _verificationInFlight = true;
    loading = true;
    notifyListeners();
    try {
      await api.adminVillages();
      authorized = auth?.auth.currentSession != null;
      error = null;
    } on ApiException catch (e) {
      authorized = false;
      if (e.statusCode == 403) {
        error = 'This account is not authorized as an administrator.';
        await auth?.auth.signOut();
      } else if (e.statusCode == 401) {
        error = 'Your session is invalid or expired. Please sign in again.';
        await auth?.auth.signOut();
      } else {
        error = e.message;
      }
    } catch (e) {
      authorized = false;
      error = _message(e);
    } finally {
      _verificationInFlight = false;
      loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    authorized = false;
    loading = true;
    notifyListeners();
    try {
      await auth?.auth.signOut();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  String _message(Object error) {
    if (error is ApiException) return error.message;
    return 'Could not verify administrator access. Check your connection and try again.';
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

class AdminSignInPage extends StatefulWidget {
  const AdminSignInPage({super.key});

  @override
  State<AdminSignInPage> createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(AdminAccessController access) async {
    if (!_formKey.currentState!.validate()) return;
    await access.signIn(_email.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AdminAccessController>();
    final configured = access.auth != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin sign in'),
        actions: [
          IconButton(
            tooltip: 'Public search',
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
            icon: const Icon(Icons.public_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 42,
                        color: AppColors.green,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        configured ? 'Administrator access' : 'Setup required',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!configured)
                        Text(
                          access.error ??
                              'Configure Supabase URL and publishable key for this build.',
                          textAlign: TextAlign.center,
                        )
                      else ...[
                        TextFormField(
                          controller: _email,
                          enabled: !access.busy,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.username],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) =>
                              value == null || !value.trim().contains('@')
                              ? 'Enter a valid email address'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          enabled: !access.busy,
                          obscureText: _obscurePassword,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter your password'
                              : null,
                          onFieldSubmitted: (_) => _submit(access),
                        ),
                        if (access.error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            access.error!,
                            style: const TextStyle(color: AppColors.danger),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: access.busy ? null : () => _submit(access),
                          icon: access.busy
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.login_rounded),
                          label: Text(
                            access.busy ? 'Signing in...' : 'Sign in',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
