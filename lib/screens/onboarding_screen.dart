import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  DateTime _lastPeriodDate = DateTime.now().subtract(const Duration(days: 14));
  int _avgCycleLength = 28;
  int _avgPeriodDuration = 5;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.updateCycleSettings(
      lastPeriodDate: _lastPeriodDate,
      avgCycleLength: _avgCycleLength,
      avgPeriodDuration: _avgPeriodDuration,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildWelcomeStep(l),
                  _buildDateStep(l),
                  _buildCycleStep(l),
                  _buildDurationStep(l),
                ],
              ),
            ),
            _buildNavigationButtons(l),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentPage ? AppTheme.primary : AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomeStep(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png', width: 100, height: 100),
          const SizedBox(height: 32),
          Text(
            l.welcomeToCompanion,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.setupProfileText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.primary.withValues(alpha: 0.7),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStep(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.whenLastPeriod,
            style: const TextStyle(color: AppTheme.primary, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l.trackingPredictText,
            style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6), fontSize: 16),
          ),
          const Spacer(),
          Center(
            child: CalendarDatePicker(
              initialDate: _lastPeriodDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
              onDateChanged: (date) => setState(() => _lastPeriodDate = date),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCycleStep(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.howLongCycle,
            style: const TextStyle(color: AppTheme.primary, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l.cycleHelpText,
            style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6), fontSize: 16),
          ),
          const Expanded(child: SizedBox()),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleButton(Symbols.remove, () {
                  if (_avgCycleLength > 15) setState(() => _avgCycleLength--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        '$_avgCycleLength',
                        style: const TextStyle(fontSize: 84, fontWeight: FontWeight.w900, color: AppTheme.primary),
                      ),
                      Text(l.days.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.primary)),
                    ],
                  ),
                ),
                _buildCircleButton(Symbols.add, () {
                  if (_avgCycleLength < 45) setState(() => _avgCycleLength++);
                }),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildDurationStep(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.howLongPeriod,
            style: const TextStyle(color: AppTheme.primary, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l.periodHelpText,
            style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6), fontSize: 16),
          ),
          const Expanded(child: SizedBox()),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleButton(Symbols.remove, () {
                  if (_avgPeriodDuration > 1) setState(() => _avgPeriodDuration--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        '$_avgPeriodDuration',
                        style: const TextStyle(fontSize: 84, fontWeight: FontWeight.w900, color: AppTheme.primary),
                      ),
                      Text(l.days.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.primary)),
                    ],
                  ),
                ),
                _buildCircleButton(Symbols.add, () {
                  if (_avgPeriodDuration < 15) setState(() => _avgPeriodDuration++);
                }),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: AppTheme.primary.withValues(alpha: 0.1), blurRadius: 10),
          ],
        ),
        child: Icon(icon, color: AppTheme.primary),
      ),
    );
  }

  Widget _buildNavigationButtons(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: _previousPage,
              child: Text(l.back, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
            )
          else
            const SizedBox(),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              children: [
                Text(_currentPage == 3 ? l.finish : l.next, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Symbols.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
