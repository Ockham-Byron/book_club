class GroupModel {
  String? id;
  String? name;
  String? leader;
  List<String>? members;

  String? currentBookId;
  int? indexPickingBook;

  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.currentBookId,
    this.indexPickingBook,
  });
}
