import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/providers/db_provider.dart';

//servicio centralizado para buscar la información de los scans
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  Future<ScanModel> nuevoScan(String valor) async {
    //crea la instancia
    final nuevoScan = ScanModel(valor: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScan);

    //Asignar el ID de la base de datos al modelo
    //Eso se hace por que el nuevoScan no produce el id
    nuevoScan.id = id;

    //validar la interfaz de usuario solo cuando el tipo coincida con http
    if (tipoSeleccionado == nuevoScan.tipo) {
      //Se inserta en la base de datos
      scans.add(nuevoScan);

      //Notificar a cualquier widget cuando el valor cambia para redibujar y actualizar
      //datos
      notifyListeners();
    }

    return nuevoScan;
  }

  cargarScans() async {
    final scans = await DBProvider.db.getAllScans();

    //recupera el scans global y reemplazalo por el scans de la bd
    this.scans = [...scans];

    //refrescar pantalla
    notifyListeners();
  }

  cargarScansTipo(String tipo) async {
    final scans = await DBProvider.db.getScansType(tipo);

    //recupera el scans global y reemplazalo por el scans de la bd
    this.scans = [...scans];
    tipoSeleccionado = tipo;

    //refrescar pantalla
    notifyListeners();
  }

  borrarTodos() async {
    await DBProvider.db.deleteAllScan();

    //recupera el scans global y lo vacia.
    scans = [];
    //refrescar pantalla
    notifyListeners();
  }

  borrarScansId(int id) async {
    await DBProvider.db.deleteScan(id);

    //método para buscar los elementos por id y compararlo con el id borrado y al final se convierte en una lista
    cargarScansTipo(tipoSeleccionado);
  }
}
