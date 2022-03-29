import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    
    final currentIndex = uiProvider.selectedMenuOpt;
    //la regla para que funciona el bottomnavigation es 2 items
    return BottomNavigationBar(
      onTap: (int i) => {
        uiProvider.selectedMenuOpt = i
      },
      elevation: 0,
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration), label: 'Direcciones'),
      ],
    );
  }
}
