import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'onboarding_screen.dart';
import 'auth_screen.dart';
import 'government_schemes_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: Text(l.profileSettings, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildProfileHeader(context),
              _buildCycleStats(context, l),
              _buildSettingsGroup(context, l),
              _buildLogoutButton(context, l),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.accentPink,
            child: Text(
              user?.name.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(user?.name ?? 'User Name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primary)),
          Text(user?.email ?? 'email@example.com', style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.5), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCycleStats(BuildContext context, AppLocalizations l) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.cycleSettings, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5, color: Colors.grey)),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())),
                child: Text(l.edit, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow(l.averageCycle, '${user?.avgCycleLength ?? 28} ${l.days}'),
          const Divider(height: 32),
          _buildStatRow(l.periodDuration, '${user?.avgPeriodDuration ?? 5} ${l.days}'),
          const Divider(height: 32),
          _buildStatRow(
            l.lastPeriodStarted,
            user?.lastPeriodDate != null ? DateFormat('MMM dd, yyyy').format(user!.lastPeriodDate!) : l.notSet,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildSettingsGroup(BuildContext context, AppLocalizations l) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          _buildSwitchTile(Symbols.notifications, l.notifications),
          _buildSwitchTile(Symbols.lock, l.passcodeLock),
          ListTile(
            leading: const Icon(Symbols.language, color: AppTheme.primary),
            title: Text(l.language, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(localeProvider.languageName, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
              ],
            ),
            onTap: () => _showLanguagePicker(context, l, localeProvider),
          ),
          ListTile(
            leading: const Icon(Symbols.account_balance, color: AppTheme.primary),
            title: const Text('Government Schemes', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            subtitle: const Text('National & State initiatives', style: TextStyle(fontSize: 12, color: Colors.grey)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GovernmentSchemesScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
      trailing: CupertinoSwitch(value: true, activeTrackColor: AppTheme.primary, onChanged: (v) {}),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l, LocaleProvider localeProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        const languages = [
          {'code': 'en', 'name': 'English', 'native': 'English'},
          {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
          {'code': 'gu', 'name': 'Gujarati', 'native': 'ગુજરાતી'},
        ];

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.selectLanguage, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              const SizedBox(height: 16),
              ...languages.map((lang) {
                final isSelected = localeProvider.locale.languageCode == lang['code'];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Text(lang['code'] == 'en' ? '🇬🇧' : lang['code'] == 'hi' ? '🇮🇳' : '🇮🇳', style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(lang['native']!, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppTheme.primary : Colors.black87)),
                  subtitle: Text(lang['name']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primary) : null,
                  onTap: () {
                    localeProvider.setLocale(lang['code']!);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _confirmLogout(context, l),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: Text(l.logout, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l.logout, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        content: Text(l.logoutConfirm, style: const TextStyle(color: AppTheme.primary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // close dialog
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (context.mounted) {
                // Clear entire navigation stack and go to auth screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }
}
