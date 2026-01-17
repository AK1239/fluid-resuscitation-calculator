import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/urine_output_aki/presentation/providers/urine_output_aki_providers.dart';
import 'package:chemical_app/features/urine_output_aki/presentation/widgets/urine_output_aki_result_widget.dart';

class UrineOutputAkiScreen extends ConsumerStatefulWidget {
  const UrineOutputAkiScreen({super.key});

  @override
  ConsumerState<UrineOutputAkiScreen> createState() =>
      _UrineOutputAkiScreenState();
}

class _UrineOutputAkiScreenState extends ConsumerState<UrineOutputAkiScreen> {
  late final TextEditingController _currentVolumeController;
  late final TextEditingController _previousVolumeController;
  late final TextEditingController _weightController;
  final _formKey = GlobalKey<FormState>();
  
  // Track which fields have been interacted with
  bool _currentVolumeTouched = false;
  bool _previousVolumeTouched = false;
  bool _weightTouched = false;

  @override
  void initState() {
    super.initState();
    _currentVolumeController = TextEditingController();
    _previousVolumeController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _currentVolumeController.dispose();
    _previousVolumeController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectPreviousTime(BuildContext context) async {
    final formState = ref.read(urineOutputAkiFormProvider);
    final formNotifier = ref.read(urineOutputAkiFormProvider.notifier);

    // Show date picker first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          formState.previousTime ??
          DateTime.now().subtract(const Duration(hours: 6)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      helpText: 'Select Previous Measurement Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;
    if (!mounted) return;

    // Show time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: this.context,
      initialTime: TimeOfDay.fromDateTime(
        formState.previousTime ??
            DateTime.now().subtract(const Duration(hours: 6)),
      ),
      helpText: 'Select Previous Measurement Time',
    );

    if (!mounted) return;
    if (pickedTime != null) {
      final selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      formNotifier.setPreviousTime(selectedDateTime);
    }
  }

  Future<void> _selectCurrentTime(BuildContext context) async {
    final formState = ref.read(urineOutputAkiFormProvider);
    final formNotifier = ref.read(urineOutputAkiFormProvider.notifier);

    // Show date picker first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: formState.currentTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      helpText: 'Select Current Measurement Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    // Show time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: this.context,
      initialTime: TimeOfDay.fromDateTime(
        formState.currentTime ?? DateTime.now(),
      ),
      helpText: 'Select Current Measurement Time',
    );

    if (!mounted || pickedTime == null) return;
    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    formNotifier.setCurrentTime(selectedDateTime);
  }

  String? _validateCurrentVolume(String? value) {
    final error = validateUrineVolume(value);
    if (error != null) return error;

    // Additional validation: current volume must be >= previous volume
    final previousVol = double.tryParse(_previousVolumeController.text);
    if (previousVol != null && value != null && value.isNotEmpty) {
      final currentVol = double.tryParse(value);
      if (currentVol != null && currentVol < previousVol) {
        return 'Current volume must be ≥ previous volume';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(urineOutputAkiFormProvider);
    final result = ref.watch(urineOutputAkiResultProvider);
    final formNotifier = ref.read(urineOutputAkiFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    // For previous volume, allow empty string to stay empty (user can clear it)
    if (_currentVolumeController.text != (formState.currentVolume ?? '')) {
      _currentVolumeController.text = formState.currentVolume ?? '';
    }
    final previousVolumeState = formState.previousVolume ?? '';
    if (_previousVolumeController.text != previousVolumeState) {
      // Only sync if both are not empty, or if state is explicitly set
      // This allows user to clear the field without it being reset
      if (previousVolumeState.isNotEmpty ||
          _previousVolumeController.text.isEmpty) {
        _previousVolumeController.text = previousVolumeState;
      }
    }
    if (_weightController.text != (formState.weightKg ?? '')) {
      _weightController.text = formState.weightKg ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Urine Output & AKI Staging'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Urine Output Calculation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate urine output and KDIGO AKI staging based on urine volume measurements',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Current Urine Volume',
                unit: 'mL',
                controller: _currentVolumeController,
                validator: _currentVolumeTouched ? _validateCurrentVolume : null,
                onChanged: (value) {
                  if (!_currentVolumeTouched) {
                    setState(() {
                      _currentVolumeTouched = true;
                    });
                  }
                  formNotifier.setCurrentVolume(value);
                },
                onTap: () {
                  if (!_currentVolumeTouched) {
                    setState(() {
                      _currentVolumeTouched = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Previous Urine Volume',
                unit: 'mL',
                controller: _previousVolumeController,
                validator: _previousVolumeTouched
                    ? (value) {
                        // Allow empty (defaults to 0)
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        return validateUrineVolume(value);
                      }
                    : null,
                hintText: 'Optional (defaults to 0)',
                onChanged: (value) {
                  if (!_previousVolumeTouched) {
                    setState(() {
                      _previousVolumeTouched = true;
                    });
                  }
                  // Allow empty string - will default to 0 in calculation
                  formNotifier.setPreviousVolume(value.isEmpty ? null : value);
                },
                onTap: () {
                  if (!_previousVolumeTouched) {
                    setState(() {
                      _previousVolumeTouched = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Previous Measurement Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectPreviousTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'Tap to select date and time',
                    suffixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formState.previousTime != null
                            ? formatDateTime(formState.previousTime!)
                            : 'Select previous measurement time',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: formState.previousTime != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Current Measurement Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectCurrentTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'Tap to select date and time (defaults to now)',
                    suffixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formState.currentTime != null
                            ? formatDateTime(formState.currentTime!)
                            : 'Now (${formatDateTime(DateTime.now())})',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: formState.currentTime != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Patient Weight',
                unit: 'kg',
                controller: _weightController,
                validator: _weightTouched ? validateWeight : null,
                onChanged: (value) {
                  if (!_weightTouched) {
                    setState(() {
                      _weightTouched = true;
                    });
                  }
                  formNotifier.setWeightKg(value);
                },
                onTap: () {
                  if (!_weightTouched) {
                    setState(() {
                      _weightTouched = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Calculation Formula',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Urine Output = (Current Volume - Previous Volume) / (Weight × Time Interval)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (result != null) ...[
                const Divider(),
                const SizedBox(height: 16),
                UrineOutputAkiResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
