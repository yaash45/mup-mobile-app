class FrequencyProfile {
  int messagesPerHour;
  String preset;

  FrequencyProfile({this.messagesPerHour, this.preset});

  FrequencyProfile.fromJson(Map<String, dynamic> parsedJson)
      : messagesPerHour = 60 ~/ parsedJson['period'],
        preset = parsedJson['preset'];

  setFrequencyValue(int messagesPerHour, String preset) {
    this.messagesPerHour = messagesPerHour;
    this.preset = preset;
  }
}
