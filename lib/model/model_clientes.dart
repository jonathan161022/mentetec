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
}
