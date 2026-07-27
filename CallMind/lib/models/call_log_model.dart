class CallLogModel {
  final String id;
  final String reminderId;
  final String userId;
  final String provider; // mock, twilio, exotel
  final String providerCallId;
  final String phoneCalled;
  final DateTime startedAt;
  final DateTime? answeredAt;
  final DateTime? endedAt;
  final String status; // initiated, answered, no_answer, failed
  final String? errorMessage;

  CallLogModel({
    required this.id,
    required this.reminderId,
    required this.userId,
    required this.provider,
    required this.providerCallId,
    required this.phoneCalled,
    required this.startedAt,
    this.answeredAt,
    this.endedAt,
    required this.status,
    this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reminderId': reminderId,
      'userId': userId,
      'provider': provider,
      'providerCallId': providerCallId,
      'phoneCalled': phoneCalled,
      'startedAt': startedAt.toIso8601String(),
      'answeredAt': answeredAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'status': status,
      'errorMessage': errorMessage,
    };
  }

  factory CallLogModel.fromMap(Map<String, dynamic> map) {
    return CallLogModel(
      id: map['id'] ?? '',
      reminderId: map['reminderId'] ?? '',
      userId: map['userId'] ?? '',
      provider: map['provider'] ?? 'mock',
      providerCallId: map['providerCallId'] ?? '',
      phoneCalled: map['phoneCalled'] ?? '',
      startedAt: DateTime.parse(map['startedAt']),
      answeredAt: map['answeredAt'] != null
          ? DateTime.parse(map['answeredAt'])
          : null,
      endedAt: map['endedAt'] != null
          ? DateTime.parse(map['endedAt'])
          : null,
      status: map['status'] ?? 'initiated',
      errorMessage: map['errorMessage'],
    );
  }
}
