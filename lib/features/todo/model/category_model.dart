class CategoryModel {
  final int id;
  final String name;
  final String color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
});

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
        id: json['id'] as int,
        name: json['name'] as String,
        color: json['color'] as String ?? '#proc33'
    );
  }

  Map<String, dynamic>toJson(){
    return{
      'id': id,
      'name': name,
      'color': color,
    };
  }
}