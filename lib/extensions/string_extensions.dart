extension StringExtensions on String {

  String get capitalizeFirst => "${this[0].toUpperCase()}${substring(1)}";
  String get capitalizeFirstEach => split(" ").map((str) => str.capitalizeFirst).join(" ");
}