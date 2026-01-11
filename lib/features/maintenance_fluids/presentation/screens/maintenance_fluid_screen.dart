import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/maintenance_fluids/presentation/providers/maintenance_fluid_providers.dart';
import 'package:chemical_app/features/maintenance_fluids/presentation/widgets/maintenance_result_widget.dart';

class MaintenanceFluidScreen extends ConsumerStatefulWidget {
  const MaintenanceFluidScreen({super.key});

  @override
  ConsumerState<MaintenanceFluidScreen> createState() =>
      _MaintenanceFluidScreenState();
}

class _MaintenanceFluidScreenState extends ConsumerState<MaintenanceFluidScreen> {
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(maintenanceFluidFormProvider);
    final result = ref.watch(maintenanceFluidResultProvider);
    final formNotifier = ref.read(maintenanceFluidFormProvider.notifier);

    // Sync controller with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Fluids'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Body Weight',
              unit: 'kg',
              controller: _weightController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeight(value),
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              MaintenanceResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}

