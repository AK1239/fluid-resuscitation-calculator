/// Number formatting utilities

/// Formats a number to a specified number of decimal places
String formatNumber(double value, {int decimals = 1}) {
  return value.toStringAsFixed(decimals);
}

/// Formats a number with no decimal places (for integers)
String formatInteger(double value) {
  return value.round().toString();
}

/// Formats volume in mL
String formatVolume(double volume) {
  if (volume >= 1000) {
    return '${formatNumber(volume / 1000, decimals: 2)} L';
  }
  return '${formatInteger(volume)} mL';
}

/// Formats rate in mL/hr
String formatRate(double rate) {
  return '${formatNumber(rate, decimals: 1)} mL/hr';
}

/// Formats electrolyte value with unit
String formatElectrolyte(double value, String unit) {
  return '${formatNumber(value, decimals: 1)} $unit';
}

/// Formats percentage
String formatPercent(double percent) {
  return '${formatNumber(percent, decimals: 1)}%';
}

/// Formats date as DD/MM/YYYY
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}

/// Formats date with month name (e.g., "17 May 2026")
String formatDateWithMonthName(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

