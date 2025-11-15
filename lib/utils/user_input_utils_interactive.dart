import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import '../common_utils/input_utils_interactive.dart';

Tuple7<u32, String, String, double, u32, u32, u32>
getUserInputUpToThreeParties({
  String party1AccountIdDataSpecification = "Party 1 Account ID",
  String party2AccountIdDataSpecification = "Party 2 Account ID",
  String party3AccountIdDataSpecification = "Party 3 Account ID",
}) {
  u32 userId = inputValidUnsignedPositiveInteger(dataSpecification: "User ID");
  String eventDateTime = inputValidText(dataSpecification: "Event Date Time");
  String particulars = inputValidText(dataSpecification: "Particulars");
  double amount = inputValidDouble(dataSpecification: "Amount");
  u32 party1AccountId = inputValidUnsignedPositiveInteger(
    dataSpecification: party1AccountIdDataSpecification,
  );
  u32 party2AccountId = inputValidUnsignedPositiveInteger(
    dataSpecification: party2AccountIdDataSpecification,
  );
  u32 party3AccountId = inputValidUnsignedPositiveInteger(
    dataSpecification: party3AccountIdDataSpecification,
  );
  return Tuple7(
    userId,
    eventDateTime,
    particulars,
    amount,
    party1AccountId,
    party2AccountId,
    party3AccountId,
  );
}
