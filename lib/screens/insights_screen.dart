import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../providers/cycle_provider.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cycle = Provider.of<CycleProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final history = cycle.history;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: Text(l.analytics, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryHeader(user, l),
              const SizedBox(height: 24),
              _buildTrendChart(history, user, l),
              const SizedBox(height: 24),
              _buildSymptomFrequency(history, l),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(dynamic user, AppLocalizations l) {
    return Row(
      children: [
        _buildSummaryItem(l.averageCycle, '${user?.avgCycleLength ?? 28}${l.get('days').substring(0,1)}'),
        const SizedBox(width: 16),
        _buildSummaryItem(l.periodDuration, '${user?.avgPeriodDuration ?? 5}${l.get('days').substring(0,1)}'),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: AppTheme.primary, fontSize: 24, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChart(List history, dynamic user, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.cycleTrends, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5, color: Colors.grey)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: history.isEmpty 
                        ? [const FlSpot(0, 28), const FlSpot(4, 28)]
                        : List.generate(history.length, (i) => FlSpot(i.toDouble(), 28)), // Simplified for demo
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: AppTheme.primary.withValues(alpha: 1.0).withAlpha(25)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomFrequency(List history, AppLocalizations l) {
    final Map<String, int> counts = {};
    for (var entry in history) {
      for (var s in entry.symptoms) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.frequentSymptoms, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5, color: Colors.grey)),
          const SizedBox(height: 16),
          if (sorted.isEmpty)
            Text(l.logMoreData, style: const TextStyle(color: Colors.grey, fontSize: 13))
          else
            ...sorted.take(5).map((e) => _buildSymptomRow(e.key, e.value, history.length)),
        ],
      ),
    );
  }

  Widget _buildSymptomRow(String name, int count, int total) {
    final percent = count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
              Text('${(percent * 100).toInt()}%', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: AppTheme.accentCream,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentPink),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
