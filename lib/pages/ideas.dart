class Idea {
  final String id;
  final String image;
  final String title;
  final String description;
  final String type;

  static Map<String, List<List<String>>> allideas = {};

  Idea({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.type,
  }) {
    if (allideas.containsKey(id)) {
      allideas[id]?.add([
        image,
        title,
        description,
        type,
      ]);
    } else {
      allideas[id] = [
        [image, title, description, type]
      ];
    }
  }
}
