class TheveninEquivalent {
  double voltage;
  double resistance;
  TheveninEquivalent(this.voltage, this.resistance);

  double calculateNortonCurrent() {
    return this.voltage/this.resistance;
  }
}
