import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

final TextEditingController _zipController = TextEditingController();

class _MainScreenState extends State<MainScreen> {
  Future<String>? getCity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            spacing: 32,
            children: [
              SizedBox(
                height: 100,
              ),
              TextFormField(
                controller: _zipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Postleitzahl",
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  String zip = _zipController.text;

                  setState(() {
                    getCity = getCityFromZip(zip);
                  });
                },
                child: const Text("Suche"),
              ),

              getCity == null
                  ? Text('Ergebnis: Noch keine PLZ gesucht')
                  : FutureBuilder(
                      future: getCity,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            // 1. Completed (with error)
                            return Column(
                              children: [
                                Icon(Icons.error, size: 50),
                                Text(snapshot.error.toString()),
                              ],
                            );
                          } else {
                            // 2. Completed (with data)
                            final result = snapshot.data;
                            return Text("Ergebnis: $result");
                          }
                        } else {
                          // Uncompleted
                          return CircularProgressIndicator();
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _zipController.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));
    final random = DateTime.now().millisecondsSinceEpoch % 2;

    if (random == 0) {
      switch (zip) {
        case "10115":
          return 'Berlin';
        case "20095":
          return 'Hamburg';
        case "80331":
          return 'München';
        case "50667":
          return 'Köln';
        case "60311":
        case "60313":
          return 'Frankfurt am Main';
        default:
          return 'Unbekannte Stadt';
      }
    } else {
      throw Exception("Ungültige Postleitzahl!");
    }
  }
}
