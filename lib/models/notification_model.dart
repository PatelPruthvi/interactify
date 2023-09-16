class UserNotifications {
  String? action;
  String? actorId;
  String? objectUrl;
  String? notifId;

  UserNotifications(this.action, this.actorId, this.objectUrl, this.notifId);

  UserNotifications.fromJson(Map<String, dynamic> snapshot) {
    action = snapshot["action"];
    actorId = snapshot["actorId"];
    objectUrl = snapshot["objectUrl"];
    notifId = snapshot["notifId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action,
      "actorId": actorId,
      "objectUrl": objectUrl,
      "notifId": notifId
    };
  }
}
