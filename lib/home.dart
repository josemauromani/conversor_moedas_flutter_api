import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    void _limpaCampos() {
      realController.text = '';
      dolarController.text = '';
      euroController.text = '';
    }

    void _realCalcula(String valor) {
      if (valor.isEmpty) {
        _limpaCampos();
        return;
      }
      double real = double.parse(valor);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
      print(real);
    }

    void _dolarCalcula(String valor) {
      if (valor.isEmpty) {
        _limpaCampos();
        return;
      }
      double dolar = double.parse(valor);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }

    void _euroCalcula(String valor) {
      if (valor.isEmpty) {
        _limpaCampos();
        return;
      }
      double euro = double.parse(valor);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversor de Moedas',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: moedaApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                'Carregando dados',
                style: TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar os dados ',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              dolar = snapshot.data['results']['currencies']['USD']['buy'];
              euro = snapshot.data['results']['currencies']['EUR']['buy'];

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      size: 100,
                      color: Colors.amber,
                    ),
                    criaCampoTexto('Real', 'R\$', realController, _realCalcula),
                    Divider(),
                    criaCampoTexto(
                        'Dólar', '\$', dolarController, _dolarCalcula),
                    Divider(),
                    criaCampoTexto('Euro', '€', euroController, _euroCalcula),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

Widget criaCampoTexto(String label, String prefix,
    TextEditingController controller, Function fcalcula) {
  return TextField(
    controller: controller,
    style: TextStyle(color: Colors.amber, fontSize: 16),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: '$prefix  ',
    ),
    onChanged: fcalcula,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}

Future<Map> moedaApi() async {
  final urlApi = 'https://api.hgbrasil.com/finance/quotations?key=97e338ee';
  http.Response response = await http.get(urlApi);
  return json.decode(response.body);
}
