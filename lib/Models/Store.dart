class Store {
  double area;
  double electricityAmount;
  String electricityBillImageUrl;
  String gstin;
  String ownership;
  String phoneNumber;
  double rating;
  ShopAddress shopAddress;
  String shopName;
  List<ShopRelatedDocs> shopRelatedDocs;
  String type;
  WareHouse wareHouse;

  Store(
      {this.area,
      this.electricityAmount,
      this.electricityBillImageUrl,
      this.gstin,
      this.ownership,
      this.phoneNumber,
      this.rating,
      this.shopAddress,
      this.shopName,
      this.shopRelatedDocs,
      this.type,
      this.wareHouse});

  Store.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    electricityAmount = json['electricityAmount'];
    electricityBillImageUrl = json['electricityBillImageUrl'];
    gstin = json['gstin'];
    ownership = json['ownership'];
    phoneNumber = json['phoneNumber'];
    rating = json['rating'];
    shopAddress = json['shopAddress'] != null
        ? new ShopAddress.fromJson(json['shopAddress'])
        : null;
    shopName = json['shopName'];
    if (json['shopRelatedDocs'] != null) {
      shopRelatedDocs = new List<ShopRelatedDocs>();
      json['shopRelatedDocs'].forEach((v) {
        shopRelatedDocs.add(new ShopRelatedDocs.fromJson(v));
      });
    }
    type = json['type'];
    wareHouse = json['wareHouse'] != null
        ? new WareHouse.fromJson(json['wareHouse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['electricityAmount'] = this.electricityAmount;
    data['electricityBillImageUrl'] = this.electricityBillImageUrl;
    data['gstin'] = this.gstin;
    data['ownership'] = this.ownership;
    data['phoneNumber'] = this.phoneNumber;
    data['rating'] = this.rating;
    if (this.shopAddress != null) {
      data['shopAddress'] = this.shopAddress.toJson();
    }
    data['shopName'] = this.shopName;
    if (this.shopRelatedDocs != null) {
      data['shopRelatedDocs'] =
          this.shopRelatedDocs.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    if (this.wareHouse != null) {
      data['wareHouse'] = this.wareHouse.toJson();
    }
    return data;
  }
}

class ShopAddress {
  String city;
  String firstLine;
  double latitude;
  double longitude;
  int pincode;
  String secondLine;
  String state;

  ShopAddress(
      {this.city,
      this.firstLine,
      this.latitude,
      this.longitude,
      this.pincode,
      this.secondLine,
      this.state});

  ShopAddress.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    firstLine = json['firstLine'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pincode = json['pincode'];
    secondLine = json['secondLine'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['firstLine'] = this.firstLine;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pincode'] = this.pincode;
    data['secondLine'] = this.secondLine;
    data['state'] = this.state;
    return data;
  }
}

class ShopRelatedDocs {
  String name;
  String url;

  ShopRelatedDocs({this.name, this.url});

  ShopRelatedDocs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class WareHouse {
  List<int> areaOfWareHouses;
  int numberOfWareHouses;

  WareHouse({this.areaOfWareHouses, this.numberOfWareHouses});

  WareHouse.fromJson(Map<String, dynamic> json) {
    areaOfWareHouses = json['areaOfWareHouses'].cast<int>();
    numberOfWareHouses = json['numberOfWareHouses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['areaOfWareHouses'] = this.areaOfWareHouses;
    data['numberOfWareHouses'] = this.numberOfWareHouses;
    return data;
  }
}
