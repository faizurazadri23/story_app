
import 'package:json_annotation/json_annotation.dart';

part 'response_register.g.dart';

@JsonSerializable()
class ResponseRegister {
  final bool error;
  final String message;

  ResponseRegister({required this.error, required this.message});

  factory ResponseRegister.fromJson(Map<String, dynamic> json) => _$ResponseRegisterFromJson(json);

}
