DateTime convertToFornattedDateTime(
    String formattedDateTime, int? hour, int? minute) {
  int year = int.parse(formattedDateTime.substring(
      formattedDateTime.length - 4, formattedDateTime.length));
  formattedDateTime = formattedDateTime.replaceRange(
      formattedDateTime.length - 4, formattedDateTime.length, "");
  int month =
      int.parse(formattedDateTime.substring(formattedDateTime.length - 1));
  formattedDateTime = formattedDateTime.replaceRange(
      formattedDateTime.length - 1, formattedDateTime.length, "");
  int day = int.parse(formattedDateTime);
  DateTime fd = DateTime(year, month, day, hour ?? 0, minute ?? 0);
  return fd;
}
