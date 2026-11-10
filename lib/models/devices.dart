abstract interface class Connectable {
  bool get isConnected;

  void connect();
  void disconnect();
}

mixin Schedulable {
  String? scheduledTime;

  void schedule(String time) {
    scheduledTime = time;
  }
}

abstract class SmartDevice {
  static int totalDevices = 0;

  final String id;
  final String name;

  SmartDevice({required this.id, required this.name}) {
    totalDevices++;
  }

  String getStatus();
}

// SMART LIGHT
class SmartLight extends SmartDevice with Schedulable implements Connectable {
  int brightness;
  bool isOn;

  @override
  bool isConnected;

  SmartLight({
    required super.id,
    required super.name,
    this.brightness = 75,
    this.isOn = true,
    this.isConnected = true,
  });

  SmartLight.livingRoom()
    : this(id: 'light_1', name: 'Living Room Light', brightness: 75);

  void toggle() {
    isOn = !isOn;
  }

  @override
  String getStatus() {
    return isOn ? 'ON' : 'OFF';
  }

  @override
  void connect() {
    isConnected = true;
  }

  @override
  void disconnect() {
    isConnected = false;
  }
}

// THERMOSTAT
class Thermostat extends SmartDevice implements Connectable {
  double temperature;

  @override
  bool isConnected;

  Thermostat({
    required super.id,
    required super.name,
    this.temperature = 22,
    this.isConnected = true,
  });

  Thermostat.bedroom()
    : this(id: 'thermostat_1', name: 'Bedroom Thermostat', temperature: 22);

  void increaseTemperature() {
    if (temperature < 30) {
      temperature++;
    }
  }

  void decreaseTemperature() {
    if (temperature > 16) {
      temperature--;
    }
  }

  @override
  String getStatus() {
    return temperature < 24 ? 'Heating' : 'Standby';
  }

  @override
  void connect() {
    isConnected = true;
  }

  @override
  void disconnect() {
    isConnected = false;
  }
}

// SMART SPEAKER
class SmartSpeaker extends SmartDevice implements Connectable {
  int volume;
  bool isPlaying;

  @override
  bool isConnected;

  SmartSpeaker({
    required super.id,
    required super.name,
    this.volume = 40,
    this.isPlaying = false,
    this.isConnected = true,
  });

  SmartSpeaker.kitchen()
    : this(id: 'speaker_1', name: 'Kitchen Speaker', volume: 40);

  void togglePlayPause() {
    isPlaying = !isPlaying;
  }

  @override
  String getStatus() {
    return isPlaying ? 'Playing' : 'Paused';
  }

  @override
  void connect() {
    isConnected = true;
  }

  @override
  void disconnect() {
    isConnected = false;
  }
}
