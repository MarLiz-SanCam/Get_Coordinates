// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers for the text fields
  final TextEditingController _field1Controller =
      TextEditingController(); // Aula
  final TextEditingController _field2Controller =
      TextEditingController(); // Latitud
  final TextEditingController _field3Controller =
      TextEditingController(); // Longitud

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de localización están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    // Solicita permiso de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están denegados permanentemente.');
    }

    // Obtiene la posición actual
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    // Asigna las coordenadas a los campos de texto
    setState(() {
      _field2Controller.text = position.latitude.toString();
      _field3Controller.text = position.longitude.toString();
    });
  }

  Future<void> _save() async {
    // Conexión a la base de datos MySQL
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '', // Cambiar
      port: 3306,
      user: '', // Cambia esto
      password: '', //Cambiar
      db: 'location_db',
    ));

    // Inserta los datos en la base de datos
    try {
      await conn.query(
        'INSERT INTO aulas (aula, latitud, longitud) VALUES (?, ?, ?)',
        [
          _field1Controller.text,
          double.parse(_field2Controller.text),
          double.parse(_field3Controller.text)
        ],
      );
      print('Datos guardados exitosamente');
    } catch (e) {
      print('Error al guardar los datos: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _field1Controller,
                decoration: const InputDecoration(
                  labelText: 'Aula',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _field2Controller,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _field3Controller,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
