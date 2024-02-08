import 'package:flutter/material.dart';

import '../../main.dart';

class SearchProvider extends ChangeNotifier {
  String? loc;
  TextEditingController tController=TextEditingController();
  void clear(){
    tController.clear();
    notifyListeners();
  }
  Future<void> fetchDataFromPrefs() async {
    String? storedLoc = prefs.getString('City');
    if (storedLoc != null) {
      loc = storedLoc;
      print(loc);
      notifyListeners(); // Notify listeners about the change
    } else {
      loc = "Rajkot";
      notifyListeners();
    }
  }
}
