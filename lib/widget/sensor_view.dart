import 'dart:async';

import 'package:arduino_ble_scratch/model/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorView extends StatefulWidget {
  final SensorData sensorData;
  SensorView(this.sensorData, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SensorViewState();
  }
}

class _SensorViewState extends State<SensorView> {
  String _lastTime = "now";
  late Timer _timeUpdater;

  @override
  void initState() {
    _timeUpdater =
        new Timer.periodic(const Duration(seconds: 1), _updateLastTime);
    super.initState();
  }

  @override
  void dispose() {
    _timeUpdater.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/sens.png'),
            title: Text('Sensor avaliable : '),
            subtitle: Text(
                '${widget.sensorData.name} rssi : ${widget.sensorData.rssi}'),
            trailing: Icon(Icons.signal_cellular_4_bar),
          ),
          ListTile(
            leading: Image.asset('assets/images/temp.png'),
            title: Text(
                'Temperature : ${widget.sensorData.temperature.toStringAsFixed(2)} °C'),
          ),
          ListTile(
            leading: Image.asset('assets/images/humm.png'),
            title: Text(
                'Humidity : ${widget.sensorData.humidity.toStringAsFixed(2)} %'),
          ),
          ListTile(
            leading: Image.asset('assets/images/pres.png'),
            title: Text(
                'Pressure : ${widget.sensorData.pressure.toStringAsFixed(2)} kPa'),
          ),
          ListTile(
            leading: Icon(Icons.access_time, size: 55),
            title: Text('Last update: $_lastTime seconds ago'),
          ),
        ],
      ),
    );
  }

  void _updateLastTime(Timer timer) {
    setState(() {
      _lastTime = DateTime.now()
          .difference(widget.sensorData.lastTime)
          .inSeconds
          .toString();
    });
  }
}
