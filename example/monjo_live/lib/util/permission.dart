import 'package:monjo_live/util/Library/OSPermission.dart';
Permission permission;

/// A Class for request Android OS permission
class AndroidOperatingSystemPermission {
  /// requestUserPermission in Android devices
  Future<void> requestAndroidUserPermission() async {
    final bool isCameraAccessed = await MonjoPermissions.checkPermission(Permission.Camera);
    final bool isReadContactsAccessed = await MonjoPermissions.checkPermission(Permission.ReadContacts);
    final bool isWriteContactsAccessed = await MonjoPermissions.checkPermission(Permission.WriteContacts);
    final bool isExternalDriveAccessed = await MonjoPermissions.checkPermission(Permission.ReadExternalStorage);
    final bool isReadSmsAccessed = await MonjoPermissions.checkPermission(Permission.ReadSms);
    final bool isWriteSmsAccessed = await MonjoPermissions.checkPermission(Permission.SendSMS);
    final bool isAandroidCoarseLocationAccessed = await MonjoPermissions.checkPermission(Permission.AccessCoarseLocation);
    final bool isAndroidFineLocationAccessed = await MonjoPermissions.checkPermission(Permission.AccessFineLocation);
    final bool isMicrophoneAccessed = await MonjoPermissions.checkPermission(Permission.RecordAudio);

    if (!isCameraAccessed) {
      await MonjoPermissions.requestPermission(Permission.Camera);
    } // else Do nothing

    if (!isReadContactsAccessed || !isWriteContactsAccessed) {
      await MonjoPermissions.requestPermission(Permission.ReadContacts);
      await MonjoPermissions.requestPermission(Permission.WriteContacts);
    } // else Do nothing

    if (!isExternalDriveAccessed) {
      await MonjoPermissions.requestPermission(Permission.ReadExternalStorage); // Probably will not work in IOS
    } // else Do nothing

    if (!isReadSmsAccessed || !isWriteSmsAccessed) {
      await MonjoPermissions.requestPermission(Permission.ReadSms);
      await MonjoPermissions.requestPermission(Permission.SendSMS);
    } // else Do nothing

    if (!isAndroidFineLocationAccessed || !isAandroidCoarseLocationAccessed) {
      /// this only works on Android devices
      await MonjoPermissions.requestPermission(Permission.AccessCoarseLocation);
      await MonjoPermissions.requestPermission(Permission.AccessFineLocation);
    } // else Do nothing

    if (!isMicrophoneAccessed) {
      await MonjoPermissions.requestPermission(Permission.RecordAudio);
    } // else Do nothing
  }
}

/// The Class for request IOS permission
class IOSOperatingSystemPermission {
  /// requestUserPermission in iOS devices
  Future<void> requestIOSUserPermission() async {
    final bool isCameraAccessed = await MonjoPermissions.checkPermission(Permission.Camera);
    final bool isReadContactsAccessed = await MonjoPermissions.checkPermission(Permission.ReadContacts);
    final bool isWriteContactsAccessed = await MonjoPermissions.checkPermission(Permission.WriteContacts);
    final bool isPhotoLibAccessed = await MonjoPermissions.checkPermission(Permission.PhotoLibrary);
    final bool isReadSmsAccessed = await MonjoPermissions.checkPermission(Permission.ReadSms);
    final bool isWriteSmsAccessed = await MonjoPermissions.checkPermission(Permission.SendSMS);
    final bool isAlwaysLocationAccessed = await MonjoPermissions.checkPermission(Permission.AlwaysLocation);
    final bool isMicrophoneAccessed = await MonjoPermissions.checkPermission(Permission.RecordAudio);

    /// Coded spereately and sort One by one as requested by Apple.inc,
    /// if using constructors, will be suspend. Any slight adjustment will be effected on
    /// Apple Security Policies, even if it is working on Android.

    if (!isCameraAccessed) {
      await MonjoPermissions.requestPermission(Permission.Camera);
    } // else Do nothing

    if (!isReadContactsAccessed || !isWriteContactsAccessed) {
      await MonjoPermissions.requestPermission(Permission.ReadContacts);
      await MonjoPermissions.requestPermission(Permission.WriteContacts);
    } // else Do nothing

    if (!isPhotoLibAccessed) {
      await MonjoPermissions.requestPermission(Permission.PhotoLibrary);
    } // else Do nothing

    if (!isReadSmsAccessed || !isWriteSmsAccessed) {
      await MonjoPermissions.requestPermission(Permission.ReadSms);
      await MonjoPermissions.requestPermission(Permission.SendSMS);
    } // else Do nothing

    if (!isAlwaysLocationAccessed) {
      /// ios_location this only works in IOS Devices
      await MonjoPermissions.requestPermission(Permission.AlwaysLocation);
    } // else Do nothing

    if (!isMicrophoneAccessed) {
      await MonjoPermissions.requestPermission(Permission.RecordAudio);
    } // else Do nothing
  }
}