/// Input validation functions

/// Validates weight input
String? validateWeight(String? value) {
  if (value == null || value.isEmpty) {
    return 'Weight is required';
  }
  final weight = double.tryParse(value);
  if (weight == null) {
    return 'Please enter a valid number';
  }
  if (weight <= 0) {
    return 'Weight must be greater than 0';
  }
  if (weight > 500) {
    return 'Weight seems unrealistic (max 500 kg)';
  }
  return null;
}

/// Validates sodium level
String? validateSodium(String? value) {
  if (value == null || value.isEmpty) {
    return 'Sodium level is required';
  }
  final sodium = double.tryParse(value);
  if (sodium == null) {
    return 'Please enter a valid number';
  }
  if (sodium < 100 || sodium > 200) {
    return 'Sodium level seems out of range (100-200 mEq/L)';
  }
  return null;
}

/// Validates potassium level
String? validatePotassium(String? value) {
  if (value == null || value.isEmpty) {
    return 'Potassium level is required';
  }
  final potassium = double.tryParse(value);
  if (potassium == null) {
    return 'Please enter a valid number';
  }
  if (potassium < 1.0 || potassium > 10.0) {
    return 'Potassium level seems out of range (1.0-10.0 mEq/L)';
  }
  return null;
}

/// Validates magnesium level
String? validateMagnesium(String? value) {
  if (value == null || value.isEmpty) {
    return 'Magnesium level is required';
  }
  final magnesium = double.tryParse(value);
  if (magnesium == null) {
    return 'Please enter a valid number';
  }
  if (magnesium < 0.5 || magnesium > 5.0) {
    return 'Magnesium level seems out of range (0.5-5.0 mg/dL)';
  }
  return null;
}

/// Validates calcium level
String? validateCalcium(String? value) {
  if (value == null || value.isEmpty) {
    return 'Calcium level is required';
  }
  final calcium = double.tryParse(value);
  if (calcium == null) {
    return 'Please enter a valid number';
  }
  if (calcium < 1.25 || calcium > 3.75) {
    return 'Calcium level seems out of range (1.25-3.75 mmol/L)';
  }
  return null;
}

/// Validates that target value is different from current value
String? validateTargetDifferent({
  required String? targetValue,
  required String? currentValue,
  required String fieldName,
}) {
  if (targetValue == null || targetValue.isEmpty) {
    return 'Target $fieldName is required';
  }
  final target = double.tryParse(targetValue);
  final current = double.tryParse(currentValue ?? '');

  if (target == null) {
    return 'Please enter a valid number';
  }
  if (current != null && target == current) {
    return 'Target must be different from current value';
  }
  return null;
}

/// Validates that target is greater than current (for corrections)
String? validateTargetGreater({
  required String? targetValue,
  required String? currentValue,
  required String fieldName,
}) {
  final error = validateTargetDifferent(
    targetValue: targetValue,
    currentValue: currentValue,
    fieldName: fieldName,
  );
  if (error != null) return error;

  final target = double.tryParse(targetValue ?? '');
  final current = double.tryParse(currentValue ?? '');

  if (target != null && current != null && target <= current) {
    return 'Target must be greater than current value';
  }
  return null;
}

/// Validates that target is less than current (for corrections)
String? validateTargetLess({
  required String? targetValue,
  required String? currentValue,
  required String fieldName,
}) {
  final error = validateTargetDifferent(
    targetValue: targetValue,
    currentValue: currentValue,
    fieldName: fieldName,
  );
  if (error != null) return error;

  final target = double.tryParse(targetValue ?? '');
  final current = double.tryParse(currentValue ?? '');

  if (target != null && current != null && target >= current) {
    return 'Target must be less than current value';
  }
  return null;
}

/// Validates date input in DD/MM/YYYY format
String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Date is required';
  }
  
  final parts = value.split('/');
  if (parts.length != 3) {
    return 'Please enter date in DD/MM/YYYY format';
  }

  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);

  if (day == null || month == null || year == null) {
    return 'Please enter valid numbers';
  }
  
  if (month < 1 || month > 12) {
    return 'Month must be between 1 and 12';
  }
  
  if (day < 1 || day > 31) {
    return 'Day must be between 1 and 31';
  }
  
  if (year < 1900 || year > 2100) {
    return 'Year must be between 1900 and 2100';
  }

  try {
    DateTime(year, month, day);
    return null;
  } catch (e) {
    return 'Invalid date';
  }
}

/// Validates age in months (0-59 months for WHO standards)
String? validateAgeMonths(String? value) {
  if (value == null || value.isEmpty) {
    return 'Age is required';
  }
  final age = int.tryParse(value);
  if (age == null) {
    return 'Please enter a valid number';
  }
  if (age < 0) {
    return 'Age cannot be negative';
  }
  if (age > 59) {
    return 'Age must be ≤59 months for WHO Child Growth Standards';
  }
  return null;
}

/// Validates height in cm
String? validateHeightCm(String? value) {
  if (value == null || value.isEmpty) {
    return 'Height is required';
  }
  final height = double.tryParse(value);
  if (height == null) {
    return 'Please enter a valid number';
  }
  if (height <= 0) {
    return 'Height must be greater than 0';
  }
  if (height > 200) {
    return 'Height seems unrealistic (max 200 cm)';
  }
  return null;
}

/// Validates Z-score (typically ranges from -6 to +6)
String? validateZScore(String? value) {
  if (value == null || value.isEmpty) {
    return 'Z-score is required';
  }
  final zScore = double.tryParse(value);
  if (zScore == null) {
    return 'Please enter a valid number';
  }
  if (zScore < -6 || zScore > 6) {
    return 'Z-score seems out of range (-6 to +6)';
  }
  return null;
}
