double? findNumberInString(String src) {
  final floatPattern = RegExp(r'\d+\.\d+');
  final intPattern = RegExp(r'\d+');
  try {
    return double.parse(floatPattern.firstMatch(src)!.group(0)!);
  } catch (e) {
    try {
      return double.parse(intPattern.firstMatch(src)!.group(0)!);
    } catch (e) {
      return null;
    }
  }
}
