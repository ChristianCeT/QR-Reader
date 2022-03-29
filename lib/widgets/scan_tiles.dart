import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;
  const ScanTiles({Key? key, required this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: true);
    final scans = scanListProvider.scans;

    return ListView.builder(
      //sirve para hacer swiper con el dismissible
      itemBuilder: (_, index) => Dismissible(
        background: Container(
          color: Colors.red,
        ),
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .borrarScansId(scans[index].id!);
        },
        child: ListTile(
          leading: Icon(
            tipo == 'http' ? Icons.home_outlined : Icons.map_outlined,
            //leer el color del context con el color del main
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[index].valor),
          subtitle: Text(scans[index].id.toString()),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          onTap: () => launchURL(context, scans[index]),
        ),
      ),
      itemCount: scans.length,
    );
  }
}
