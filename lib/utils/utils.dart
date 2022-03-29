import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(BuildContext context, ScanModel scan) async {
  if (scan.tipo == 'http') {
    if (!await launch(scan.valor)) throw 'Could not launch ${scan.valor}';
  } else {
    //mandar información mediante los arguments
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
