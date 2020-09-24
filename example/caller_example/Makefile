run_all: 
	- flutter pub get
	- flutter run -d all

clean:
	- rm -r build
	- rm -r ios/Podfile
	- flutter pub get -v 

run_ios:
	- cd ios
	- pod install -v 
	- pod update -v
	- open Runner.xcworkspace

run_android:
	- flutter pub get
	- flutter run -d ZHHYGAROE6UOW8MZ

compile:
	- flutter pub get
	- open ios/Runner.xcworkspace
	- flutter run -d ZHHYGAROE6UOW8MZ