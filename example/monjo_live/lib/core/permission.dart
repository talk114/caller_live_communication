import 'package:simple_permissions/simple_permissions.dart'as CorePermissions;
import 'package:simple_permissions/simple_permissions.dart';

Permission permission;

/// A Class for request Android OS permission
class AndroidOperatingSystemPermission {
  /// requestUserPermission in Android devices
  Future<void> requestAndroidUserPermission() async {
    final bool isCameraAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.Camera);
    final bool isReadContactsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.ReadContacts);
    final bool isWriteContactsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.WriteContacts);
    final bool isExternalDriveAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.ReadExternalStorage);
    final bool isReadSmsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.ReadSms);
    final bool isWriteSmsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.SendSMS);
    final bool isAandroidCoarseLocationAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.AccessCoarseLocation);
    final bool isAndroidFineLocationAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.AccessFineLocation);
    final bool isMicrophoneAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.RecordAudio);

    if (!isCameraAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.Camera);
    } // else Do nothing

    if (!isReadContactsAccessed || !isWriteContactsAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.ReadContacts);
      await CorePermissions.SimplePermissions.requestPermission(Permission.WriteContacts);
    } // else Do nothing

    if (!isExternalDriveAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.ReadExternalStorage); // Probably will not work in IOS
    } // else Do nothing

    if (!isReadSmsAccessed || !isWriteSmsAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.ReadSms);
      await CorePermissions.SimplePermissions.requestPermission(Permission.SendSMS);
    } // else Do nothing

    if (!isAndroidFineLocationAccessed || !isAandroidCoarseLocationAccessed) {
      /// this only works on Android devices
      await CorePermissions.SimplePermissions.requestPermission(Permission.AccessCoarseLocation);
      await CorePermissions.SimplePermissions.requestPermission(Permission.AccessFineLocation);
    } // else Do nothing

    if (!isMicrophoneAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.RecordAudio);
    } // else Do nothing
  }
}

/// The Class for request IOS permission
class IOSOperatingSystemPermission {
  /// requestUserPermission in iOS devices
  Future<void> requestIOSUserPermission() async {
    final bool isCameraAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.Camera);
    final bool isReadContactsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.ReadContacts);
    final bool isWriteContactsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.WriteContacts);
    final bool isPhotoLibAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.PhotoLibrary);
    final bool isReadSmsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.ReadSms);
    final bool isWriteSmsAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.SendSMS);
    final bool isAlwaysLocationAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.AlwaysLocation);
    final bool isMicrophoneAccessed = await CorePermissions.SimplePermissions.checkPermission(Permission.RecordAudio);

    /// Coded spereately and sort One by one as requested by Apple.inc,
    /// if using constructors, will be suspend. Any slight adjustment will be effected on
    /// Apple Security Policies, even if it is working on Android.

    if (!isCameraAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.Camera);
    } // else Do nothing

    if (!isReadContactsAccessed || !isWriteContactsAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.ReadContacts);
      await CorePermissions.SimplePermissions.requestPermission(Permission.WriteContacts);
    } // else Do nothing

    if (!isPhotoLibAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.PhotoLibrary);
    } // else Do nothing

    if (!isReadSmsAccessed || !isWriteSmsAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.ReadSms);
      await CorePermissions.SimplePermissions.requestPermission(Permission.SendSMS);
    } // else Do nothing

    if (!isAlwaysLocationAccessed) {
      /// ios_location this only works in IOS Devices
      await CorePermissions.SimplePermissions.requestPermission(Permission.AlwaysLocation);
    } // else Do nothing

    if (!isMicrophoneAccessed) {
      await CorePermissions.SimplePermissions.requestPermission(Permission.RecordAudio);
    } // else Do nothing
  }
}
