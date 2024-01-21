class SensorData {
  final String name;
  final int rssi;
  final String mac;
  final double temperature;
  final double humidity;
  final double pressure;
  final DateTime lastTime;

  SensorData(
      {required this.name,
      required this.rssi,
      required this.mac,
      required this.temperature,
      required this.humidity,
      required this.pressure,
      DateTime? lastTime})
      : this.lastTime = lastTime ?? DateTime.now();
}
