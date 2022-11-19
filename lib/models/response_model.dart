// To parse this JSON data, do
//
//     final responseModel = responseModelFromMap(jsonString);

import 'dart:convert';

class ResponseModel {
    ResponseModel({
        required this.data,
        required this.total,
    });

    List<dynamic> data;
    int total;

    factory ResponseModel.fromJson(String str) => ResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ResponseModel.fromMap(Map<String, dynamic> json) => ResponseModel(
        data: List<dynamic>.from(json["data"].map((x) => x)),
        total: json["total"],
    );

    Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x)),
        "total": total,
    };
}
