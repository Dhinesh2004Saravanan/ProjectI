class searchInfo {
  Geometry? geometry;
  String? type;
  Properties? properties;

  searchInfo({this.geometry, this.type, this.properties});



  // Named constructors
  searchInfo.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    type = json['type'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['type'] = this.type;
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    data['type'] = this.type;
    return data;
  }
}

class Properties {
  String? osmType;
  int? osmId;
  String? country;
  String? osmKey;
  String? city;
  String? countrycode;
  String? osmValue;
  String? postcode;
  String? name;
  String? county;
  String? state;
  String? type;

  Properties(
      {this.osmType,
        this.osmId,
        this.country,
        this.osmKey,
        this.city,
        this.countrycode,
        this.osmValue,
        this.postcode,
        this.name,
        this.county,
        this.state,
        this.type});

  Properties.fromJson(Map<String, dynamic> json) {
    osmType = json['osm_type'];
    osmId = json['osm_id'];
    country = json['country'];
    osmKey = json['osm_key'];
    city = json['city'];
    countrycode = json['countrycode'];
    osmValue = json['osm_value'];
    postcode = json['postcode'];
    name = json['name'];
    county = json['county'];
    state = json['state'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['osm_type'] = this.osmType;
    data['osm_id'] = this.osmId;
    data['country'] = this.country;
    data['osm_key'] = this.osmKey;
    data['city'] = this.city;
    data['countrycode'] = this.countrycode;
    data['osm_value'] = this.osmValue;
    data['postcode'] = this.postcode;
    data['name'] = this.name;
    data['county'] = this.county;
    data['state'] = this.state;
    data['type'] = this.type;
    return data;
  }
}
