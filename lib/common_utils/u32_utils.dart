import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

List<u32> getUnsignedIntegerList(List<int> integers) {
  List<u32> result = [];
  for (int integerElement in integers) {
    result.add(u32(integerElement));
  }
  return result;
}

List<Tuple2<u32, String>> getUnsignedIntegerListWithMetaTextFromIntegers(
    List<int> integers) {
  List<Tuple2<u32, String>> result = [];
  for (int integerElement in integers) {
    result.add(Tuple2(u32(integerElement), ''));
  }
  return result;
}

List<Tuple2<u32, String>> getUnsignedIntegerListWithMetaTextFromUnsignedIntegers(
    List<u32> integers) {
  List<Tuple2<u32, String>> result = [];
  for (u32 unsignedInteger in integers) {
    result.add(Tuple2(unsignedInteger, ''));
  }
  return result;
}

bool isNonZeroUnsignedNumbers(List<u32> unsignedNumbersToCheck) {
  return unsignedNumbersToCheck
      .every((u32 unsignedNumberToCheck) => unsignedNumberToCheck > u32(0));
}
