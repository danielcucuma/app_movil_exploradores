class MagnetometerLog {
  int? id;
  double x;
  double y;
  double z;
  String timestamp;

  MagnetometerLog({
    this.id,
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'x': x,
      'y': y,
      'z': z,
      'timestamp': timestamp,
    };
  }

  factory MagnetometerLog.fromMap(Map<String, dynamic> map) {
    return MagnetometerLog(
      id: map['id'],
      x: map['x'],
      y: map['y'],
      z: map['z'],
      timestamp: map['timestamp'],
    );
  }
}

class BarometerLog {
  int? id;
  double presion;
  String timestamp;

  BarometerLog({
    this.id,
    required this.presion,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'presion': presion,
      'timestamp': timestamp,
    };
  }

  factory BarometerLog.fromMap(Map<String, dynamic> map) {
    return BarometerLog(
      id: map['id'],
      presion: map['presion'],
      timestamp: map['timestamp'],
    );
  }
}
