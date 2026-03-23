import 'dart:convert';
import 'dart:io';

import 'package:autocred/app/data/models/config.dart';
import 'package:autocred/app/data/models/funcoes_uteis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Telaconfiguracaoqrcode extends StatefulWidget {
  const Telaconfiguracaoqrcode({super.key});

  @override
  State<Telaconfiguracaoqrcode> createState() => _TelaconfiguracaoqrcodeState();
}

class _TelaconfiguracaoqrcodeState extends State<Telaconfiguracaoqrcode> {
  String ticket = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 42, 150, 144),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Primeiro acesso',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Card(
              color: Color.fromARGB(255, 42, 150, 144),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Seja bem vindo caro CLIENTE',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          _body(),
        ],
      ),
    );
  }

  Widget _body() {
    readBarCode() async {
      String code = await FlutterBarcodeScanner.scanBarcode(
        '#FFFFFF',
        'Cancelar',
        false,
        ScanMode.DEFAULT,
      );
      setState(() {
        if (code != '-1') {
          ticket = code;
          _salvar();
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Passo 1 ', style: FuncoesUteis().fontePadrao(true)),
          Text(
            'Usando o seu navegador favorito ',
            style: FuncoesUteis().fontePadrao(false),
          ),
          Text(
            'acesse o site seu Sistema.',
            style: FuncoesUteis().fontePadrao(false),
          ),
          Text('Passo 2 ', style: FuncoesUteis().fontePadrao(true)),
          Text(
            'Quando a tela de login aparecer, clique no botão ( CLIQUE AQUI E INSTALE NOSSO APP ).',
            style: FuncoesUteis().fontePadrao(false),
          ),
          Text('Passo 3 ', style: FuncoesUteis().fontePadrao(true)),
          Text(
            'Clique no botão abaixo e aponte a camera para ler o QrCode',
            style: FuncoesUteis().fontePadrao(false),
          ),
          Text('Passo 4 ', style: FuncoesUteis().fontePadrao(true)),
          Text(
            'Ao terminar a leiura o sistema irá desligar, inicie-o novamente',
            style: FuncoesUteis().fontePadrao(false),
          ),
          Divider(),
          Center(
            child: SizedBox(
              child: ElevatedButton.icon(
                onPressed: readBarCode,
                icon: Icon(Icons.qr_code, size: 60.0, color: Colors.white),
                label: Text(
                  'Ler QRCode',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 24, 135, 226),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    var confApp = Config(
      servidor: 'sistecinformatica2.ddns.net',
      banco: ticket,
      porta: '8082',
      usuario: 'SYSDBA',
      senha: 'masterkey',
    );

    prefs.setString('auto.json', jsonEncode(confApp.toJson()));
    _mostrarMensagens(context, "Salvo $ticket", false);
  }

  _mostrarMensagens(BuildContext context, String mensagem, bool erro) {
    // configura o button
    Widget okButton = ElevatedButton.icon(
      onPressed: () {
        exit(0);
        /*        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );*/
      },
      icon: Icon(
        Icons.check_box_outlined,
        color: (erro == true ? Colors.red : Colors.green),
        size: 40.0,
      ),
      label: Text(
        'OK',
        style: TextStyle(
          color: (erro == true ? Colors.red : Colors.green),
          fontSize: 18,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
    AlertDialog alerta = AlertDialog(
      title: Text("ATENÇÃO", style: FuncoesUteis().fontePadrao(true)),
      content: Text(
        mensagem,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [okButton],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}
