class StringHelper {
  static String sortID(String idFirst, String idSecond) {
    if (idFirst.compareTo(idSecond) <= 0) {
      return '${idFirst}_$idSecond';
    }
    return '${idSecond}_$idFirst';
  }
}
