// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  final TextEditingController _field1Controller = TextEditingController();
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
      // Los servicios de localización no están habilitados
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    // Solicita permiso de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // El permiso fue denegado
        return Future.error('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permisos denegados permanentemente, no se pueden solicitar
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

  void _save() {
    // Agrega tu lógica de guardado aquí
    String field1Text = _field1Controller.text;
    String field2Text = _field2Controller.text;
    String field3Text = _field3Controller.text;

    print('Campo 1: $field1Text');
    print('Latitud: $field2Text');
    print('Longitud: $field3Text');
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
                  labelText: 'Campo 1',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _field2Controller,
                readOnly: true, // Para evitar que el usuario edite este campo
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _field3Controller,
                readOnly: true, // Para evitar que el usuario edite este campo
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
