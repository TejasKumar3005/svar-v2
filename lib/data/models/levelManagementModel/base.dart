class Image
{
    final String url;
    final String refId;


    Image({required this.url , required this.refId});
    factory Image.fromMap(Map<String , dynamic> json)
    {
        return Image(url: json["url"], refId: json["refId"]);
    }

}

class Audio
{
    final String url;
    final String refId;
    Audio({required this.url , required this.refId});
    factory Audio.fromMap(Map<String , dynamic> json){
        return Audio(url: json["url"], refId: json["refId"]);
    }
}