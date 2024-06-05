class SelectOption {
  int? id;
  final String title;
  String? imageUrl;
  dynamic value;
  bool isSelected;

  SelectOption({
    this.id,
    required this.title,
    this.imageUrl,
    this.value,
    this.isSelected = false,
  });

  SelectOption clone() {
    return SelectOption(
      id: id,
      title: title,
      imageUrl: imageUrl,
      value: value,
      isSelected: isSelected,
    );
  }
}
