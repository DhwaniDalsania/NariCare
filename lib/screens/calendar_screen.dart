import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../providers/cycle_provider.dart';
import '../providers/auth_provider.dart';
import '../models/period_entry.dart';
import '../l10n/app_localizations.dart';
import '../widgets/log_symptoms_overlay.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// Requirement 1: handleDayTap(selectedDate)
  void handleDayTap(DateTime selectedDate) {
    setState(() {
      _selectedDay = selectedDate;
      _focusedDay = selectedDate;
    });

    final cycle = Provider.of<CycleProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user;
    final l = AppLocalizations.of(context);

    /// Requirement 2: getPeriodByDate(DateTime date)
    final existingEntry = cycle.getPeriodByDate(selectedDate);
    
    _showActionSheet(selectedDate, existingEntry, cycle, user, l);
  }

  /// Requirement 3: showModalBottomSheet with data-dependent options
  void _showActionSheet(DateTime date, PeriodEntry? existing, CycleProvider cycle, dynamic user, AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text(
              DateFormat('MMMM dd, yyyy').format(date),
              style: const TextStyle(color: AppTheme.primary, fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            if (existing != null) ...[
              /// IF period exists: Edit Date, Delete, Add/Edit Symptoms
              _buildActionButton(
                icon: Symbols.edit_calendar,
                label: l.editCycleDate,
                color: AppTheme.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditDialog(existing, l);
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Symbols.notes,
                label: l.editSymptoms,
                color: AppTheme.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  LogSymptomsModal.show(context, date: date);
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Symbols.delete,
                label: l.deletePeriod,
                color: Colors.redAccent,
                onTap: () async {
                  Navigator.pop(ctx);
                  if (user != null) {
                    await cycle.deletePeriod(user.id, date);
                  }
                },
              ),
            ] else ...[
              /// IF no period: Mark Start, Log Symptoms
              _buildActionButton(
                icon: Symbols.water_drop,
                label: l.markAsStart,
                color: AppTheme.accentPink,
                onTap: () async {
                  Navigator.pop(ctx);
                  if (user != null) {
                    final entry = PeriodEntry(userId: user.id, startDate: date, symptoms: []);
                    await cycle.addPeriod(user.id, entry, user);
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Symbols.notes,
                label: l.logDailyInfo,
                color: AppTheme.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  LogSymptomsModal.show(context, date: date);
                },
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
            const Spacer(),
            Icon(Symbols.chevron_right, color: color.withValues(alpha: 0.3), size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycle = Provider.of<CycleProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: Text(l.cycleHistory, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCalendar(cycle, user, l),
          const SizedBox(height: 16),
          _buildLegend(l),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (user != null) {
                  await cycle.fetchHistory(user.id);
                }
              },
              color: AppTheme.primary,
              child: _buildHistoryList(cycle, user, l),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(CycleProvider cycle, dynamic user, AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365 * 2)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) => handleDayTap(selectedDay),
        onFormatChanged: (format) => setState(() => _calendarFormat = format),
        locale: Localizations.localeOf(context).toString(),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: AppTheme.primary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) => _buildCell(day, cycle, user),
          todayBuilder: (context, day, focusedDay) => _buildCell(day, cycle, user, isToday: true),
          selectedBuilder: (context, day, focusedDay) => _buildCell(day, cycle, user, isSelected: true),
        ),
      ),
    );
  }

  Widget _buildCell(DateTime day, CycleProvider cycle, dynamic user, {bool isToday = false, bool isSelected = false}) {
    final isPeriod = cycle.isPeriodDay(day, user);
    final isPredicted = cycle.isPredictedPeriodDay(day, user);
    final fertileWindow = cycle.getFertileWindow(user);
    final isFertile = fertileWindow.any((d) => cycle.isSameDay(d, day));
    final ovulation = cycle.getOvulationDate(user);
    final isOvulation = ovulation != null && cycle.isSameDay(ovulation, day);

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPeriod 
            ? AppTheme.accentPink 
            : isFertile 
                ? const Color(0xFFE0F2F1) 
                : isSelected 
                    ? AppTheme.primary.withValues(alpha: 0.1) 
                    : Colors.transparent,
        border: isPredicted 
            ? Border.all(color: AppTheme.accentPink, width: 2, style: BorderStyle.solid) 
            : isToday 
                ? Border.all(color: AppTheme.primary, width: 2) 
                : null,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: isPeriod ? Colors.white : AppTheme.primary,
                fontWeight: (isPeriod || isToday || isFertile) ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isOvulation)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(l.periodLabel, AppTheme.accentPink),
          _buildLegendItem(l.fertileLabel, const Color(0xFFE0F2F1)),
          _buildLegendItem(l.predictedLabel, Colors.white, borderColor: AppTheme.accentPink),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {Color? borderColor}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHistoryList(CycleProvider cycle, dynamic user, AppLocalizations l) {
    if (cycle.isLoading && cycle.history.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
    }
    
    if (cycle.history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.history, size: 64, color: AppTheme.primary.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              Text(l.noHistoryFound, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: cycle.history.length,
      itemBuilder: (context, index) {
        final entry = cycle.history[index];
        int? cycleLength;
        if (index < cycle.history.length - 1) {
          cycleLength = entry.startDate.difference(cycle.history[index + 1].startDate).inDays;
        }
        return _buildHistoryCard(entry, cycleLength, l);
      },
    );
  }

  Widget _buildHistoryCard(PeriodEntry entry, int? cycleLength, AppLocalizations l) {
    final startStr = DateFormat('MMM dd, yyyy').format(entry.startDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentPink.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Symbols.water_drop, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(startStr, style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primary, fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  cycleLength != null ? '$cycleLength day cycle' : 'Current active log',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                if (entry.symptoms.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 4,
                      children: entry.symptoms.take(3).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppTheme.accentCream, borderRadius: BorderRadius.circular(8)),
                        child: Text(s.contains(":") ? s.split(":")[0] : s, style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showEditDialog(entry, l),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Symbols.edit, color: AppTheme.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(PeriodEntry entry, AppLocalizations l) {
    DateTime selectedStart = entry.startDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.accentCream,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          title: Text(l.editCycleDate, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  title: const Text('New Start Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primary)),
                  subtitle: Text(DateFormat('MMMM dd, yyyy').format(selectedStart)),
                  trailing: const Icon(Symbols.calendar_month, color: AppTheme.primary),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedStart,
                      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
                      lastDate: DateTime.now(),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(primary: AppTheme.primary, onPrimary: Colors.white, surface: Colors.white, onSurface: AppTheme.primary),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedStart = picked);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Professional Tip: Your cycle predictions will automatically adjust based on this new date.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                final cycle = Provider.of<CycleProvider>(context, listen: false);
                
                if (auth.user != null && entry.id != null) {
                  final success = await cycle.updatePeriod(
                    auth.user!.id, 
                    entry.id!, 
                    {
                      'startDate': Timestamp.fromDate(selectedStart),
                    }
                  );
                  
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    String msg = success 
                        ? l.get('logUpdated') 
                        : (cycle.lastErrorMessage ?? l.get('errorSavingLog'));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(msg),
                      backgroundColor: success ? Colors.green : Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary, 
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l.update.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
