import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/cycle_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/period_entry.dart';

class LogSymptomsModal extends StatefulWidget {
  final DateTime selectedDate;
  const LogSymptomsModal({super.key, required this.selectedDate});

  static void show(BuildContext context, {DateTime? date}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LogSymptomsModal(selectedDate: date ?? DateTime.now()),
    );
  }

  @override
  State<LogSymptomsModal> createState() => _LogSymptomsModalState();
}

class _LogSymptomsModalState extends State<LogSymptomsModal> {
  final Set<String> _selectedSymptoms = {};
  String _selectedFlow = 'Medium';
  String _selectedMood = 'Neutral';
  final TextEditingController _notesController = TextEditingController();
  bool _isPeriodDay = true; 
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final cycle = Provider.of<CycleProvider>(context, listen: false);
      final entry = cycle.getPeriodByDate(widget.selectedDate);
      
      if (entry != null) {
        _notesController.text = entry.note ?? '';
        for (final s in entry.symptoms) {
          if (s.startsWith('Flow: ')) {
            _selectedFlow = s.substring(6);
            _isPeriodDay = true;
          } else if (s.startsWith('Mood: ')) {
            _selectedMood = s.substring(6);
          } else {
            _selectedSymptoms.add(s);
          }
        }
        // If "Flow" wasn't found, check if it was marked as a period day but without flow details
        // Or if it was explicitly not a period day.
        // For Narcicare, we assume existence of a record = period day unless logic says otherwise
        _isPeriodDay = entry.symptoms.any((s) => s.startsWith('Flow: '));
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cycleProvider = Provider.of<CycleProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    final dateStr = DateFormat('MMMM dd, yyyy').format(widget.selectedDate);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppTheme.accentCream,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.dailyLog, style: const TextStyle(color: AppTheme.primary, fontSize: 24, fontWeight: FontWeight.w900)),
                    Text(dateStr, style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Symbols.close, color: AppTheme.primary)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l.periodStatus),
                  SwitchListTile(
                    title: Text(l.isTodayPeriodDay, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    value: _isPeriodDay,
                    activeThumbColor: AppTheme.primary,
                    onChanged: (v) => setState(() => _isPeriodDay = v),
                  ),
                  const SizedBox(height: 24),
                  if (_isPeriodDay) ...[
                    _buildSectionTitle(l.flowIntensity),
                    const SizedBox(height: 12),
                    _buildSegmentedControl([l.light, l.medium, l.heavy], _selectedFlow, (v) => setState(() => _selectedFlow = v)),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionTitle(l.mood),
                  const SizedBox(height: 12),
                  _buildSegmentedControl([l.happy, l.neutral, l.sad, l.angry, l.anxious], _selectedMood, (v) => setState(() => _selectedMood = v)),
                  const SizedBox(height: 24),
                  _buildSectionTitle(l.symptoms),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <String>[l.cramps, l.headache, l.bloating, l.acne, l.fatigue, l.backache].map((s) => FilterChip(
                      label: Text(s),
                      selected: _selectedSymptoms.contains(s),
                      onSelected: (selected) => setState(() => selected ? _selectedSymptoms.add(s) : _selectedSymptoms.remove(s)),
                      selectedColor: AppTheme.accentPink,
                      checkmarkColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(l.notes),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l.howFeelingToday,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (user != null) {
                    final List<String> allSymptoms = _selectedSymptoms.toList();
                    if (_isPeriodDay) allSymptoms.add('Flow: $_selectedFlow');
                    allSymptoms.add('Mood: $_selectedMood');
                    
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);
                    
                    // Check if entry exists to decide between surgical update or new add
                    final existing = cycleProvider.getPeriodByDate(widget.selectedDate);
                    bool success;
                    
                    if (existing != null) {
                      // SURGICAL: Only update symptoms/notes (Requirement 4)
                      success = await cycleProvider.updateSymptoms(
                        user.id, 
                        widget.selectedDate, 
                        allSymptoms, 
                        _notesController.text
                      );
                    } else {
                      // ADD: Create new record
                      final entry = PeriodEntry(
                        userId: user.id,
                        startDate: widget.selectedDate,
                        symptoms: allSymptoms,
                        note: _notesController.text,
                      );
                      success = await cycleProvider.addPeriod(user.id, entry, user);
                    }
                    
                    if (mounted) {
                      navigator.pop();
                      String errorMsg = cycleProvider.lastErrorMessage ?? l.get('errorSavingLog');
                      messenger.showSnackBar(SnackBar(
                        content: Text(success ? l.get('logSaved') : errorMsg),
                        backgroundColor: success ? Colors.green : Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  }
                },
                child: Text(l.saveLog, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5));
  }

  Widget _buildSegmentedControl(List<String> options, String selected, Function(String) onSelected) {
    return Row(
      children: options.map((opt) => Expanded(
        child: GestureDetector(
          onTap: () => onSelected(opt),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected == opt ? AppTheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [if (selected == opt) BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 8)],
            ),
            child: Center(
              child: Text(opt, style: TextStyle(color: selected == opt ? Colors.white : AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ),
      )).toList(),
    );
  }
}
