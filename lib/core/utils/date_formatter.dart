import 'package:intl/intl.dart';

const String storageDatePattern = 'dd/MM/yyyy';

String formatStorageDate(DateTime date) {
  return DateFormat(storageDatePattern).format(date);
}

String todayStorageDate() {
  return formatStorageDate(DateTime.now());
}

String formatDisplayDate(String raw) {
  try {
    final parsed = DateFormat(storageDatePattern).parseStrict(raw);
    return DateFormat.yMMMEd().format(parsed);
  } on FormatException {
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return DateFormat.yMMMEd().format(parsed);
    }
    return raw;
  }
}
