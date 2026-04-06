import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l = AppLocalizations.of(context);

    setState(() => _isLoading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    bool success = false;
    String errorMessage = l.get('authFailed');

    try {
      success = _isLogin
          ? await auth.login(_emailController.text.trim(), _passwordController.text)
          : await auth.signup(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text);
    } catch (e) {
      errorMessage = l.get('somethingWrong');
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (!success) {
        // PRIORITIZE the specific provider error if it exists
        final finalMessage = auth.errorMessage ?? errorMessage;
        debugPrint('[NARICARE DIAGNOSTICS] Show SnackBar Error: $finalMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(finalMessage),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Image.asset('assets/images/logo.png', width: 80, height: 80),
              ),
              const SizedBox(height: 40),
              Text(
                _isLogin ? l.welcomeBack : l.joinCompanion,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin ? l.signIn : l.startTracking,
                style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6), fontSize: 16),
              ),
              const SizedBox(height: 48),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isLogin)
                      _buildTextField(
                        controller: _nameController,
                        label: l.fullName,
                        icon: Symbols.person,
                        validator: (v) => v!.isEmpty ? l.nameRequired : null,
                      ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: l.emailAddress,
                      icon: Symbols.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => !v!.contains('@') ? l.emailInvalid : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      label: l.password,
                      icon: Symbols.lock,
                      obscureText: _obscurePassword,
                      isPassword: true,
                      validator: (v) => v!.length < 6 ? l.passwordTooShort : null,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(_isLogin ? l.login : l.createAccount, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: RichText(
                        text: TextSpan(
                          text: _isLogin ? l.noAccount : l.haveAccount,
                          style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6)),
                          children: [
                            TextSpan(
                              text: _isLogin ? l.signUp : l.loginText,
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppTheme.primary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: AppTheme.primary,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primary, width: 1)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppTheme.primary.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
