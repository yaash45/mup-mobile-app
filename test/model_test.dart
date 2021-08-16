import 'package:test/test.dart';
import 'package:mup_app/models/SensorProfile.dart';
import 'package:mup_app/models/FrequencyProfile.dart';

void main() {
  group('Data model tests', () {
    test('Frequency Profile population from Firestore Json', () {
      final inputJsonProfile = {
        'messagesPerHour': 10,
        'preset': 'low',
        'deviceName': 'test'
      };

      final profile = FrequencyProfile.fromJson(inputJsonProfile);

      expect(profile.deviceName, 'test');
      expect(profile.preset, 'low');
      expect(profile.messagesPerHour, 10);
    });

    test('Sensor Profile population from Firestore Json', () {
      final inputJsonProfile = {
        'temperature': true,
        'humidity': false,
        'pressure': true,
        'co2Equivalent': false,
        'breathVoc': true,
        'iaq': true,
      };

      final profile = SensorProfile.fromJson(inputJsonProfile);

      expect(profile.temperature.sensorOn, true);
      expect(profile.humidity.sensorOn, false);
      expect(profile.pressure.sensorOn, true);
      expect(profile.co2Equivalent.sensorOn, false);
      expect(profile.breathVoc.sensorOn, true);
      expect(profile.iaq.sensorOn, true);
    });
  });
}
