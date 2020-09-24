import 'dart:developer';

import 'package:flutter/foundation.dart';

class PrintHelper {
  bool debug = false;
  int interger = 0;
  String dlevel = 'Debug-Level [John Melody Me]: ';
  String ilevel = 'INFO-Level [John Melody Me]: ';

  lprint(String string, bool debugMode) {
    if (debugMode == debug) {
      debugPrint('$ilevel $string', wrapWidth: 2048);
    } else {
      debugPrint('$dlevel,($debugMode) **  $string  ', wrapWidth: 2048);
    }
  }

  rprint(String string, int value) {
    if (value == interger) {
      log('$string');
    } else if (value == 1) {
      log('[RAW_OUTPUT]: \n $string \n  ex: $value');
    } else {
      return null;
    }
  }

  warning(String string, int value) {
    if (value == 0) {
      print('$string');
    } else if (value == 1) {
      print('[警告] WARNING:  $string');
    } else {
      return null;
    }
  }
}
