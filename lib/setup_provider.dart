import 'package:flutter/foundation.dart';

class SetupProvider with ChangeNotifier {
  bool _isSetupMode = false; // Set to false by default

  bool get isSetupMode => _isSetupMode;

  void toggleSetupMode() {
    _isSetupMode = !_isSetupMode;
    notifyListeners();
  }

  // Add a method to explicitly set setup mode to true
  void setSetupMode() {
    _isSetupMode = true;
    notifyListeners();
  }
}
