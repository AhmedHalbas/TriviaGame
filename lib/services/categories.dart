class Categories {
  final String categoryName;
  final int categoryID;

  Categories({
    this.categoryName,
    this.categoryID,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      categoryName: json['name'],
      categoryID: json['id'],
    );
  }
}
