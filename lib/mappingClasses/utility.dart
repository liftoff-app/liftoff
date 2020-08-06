class UtilityClass {
  ///Parses date from Json.
  ///May return null on wrong argument
  static DateTime ParseDateFromJson(String t) {
    return DateTime.tryParse(t);
  }
}
