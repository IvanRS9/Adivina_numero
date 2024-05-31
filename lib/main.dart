import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el numero',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adivina el numero entre 1 & 100'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numeroAleatorio = Random().nextInt(100) + 1;
  int intentos = 10;
  int numeroMin = 1;
  int numeroMax = 100;
  String mensaje = "Buena suerte";

  void _onSubmited(String value) {
    setState(() {
      int newNumber = int.tryParse(value) ?? 0;

      if (newNumber < numeroMin || newNumber > numeroMax) {
        return;
      }

      intentos--;

      mensaje = "Intentos restantes: " + intentos.toString();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
        backgroundColor: _setColor(),
      ));

      if (newNumber == numeroAleatorio) {
        _showDialog(
            "Ganaste, adivinaste el numero", Colors.green, "Volver a jugar");
      } else {
        if (newNumber > numeroAleatorio) {
          numeroMax = newNumber;
        } else {
          numeroMin = newNumber;
        }
      }

      if (intentos == 0 && newNumber != numeroAleatorio) {
        _showDialog("Perdiste, suerte para la proxima", Colors.red, "Cerrar");
      }
    });
  }

  Color _setColor() {
    if (intentos >= 6) {
      return Colors.green;
    } else if (intentos >= 3 && intentos <= 5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  void _resetGame() {
    setState(() {
      numeroAleatorio = Random().nextInt(100) + 1;
      intentos = 10;
      numeroMin = 1;
      numeroMax = 100;
      mensaje = "Intentos restantes: $intentos";
    });
  }

  void _showDialog(String texto, Color color, String action) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 300),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    texto,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: color),
                  )
                ],
              ),
            ),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            actions: [
              TextButton(
                child: Text(action),
                onPressed: () {
                  _resetGame();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: TextStyle(color: _setColor(), fontSize: 20),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Ingresa un numero entre $numeroMin & $numeroMax",
                  labelText: "Adivina el numero",
                  helperText: "$numeroMin",
                  counterText: "$numeroMax",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (value) => {
                  _onSubmited(value),
                  
                },
              ),
              TextButton(
                child: const Text(
                  "Reiniciar Juego",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  _resetGame();
                },
                style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromRGBO(75, 104, 169, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
