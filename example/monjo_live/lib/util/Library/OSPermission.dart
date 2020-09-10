import 'dart:async';
import 'package:flutter/services.dart';

/// Wrapper class for deciding OS permissions
class MonjoPermissions {
  /// channel to native code
  static const MethodChannel _channel = MethodChannel('monjo_permissions');

  /// Function to retrieve platform version
  static Future<String> get platformVersion async {
    final String platform = await _channel.invokeMethod('getPlatformVersion');
    return platform;
  }

  /// Check a permission async
  static Future<bool> checkPermission(Permission permission) async {
    final bool isGranted = await _channel.invokeMethod('checkPermission', {'permission': getPermissionString(permission)}); // ignore: always_specify_types
    return isGranted;
  }

  /// Request a permission async
  static Future<PermissionStatus> requestPermission(
      Permission permission) async {
    final status = await _channel.invokeMethod('requestPermission', {'permission': getPermissionString(permission)}); // ignore: always_specify_types

    return status is int ? intToPermissionStatus(status) : status is bool
            ? (status ? PermissionStatus.authorized : PermissionStatus.denied) : PermissionStatus.notDetermined;
  }

  /// Open app settings on Android and iOs
  static Future<bool> openSettings() async {
    final bool isOpen = await _channel.invokeMethod('openSettings');
    return isOpen;
  }

  /// Function to retrieve the current status of a permission
  static Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    final int status = await _channel.invokeMethod('getPermissionStatus', {'permission': getPermissionString(permission)}); // ignore: always_specify_types
    return intToPermissionStatus(status);
  }

  /// Function to convert integer to Enumeration
  static PermissionStatus intToPermissionStatus(int status) {
    switch (status) {
      case 0:
        return PermissionStatus.notDetermined;
      case 1:
        return PermissionStatus.restricted;
      case 2:
        return PermissionStatus.denied;
      case 3:
        return PermissionStatus.authorized;
      case 4:
        return PermissionStatus.deniedNeverAsk;
      default:
        return PermissionStatus.notDetermined;
    }
  }
}

/// Enum of all available Permission
enum Permission {
  /// Permission to record audio
  RecordAudio,            // ignore: constant_identifier_names
  /// Permission to call
  CallPhone,              // ignore: constant_identifier_names
  /// Permission to use the camer
  Camera,                 // ignore: constant_identifier_names
  /// Permission to access photos
  PhotoLibrary,           // ignore: constant_identifier_names
  /// Permission to write to external storage
  WriteExternalStorage,   // ignore: constant_identifier_names
  /// Permission to read from external storage
  ReadExternalStorage,    // ignore: constant_identifier_names
  /// Permission to get the phone status
  ReadPhoneState,         // ignore: constant_identifier_names
  /// Permission to access coarse location (GPS?)
  AccessCoarseLocation,   // ignore: constant_identifier_names
  /// Permission to access fine location (GPS?)
  AccessFineLocation,     // ignore: constant_identifier_names
  /// Permission to access geolocation only when app is use (GPS?)
  WhenInUseLocation,      // ignore: constant_identifier_names
  /// Permission to access geolocation always (GPS?)
  AlwaysLocation,         // ignore: constant_identifier_names
  /// Permission to read the phone contacts
  ReadContacts,           // ignore: constant_identifier_names
  /// Permission to read SMS
  ReadSms,                // ignore: constant_identifier_names
  /// Permission to send SMS
  SendSMS,                // ignore: constant_identifier_names
  /// Permission to vibrate the phone
  Vibrate,                // ignore: constant_identifier_names
  /// Permission to write contact
  WriteContacts,          // ignore: constant_identifier_names
  /// Permission to access motion sensor
  AccessMotionSensor      // ignore: constant_identifier_names
}

/// Permissions status enum (iOs: notDetermined, restricted, denied, authorized, deniedNeverAsk)
/// (Android: denied, authorized, deniedNeverAsk)
enum PermissionStatus {
  /// Status: not determined
  notDetermined,
  /// Status: restricted
  restricted,
  /// Status: denied
  denied,
  /// Status: authorized
  authorized,
  /// Status: denied, but never asked
  deniedNeverAsk /* android */
}

/// Function returns the String associated to a permission
String getPermissionString(Permission permission) {
  String res;
  switch (permission) {
    case Permission.CallPhone:
      res = 'CALL_PHONE';
      break;
    case Permission.Camera:
      res = 'CAMERA';
      break;
    case Permission.PhotoLibrary:
      res = 'PHOTO_LIBRARY';
      break;
    case Permission.RecordAudio:
      res = 'RECORD_AUDIO';
      break;
    case Permission.WriteExternalStorage:
      res = 'WRITE_EXTERNAL_STORAGE';
      break;
    case Permission.ReadExternalStorage:
      res = 'READ_EXTERNAL_STORAGE';
      break;
    case Permission.ReadPhoneState:
      res = 'READ_PHONE_STATE';
      break;
    case Permission.AccessFineLocation:
      res = 'ACCESS_FINE_LOCATION';
      break;
    case Permission.AccessCoarseLocation:
      res = 'ACCESS_COARSE_LOCATION';
      break;
    case Permission.WhenInUseLocation:
      res = 'WHEN_IN_USE_LOCATION';
      break;
    case Permission.AlwaysLocation:
      res = 'ALWAYS_LOCATION';
      break;
    case Permission.ReadContacts:
      res = 'READ_CONTACTS';
      break;
    case Permission.SendSMS:
      res = 'SEND_SMS';
      break;
    case Permission.ReadSms:
      res = 'READ_SMS';
      break;
    case Permission.Vibrate:
      res = 'VIBRATE';
      break;
    case Permission.WriteContacts:
      res = 'WRITE_CONTACTS';
      break;
    case Permission.AccessMotionSensor:
      res = 'MOTION_SENSOR';
      break;
  }
  return res;
}