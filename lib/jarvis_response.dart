class JarvisResponse {
  final int? id, requestId;
  final String? origin, data;
  JarvisResponse(this.id, this.origin, this.data, this.requestId);

  JarvisResponse.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        origin = json['origin'],
        data = json['data'],
        requestId = json['requestId'];
}