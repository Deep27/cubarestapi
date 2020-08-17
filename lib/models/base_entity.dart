abstract class BaseEntity {
  BaseEntity({this.entityName, this.instanceName, this.id, this.version = 1});

  BaseEntity.fromMap(Map<String, dynamic> map) {
    entityName = map['_entityName'];
    instanceName = map['_instanceName'];
    id = map['id'];
    version = map['version'];
  }

  static const dateFormat = 'yyyy-MM-dd';
  static const timeFormat = 'HH:mm:ss';
  static const dateTimeFormat = 'yyyy-MM-dd HH:mm:ss.SSS';

  String entityName;
  String instanceName;
  String id;
  int version;

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['_entityName'] = entityName;
    map['_instanceName'] = instanceName;
    map['id'] = id;
    if (version != null) {
      map['version'] = version;
    }
    return map;
  }
}
