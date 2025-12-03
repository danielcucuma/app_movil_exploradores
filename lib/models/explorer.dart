class Explorer {
  int? id;
  String nombre;
  String lugar;
  int equipoId;
  String telefono;
  String fecha;

  Explorer({
    this.id,
    required this.nombre,
    required this.lugar,
    required this.equipoId,
    required this.telefono,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'lugar': lugar,
      'equipo_id': equipoId,
      'telefono': telefono,
      'fecha': fecha,
    };
  }

  factory Explorer.fromMap(Map<String, dynamic> map) {
    return Explorer(
      id: map['id'],
      nombre: map['nombre'],
      lugar: map['lugar'],
      equipoId: map['equipo_id'],
      telefono: map['telefono'],
      fecha: map['fecha'],
    );
  }
}
