import 'dart:async';

import 'package:arduino_ble_scratch/model/sensor_data.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceScanner {
  late Timer _timer;
  StreamController<SensorData> _streamController = new StreamController();
  Stream<SensorData> get sensorData => _streamController.stream;

  DeviceScanner() {
    _subscribeToScanEvents();
    _timer = new Timer.periodic(const Duration(seconds: 10), startScan);
  }

  void startScan(Timer timer) {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 2));
  }

  void dispose() {
    _timer.cancel();
    _streamController.close();
  }

  void _subscribeToScanEvents() {
    FlutterBluePlus.scanResults.listen((scanResults) {
      for (ScanResult scanResult in scanResults) {
        if (scanResult.device.platformName.toString() == "nrf52840.ru") {
          final int rssi = scanResult.rssi;
          final String name = scanResult.device.platformName;
          final String mac = scanResult.device.remoteId.toString();
          final double temp =
              scanResult.advertisementData.manufacturerData[256]![0] +
                  scanResult.advertisementData.manufacturerData[256]![1] * 0.01;
          final double humm =
              scanResult.advertisementData.manufacturerData[256]![2] +
                  scanResult.advertisementData.manufacturerData[256]![3] * 0.01;
          final double press =
              scanResult.advertisementData.manufacturerData[256]![4] +
                  scanResult.advertisementData.manufacturerData[256]![5] * 0.01;
          final SensorData sensorData = new SensorData(
              name: name,
              rssi: rssi,
              mac: mac,
              temperature: temp,
              humidity: humm,
              pressure: press);
          _streamController.add(sensorData);
          print(
              'Manufacturer data ${scanResult.advertisementData.manufacturerData}');
          FlutterBluePlus.stopScan();
        }

        print(
            '${scanResult.device.platformName} found! mac: ${scanResult.device.remoteId} rssi: ${scanResult.rssi}');
      }
    });
  }
}
