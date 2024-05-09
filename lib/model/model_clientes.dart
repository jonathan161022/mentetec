class Persona {
  int id;
  String nombre;
  String apellido;
  String dni;
  String tipoDocumento;
  String direccion;
  String telefono;
  String correoElectronico;
  String genero;
  String estadoCivil;
  String fechaNacimiento;
  String unidadNegocio;
  String pais;
  String codigoPais;
  String? imagen;

  Persona({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.tipoDocumento,
    required this.direccion,
    required this.telefono,
    required this.correoElectronico,
    required this.genero,
    required this.estadoCivil,
    required this.fechaNacimiento,
    required this.unidadNegocio,
    required this.pais,
    required this.codigoPais,
    this.imagen,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      dni: json['dni'],
      tipoDocumento: json['tipo_documento'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correoElectronico: json['correo_electronico'],
      estadoCivil: json['estado_civil'],
      genero: json['genero'],
      fechaNacimiento: json['fecha_nacimiento'],
      pais: json['pais'],
      codigoPais: json['codigo_pais'],
      unidadNegocio: json['unidadNegocio'],
    );
  }
}
