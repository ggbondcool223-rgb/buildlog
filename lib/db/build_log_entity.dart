class BuildLogEntity {
  int? id;
  String unit;
  String projectName;
  String projectSupervisor;
  String supervisor;
  int? weather;
  String? photoPath;
  String? notes;
  String date;
  int createTime;

  BuildLogEntity({
    this.id,
    required this.unit,
    required this.projectName,
    required this.projectSupervisor,
    required this.supervisor,
    this.weather,
    this.photoPath,
    this.notes,
    required this.date,
    required this.createTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unit': unit,
      'project_name': projectName,
      'project_supervisor': projectSupervisor,
      'supervisor': supervisor,
      'weather': weather,
      'photo_path': photoPath,
      'notes': notes,
      'date': date,
      'create_time': createTime,
    };
  }

  factory BuildLogEntity.fromMap(Map<String, dynamic> map) {
    return BuildLogEntity(
      id: map['id'] as int?,
      unit: map['unit'] as String,
      projectName: map['project_name'] as String,
      projectSupervisor: map['project_supervisor'] as String,
      supervisor: map['supervisor'] as String,
      weather: map['weather'] as int?,
      photoPath: map['photo_path'] as String?,
      notes: map['notes'] as String?,
      date: map['date'] as String,
      createTime: map['create_time'] as int,
    );
  }

  @override
  String toString() {
    return 'BuildLogEntity{id: $id, unit: $unit, projectName: $projectName, date: $date}';
  }
}
