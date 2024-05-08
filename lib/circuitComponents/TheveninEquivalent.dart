class TheveninEquivalent {
  double voltage;
  double resistance;
  TheveninEquivalent(this.voltage, this.resistance);

  double calculateNortonCurrent() {
    if(voltage == 0) {
      return 0;
    }
    return this.voltage/this.resistance;
  }
}
