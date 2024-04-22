class CircuitUtils {
  /// Converts the given value to a different unit based on the selected unit.
  static double convertValue(double value, String unit) {
    switch (unit) {
      case 'kΩ':
        return value * 1000; // Convert kilo-ohms to ohms
      case 'Ω':
        return value; // Ohms don't need conversion
      case 'mV':
      case 'mA':
        return value / 1000; // Convert milli-units to base units (volts or amperes)
      case 'V':
      case 'A':
        return value; // Volts and amperes don't need conversion
      default:
        throw FormatException('Unrecognized unit: $unit');
    }
  }
}

