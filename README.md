# Scan-o-matic 

A simple QR and Bar code scanning app. No ads, trackers, or other nonsense.

I am using this simple app as a platform to teach myself state management using provider, error handling using dartz, and clean arch.

However, in doing so, this is has become an exercise in over engineering. This app is 
so simple, it does not require clean arch, abstractions, DTOs, etc. In fact, it could be a single 
file app with a Hive database.

# Features

Allows users to scan QR and Bar codes. Users can save scans to local storage and easily copy 
them to the system clipboard.

# Dependencies 

* [Flutter Barcode Scanner](https://pub.dev/packages/flutter_barcode_scanner)
* [Hive](https://pub.dev/packages/hive)
* [URL Launcher](https://pub.dev/packages/url_launcher)
* [Flutter Slidable](https://pub.dev/packages/flutter_slidable)
* [Provider](https://pub.dev/packages/provider)