class JarvisRequest {
  final int? id;
  final String? request;
  JarvisRequest(this.id, this.request);

  JarvisRequest.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        request = json['request'];
}