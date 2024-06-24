class CircuitUtils {
  // Converts the given value to a different unit based on the selected unit.
  static double convertValue(double value, String unit) {
    switch (unit) {
      case 'kΩ':
        return value * 1000;
      case 'Ω':
        return value;
      case 'mV':
      case 'mA':
        return value / 1000;
      case 'V':
      case 'A':
        return value;
      default:
        throw FormatException('Unrecognized unit: $unit');
    }
  }

  static String formatOhms(double resistance) {
    if (resistance.abs() < 100) {
      return "${resistance.toStringAsFixed(2)} Ω";
    } else {
      return "${(resistance / 1000).toStringAsFixed(2)} kΩ";
    }
  }

  static String formatAmperes(double current) {
    if (current.abs() < 1) {
      return "${(current * 1000).toStringAsFixed(2)} mA";
    } else {
      return "${current.toStringAsFixed(2)} A";
    }
  }

  static String formatVolts(double voltage) {
    if (voltage.abs() < 0.1) {
      return "${(voltage * 1000).toStringAsFixed(2)} mV";
    } else {
      return "${voltage.toStringAsFixed(2)} V";
    }
  }

}

