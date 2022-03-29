import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  //getters y setters trabaja con providers
  int _selectedMenuOpt = 0;

  //getter
  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  //setter
  //cambia el valor del getter
  //no es un metodo es un setter y al igualar al provider se pone = valor.
  set selectedMenuOpt(int i) {
    _selectedMenuOpt = i;
    //notifica a todas las personas o widgets que escuchan el cambio
    notifyListeners();
  }
}
