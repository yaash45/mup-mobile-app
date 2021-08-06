class FrequencyProfile {
  int messagesPerHour;
  String preset;
  String deviceName;

  FrequencyProfile({this.messagesPerHour, this.preset});

  FrequencyProfile.fromJson(Map<String, dynamic> parsedJson)
      : messagesPerHour = parsedJson['messagesPerHour'],
        preset = parsedJson['preset'],
        deviceName = parsedJson['deviceName'];

  setFrequencyValue(int messagesPerHour, String preset) {
    this.messagesPerHour = messagesPerHour;
    this.preset = preset;
  }
}
