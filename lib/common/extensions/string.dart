extension EnumEnhancements on String {
  String get enumName {
    var paths = split('.');

    return paths[paths.length - 1];
  }
}
