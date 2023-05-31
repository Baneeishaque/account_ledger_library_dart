String reverseText(String input) {
  String result = "";

  //split string and find all punctuations that end word(s)
  List<String> punctuations = [];
  final splitString = input.split(" ");

  for (var i in splitString) {
    final punctuation = _getPunctuation(i);
    if (punctuation != null) {
      punctuations.add(punctuation);
    }
  }

  int index = 0;

  //the idea is to rewrite the sentence from right to left
  //when a punctuation is found, it is replaced with the
  //original punctuation for that position (from left to right)
  for (int i = splitString.length - 1; i >= 0; i--) {
    final word = splitString[i];

    final punctuation = _getPunctuation(word);

    if (i > 0 && _getPunctuation(splitString[i - 1]) != null) {
      if (i == splitString.length - 1 && punctuation != null) {
        result +=
            " ${word.substring(0, word.length - 1)}${punctuations[index]}";
      } else {
        result += " $word${punctuations[index]}";
      }
      index++;
    } else if (punctuation != null) {
      result += " ${word.substring(0, word.length - 1)}";
    } else {
      result += " $word";
    }
  }
  if (index != punctuations.length) {
    result += punctuations.last;
  }

  return result.trim();
}

String? _getPunctuation(String input) {
  //add to this list to cater for more punctuation marks
  final punctuations = [".", ",", "?", "!"];

  String lastChar = input[input.length - 1];

  if (punctuations.contains(lastChar)) return lastChar;
  return null;
}
