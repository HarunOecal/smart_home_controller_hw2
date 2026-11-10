import 'package:flutter/material.dart';

import 'models/devices.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home Controller',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5265D8)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const SmartHomePage(),
    );
  }
}

class SmartHomePage extends StatefulWidget {
  const SmartHomePage({super.key});

  @override
  State<SmartHomePage> createState() => _SmartHomePageState();
}

class _SmartHomePageState extends State<SmartHomePage> {
  // Create device objects only once.
  // Named constructors
  final SmartLight light = SmartLight.livingRoom();
  final SmartSpeaker speaker = SmartSpeaker.kitchen();

  // Default constructor
  final Thermostat thermostat = Thermostat(
    id: 'thermostat_1',
    name: 'Bedroom Thermostat',
    temperature: 22,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Home Controller',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'My Smart Home',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Manage your connected devices',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // SMART LIGHT CARD
                deviceCard(
                  icon: Icons.lightbulb_rounded,
                  iconColor: Colors.amber.shade700,
                  name: light.name,
                  property: 'Brightness: ${light.brightness}%',
                  status: light.getStatus(),
                  isConnected: light.isConnected,
                  controls: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Power'),
                        subtitle: Text(
                          light.isOn ? 'Light is on' : 'Light is off',
                        ),
                        value: light.isOn,
                        onChanged: (value) {
                          setState(() {
                            light.toggle();
                          });
                        },
                      ),
                      Row(
                        children: [
                          const Icon(Icons.brightness_low, color: Colors.grey),
                          Expanded(
                            child: Slider(
                              value: light.brightness.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              label: '${light.brightness}%',
                              onChanged: (value) {
                                setState(() {
                                  light.brightness = value.round();
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.brightness_high, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // THERMOSTAT CARD
                deviceCard(
                  icon: Icons.thermostat_rounded,
                  iconColor: Colors.deepOrange,
                  name: thermostat.name,
                  property:
                      'Temperature: ${thermostat.temperature.toStringAsFixed(0)}°C',
                  status: thermostat.getStatus(),
                  isConnected: thermostat.isConnected,
                  controls: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {
                          setState(() {
                            thermostat.decreaseTemperature();
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        '${thermostat.temperature.toStringAsFixed(0)}°C',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filledTonal(
                        onPressed: () {
                          setState(() {
                            thermostat.increaseTemperature();
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // SMART SPEAKER CARD
                deviceCard(
                  icon: Icons.speaker_rounded,
                  iconColor: Colors.deepPurple,
                  name: speaker.name,
                  property: 'Volume: ${speaker.volume}%',
                  status: speaker.getStatus(),
                  isConnected: speaker.isConnected,
                  controls: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                speaker.togglePlayPause();
                              });
                            },
                            icon: Icon(
                              speaker.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            label: Text(speaker.isPlaying ? 'Pause' : 'Play'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.volume_down, color: Colors.grey),
                          Expanded(
                            child: Slider(
                              value: speaker.volume.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              label: '${speaker.volume}%',
                              onChanged: (value) {
                                setState(() {
                                  speaker.volume = value.round();
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.volume_up, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // STATIC DEVICE COUNTER
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.devices),
                      const SizedBox(width: 10),
                      Text(
                        'Total Devices: ${SmartDevice.totalDevices}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable device card widget
  Widget deviceCard({
    required IconData icon,
    required Color iconColor,
    required String name,
    required String property,
    required String status,
    required bool isConnected,
    required Widget controls,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                Chip(label: Text(status), visualDensity: VisualDensity.compact),
              ],
            ),
            const Divider(height: 26),
            controls,
          ],
        ),
      ),
    );
  }
}
