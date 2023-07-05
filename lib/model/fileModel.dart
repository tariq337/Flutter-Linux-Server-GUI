class FileModel {
  String name;
  String type;
  String size;
  int groupID;
  int userID;
  String location;
  String? linklocation;

  FileModel(
      {required this.name,
      required this.type,
      required this.size,
      required this.groupID,
      required this.userID,
      required this.location,
      this.linklocation});
}
