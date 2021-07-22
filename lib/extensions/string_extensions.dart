extension StringExtensions on String {

  String get capitalizeFirst => "${this[0].toUpperCase()}${this.substring(1)}";
  String get capitalizeFirstEach => this.split(" ").map((str) => str.capitalizeFirst).join(" ");
}