import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/mapas_page.dart';
import 'package:qr_reader/providers/scan_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigator_bar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteProvider = Provider.of<ScanListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Historial'),
        actions: [
          IconButton(onPressed: () {
            //borrar todos los elementos
            deleteProvider.borrarTodos();
          }, icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: const _HomePageBody(),
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Obtener el selected menu opt
    //Se especifica el tipo de provider
    //Ya se obtiene todo los datos del provider
    final uiProvider = Provider.of<UiProvider>(context);

    //Cambiar a mostrar pagina respectiva
    final currentIndex = uiProvider.selectedMenuOpt;

    //Usar el ScanListProvider
    //No se tiene que redibujar aqui asi que se usa el listen false
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        //validacion para cargar solo geo
        scanListProvider.cargarScansTipo('geo');
        return const MapasPage();

      case 1:
        //validacion para cargar solo http
        scanListProvider.cargarScansTipo('http');
        return const DireccionesPage();

      default:
        return const MapasPage();
    }
  }
}
