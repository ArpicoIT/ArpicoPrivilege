class AlertModel {
  final String id;
  final String icon;
  final String title;
  final String description;
  final AlertAction? primaryAction;
  final AlertAction? secondaryAction;

  AlertModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    this.primaryAction,
    this.secondaryAction,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    final actions = json['actions'] ?? {};
    return AlertModel(
      id: json['id'],
      icon: json['icon'],
      title: json['title'],
      description: json['description'],
      primaryAction: actions['primary'] != null ? AlertAction.fromJson(actions['primary']) : null,
      secondaryAction: actions['secondary'] != null ? AlertAction.fromJson(actions['secondary']) : null,
    );
  }
}

class AlertAction {
  final String label;
  final String icon;
  final String action;

  AlertAction({required this.label, required this.icon, required this.action});

  factory AlertAction.fromJson(Map<String, dynamic> json) {
    return AlertAction(
      label: json['label'],
      icon: json['icon'],
      action: json['action'],
    );
  }
}
