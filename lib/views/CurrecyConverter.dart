import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ConversionPage());

class ConversionPage extends StatefulWidget {
  const ConversionPage({Key? key}) : super(key: key);

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Currency Converter'),
          ),
          body: Column(
            children: [
              const SizedBox(height: 10),
              Flexible(flex: 3, child: Image.asset('assets/images/1.jpg')),
              const Flexible(
                flex: 5,
                child: ConversionForm(),
              )
            ],
          )),
    );
  }
}

class ConversionForm extends StatefulWidget {
  const ConversionForm({Key? key}) : super(key: key);

  @override
  _ConversionFormState createState() => _ConversionFormState();
}

class _ConversionFormState extends State<ConversionForm> {
  TextEditingController inputEditingController = TextEditingController();
  TextEditingController outputEditingController = TextEditingController();
  double input = 0.0, output = 0.0, inputCurr = 0.0, outputCurr = 0.0;
  String desc = "";

  String selectCur1 = "EUR", selectCur2 = "USD";
  List<String> curList = [
    "GBP",
    "EUR",
    "USD",
  ];

  _convert() async {
    var apiId = "7f57b190-39fa-11ec-88a6-b597b9073ac8";
    var url =
        Uri.parse('https://freecurrencyapi.net/api/v2/latest?apikey=$apiId');
    var response = await http.get(url);
    var index = response.statusCode;

    setState(() {
      if (index == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);

        if (selectCur1 == "USD") {
          inputCurr = 1.0;
        } else {
          inputCurr = parsedJson['data'][selectCur1];
        }

        if (selectCur2 == "USD") {
          outputCurr = 1.0;
        } else {
          outputCurr = parsedJson['data'][selectCur2];
        }

        desc = "";
      } else {
        desc = "No data";
      }

      if (inputEditingController.text != "") {
        input = double.parse(inputEditingController.text);
        output = (input / inputCurr) * outputCurr;
        outputEditingController.text = output.toString();
      } else {
        outputEditingController.text = "";
        input = 0.0;
        output = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: inputEditingController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(),
                    onChanged: (newValue) {
                      _convert();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    itemHeight: 60,
                    value: selectCur1,
                    onChanged: (newValue) {
                      selectCur1 = newValue.toString();
                      _convert();
                    },
                    items: curList.map((selectCur1) {
                      return DropdownMenuItem(
                        child: Text(
                          selectCur1,
                        ),
                        value: selectCur1,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: outputEditingController,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    itemHeight: 60,
                    value: selectCur2,
                    items: curList.map((selectCur2) {
                      return DropdownMenuItem(
                        child: Text(
                          selectCur2,
                        ),
                        value: selectCur2,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectCur2 = newValue.toString();
                      _convert();
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Text(
                input.toString() +
                    " " +
                    selectCur1 +
                    " = " +
                    output.toString() +
                    " " +
                    selectCur2,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(desc),
          ],
        ),
      ),
    );
  }
}
