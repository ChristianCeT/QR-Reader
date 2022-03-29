//sirve para mandar un archivo de dart en una version anterior.
/* // @dart=2.9. */
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;

  //constructor privado
  static final DBProvider db = DBProvider._();

  //Constructor privado
  //Cuando haga un new provider siempre voy a tener la misma instancia
  DBProvider._();

  //verifica si está la base de datos o ya existe, si no ejecuta el initdb
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Path de donde se almacenará la base de datos
    //Solo se guarda cuando instalas la app, si desinstalas se pierde
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //Creando el path
    final path = join(documentsDirectory.path, 'ScansDB.db');

    print(path);

    //Crear base de datos
    //Se recomiendo incrementar la version de la base de datos cuando se hacen cambios
    //para ver la base de datos se entra en el finder de mac y apretas comand + shift + g
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      //Es un string multilinea
      await db.execute('''
      CREATE TABLE Scans(
       id INTEGER PRIMARY KEY,
       tipo TEXT,
       valor TEXT) 
      ''');
    });
  }

  //nuevo metodo
  //inserción de la base de datos
  //manera larga
  Future<int?> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //se espera que la bd esté lista se tiene que ejecutar el getter
    //verificar la bd
    final db = await database;

    final res = await db.rawInsert('''
    INSERT INTO Scans(id, tipo, valor)
    VALUES($id, '$tipo', '$valor') 
    ''');

    return res;
  }

  //insercion de datos manera corta
  Future<int?> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    //se pone tojson por que da un mapa de valores lo que pide el insert
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //obtener datos scans por id
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    //el signo de interrogacion se traduce a los argumentos del whereargs
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //obtener todos los datos de la tabla scan como una lista
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    //el signo de interrogacion se traduce a los argumentos del whereargs
    final res = await db.query('Scans');

    return res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
  }

  //obtener todos scans por tipo
  Future<List<ScanModel>> getScansType(String tipo) async {
    final db = await database;
    //el signo de interrogacion se traduce a los argumentos del whereargs
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
   ''');

    return res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
  }

//actualizar un scan por un id
  Future<int> updateScan(ScanModel updateScan) async {
    final db = await database;
    //recordar poner la condicional para actualizar solo 1 registro
    final res = await db.update('Scans', updateScan.toJson(),
        where: 'id = ?', whereArgs: [updateScan.id]);

    return res;
  }

  //borrar un scan por un id
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  //borrar todos los scan
  Future<int> deleteAllScan() async {
    final db = await database;
    final res = await db.rawDelete('''DELETE FROM Scans''');
    return res;
  }
}
