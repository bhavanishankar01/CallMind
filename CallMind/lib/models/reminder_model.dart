enum ReminderStatus {
  scheduled,
  processing,
  calling,
  completed,
  missed,
  failed,
  cancelled,
}

enum ReminderType {
  aiCall,
  notification,
}

class ReminderModel {
  final String id;
  final String userId;
  final String title;
  final String notes;
  final DateTime scheduledAt; // Stored/handled in UTC internally
  final String timezone;
  final ReminderType reminderType;
  final String repeatType; // Never, Daily, Weekly, Custom
  final String language; // English, Tamil, Telugu, Hindi
  final ReminderStatus status;
  final bool retryEnabled;
  final int retryDelayMinutes;
  final int retryCount;
  final int maxRetries;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? lastCallAt;
  final DateTime? nextCallAt;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.title,
    this.notes = '',
    required this.scheduledAt,
    required this.timezone,
    this.reminderType = ReminderType.aiCall,
    this.repeatType = 'Never',
    this.language = 'English',
    this.status = ReminderStatus.scheduled,
    this.retryEnabled = true,
    this.retryDelayMinutes = 10,
    this.retryCount = 0,
    this.maxRetries = 2,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.lastCallAt,
    this.nextCallAt,
  });

  ReminderModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? notes,
    DateTime? scheduledAt,
    String? timezone,
    ReminderType? reminderType,
    String? repeatType,
    String? language,
    ReminderStatus? status,
    bool? retryEnabled,
    int? retryDelayMinutes,
    int? retryCount,
    int? maxRetries,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? lastCallAt,
    DateTime? nextCallAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      timezone: timezone ?? this.timezone,
      reminderType: reminderType ?? this.reminderType,
      repeatType: repeatType ?? this.repeatType,
      language: language ?? this.language,
      status: status ?? this.status,
      retryEnabled: retryEnabled ?? this.retryEnabled,
      retryDelayMinutes: retryDelayMinutes ?? this.retryDelayMinutes,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      lastCallAt: lastCallAt ?? this.lastCallAt,
      nextCallAt: nextCallAt ?? this.nextCallAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'notes': notes,
      'scheduledAt': scheduledAt.toIso8601String(),
      'timezone': timezone,
      'reminderType': reminderType.name,
      'repeatType': repeatType,
      'language': language,
      'status': status.name,
      'retryEnabled': retryEnabled,
      'retryDelayMinutes': retryDelayMinutes,
      'retryCount': retryCount,
      'maxRetries': maxRetries,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'lastCallAt': lastCallAt?.toIso8601String(),
      'nextCallAt': nextCallAt?.toIso8601String(),
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      notes: map['notes'] ?? '',
      scheduledAt: DateTime.parse(map['scheduledAt']),
      timezone: map['timezone'] ?? 'UTC',
      reminderType: ReminderType.values.firstWhere(
        (e) => e.name == map['reminderType'],
        orElse: () => ReminderType.aiCall,
      ),
      repeatType: map['repeatType'] ?? 'Never',
      language: map['language'] ?? 'English',
      status: ReminderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ReminderStatus.scheduled,
      ),
      retryEnabled: map['retryEnabled'] ?? true,
      retryDelayMinutes: map['retryDelayMinutes'] ?? 10,
      retryCount: map['retryCount'] ?? 0,
      maxRetries: map['maxRetries'] ?? 2,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      lastCallAt: map['lastCallAt'] != null
          ? DateTime.parse(map['lastCallAt'])
          : null,
      nextCallAt: map['nextCallAt'] != null
          ? DateTime.parse(map['nextCallAt'])
          : null,
    );
  }
}
