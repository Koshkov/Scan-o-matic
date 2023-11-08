class SavedScan {
  final String scan;
  final int sid;

  const SavedScan({
    required this.scan,
    required this.sid,
  });

  factory SavedScan.fromMap(Map<String, dynamic> json) => SavedScan(
        scan: json['scan'],
        sid: json['sid'],
      );

  Map<String, dynamic> toMap() {
    return {
      'scan': scan,
      'sid': sid,
    };
  }
}
