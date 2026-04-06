import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/cycle_provider.dart';
import '../widgets/log_symptoms_overlay.dart';
import '../l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Data fetching is now handled by MainNavigation (bottom_nav_bar.dart)
    // to avoid redundant network calls between screens.
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final cycle = Provider.of<CycleProvider>(context);
    final user = auth.user;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      body: cycle.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildTopBar(user?.name ?? l.guest, l),
                    const SizedBox(height: 20),
                    _buildCycleCircle(cycle, user, l),
                    const SizedBox(height: 32),
                    _buildPredictionCards(cycle, user, l),
                    const SizedBox(height: 32),
                    _buildDailyInsight(cycle, user, l),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => LogSymptomsModal.show(context, date: DateTime.now()),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Symbols.add, color: Colors.white),
        label: Text(l.logDailyInfo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTopBar(String name, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.goodDay,
                style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6), fontSize: 14),
              ),
              Text(
                name,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 10),
              ],
            ),
            child: const Icon(Symbols.notifications, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleCircle(CycleProvider cycle, dynamic user, AppLocalizations l) {
    final day = cycle.getCycleDay(user);
    final cycleLength = user?.avgCycleLength ?? 28;
    final progress = (day / cycleLength).clamp(0.0, 1.0);
    final phaseMessage = cycle.getPhaseMessage(user, l);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentPink.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Progress Indicator
          SizedBox(
            width: 250,
            height: 250,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.day,
                style: TextStyle(
                  color: AppTheme.primary.withValues(alpha: 0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '$day',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 84,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  phaseMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCards(CycleProvider cycle, dynamic user, AppLocalizations l) {
    final nextPeriod = cycle.getNextPeriodDate(user);
    final ovulation = cycle.getOvulationDate(user);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _PredictionCard(
              title: l.nextPeriod,
              date: nextPeriod != null ? DateFormat('MMM dd', Localizations.localeOf(context).toString()).format(nextPeriod) : l.tbd,
              icon: Symbols.water_drop,
              color: AppTheme.accentPink,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _PredictionCard(
              title: l.ovulation,
              date: ovulation != null ? DateFormat('MMM dd', Localizations.localeOf(context).toString()).format(ovulation) : l.tbd,
              icon: Symbols.favorite,
              color: const Color(0xFFE0F2F1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyInsight(CycleProvider cycle, dynamic user, AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentPink.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Symbols.lightbulb, color: AppTheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.dailyInsight,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  l.dailyInsightText,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  final Color color;

  const _PredictionCard({
    required this.title,
    required this.date,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(color: AppTheme.primary, fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
