class ApiResponse {
  ApiResponse({
    this.statusCode,
    this.errorCode,
    this.errorField,
    this.message,
    this.data,
    this.params,
  });

  ApiResponse.fromJson(Map<String, dynamic> json)
    : statusCode =
          json['status'] == 'SUCCESSFUL' ? 0 : json['statusCode'] as int?,
      errorCode = json['errorCode'] ?? json['code'] as String?,
      errorField = json['errorField'] as String?,
      message = json['message'] as String?,
      params =
          json['params'] == null ? null : List<String>.from(json['params']),
      data = json['data'];
  int? statusCode;
  String? errorCode;
  String? errorField;
  String? message;
  dynamic data;
  final List<String>? params;
}
