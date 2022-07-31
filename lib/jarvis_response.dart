class JarvisResponse {
  final int? id, requestId;
  final String? type, data;
  JarvisResponse(this.id, this.type, this.data, this.requestId);

  JarvisResponse.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        type = json['type'],
        data = json['data'],
        requestId = json['requestId'];
}