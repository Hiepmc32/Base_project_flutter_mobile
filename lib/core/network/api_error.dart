import 'api_response.dart';

class ApiError {
  const ApiError({this.errorCode, this.message, this.extraData, this.params});

  ApiError.fromResponse(ApiResponse response)
    : errorCode = response.errorCode,
      message = response.message,
      extraData = response.data,
      params = response.params;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'errorCode': errorCode,
    'message': message,
    'extraData': extraData,
    'params': params,
  };

  final String? errorCode;
  final String? message;
  final dynamic extraData;
  final List<String>? params;
}
