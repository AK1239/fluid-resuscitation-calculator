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

