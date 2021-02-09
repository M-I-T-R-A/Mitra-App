class Customer {
  String aadhar;
  String aadharCardBackImageUrl;
  String aadharCardFrontImageUrl;
  double annualIncome;
  int cibilScore;
  double electricityBill;
  String electricityBillImageUrl;
  String gender;
  int id;
  String name;
  String pan;
  String panCardImageUrl;
  String phoneNumber;
  ResidenceAddress residenceAddress;
  int status;
  bool verified;

  Customer(
      {this.aadhar,
      this.aadharCardBackImageUrl,
      this.aadharCardFrontImageUrl,
      this.annualIncome,
      this.cibilScore,
      this.electricityBill,
      this.electricityBillImageUrl,
      this.gender,
      this.id,
      this.name,
      this.pan,
      this.panCardImageUrl,
      this.phoneNumber,
      this.residenceAddress,
      this.status,
      this.verified});

  Customer.fromJson(Map<String, dynamic> json) {
    aadhar = json['aadhar'];
    aadharCardBackImageUrl = json['aadharCardBackImageUrl'];
    aadharCardFrontImageUrl = json['aadharCardFrontImageUrl'];
    annualIncome = json['annualIncome'];
    cibilScore = json['cibilScore'];
    electricityBill = json['electricityBill'];
    electricityBillImageUrl = json['electricityBillImageUrl'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    panCardImageUrl = json['panCardImageUrl'];
    phoneNumber = json['phoneNumber'];
    residenceAddress = json['residenceAddress'] != null
        ? new ResidenceAddress.fromJson(json['residenceAddress'])
        : null;
    status = json['status'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aadhar'] = this.aadhar;
    data['aadharCardBackImageUrl'] = this.aadharCardBackImageUrl;
    data['aadharCardFrontImageUrl'] = this.aadharCardFrontImageUrl;
    data['annualIncome'] = this.annualIncome;
    data['cibilScore'] = this.cibilScore;
    data['electricityBill'] = this.electricityBill;
    data['electricityBillImageUrl'] = this.electricityBillImageUrl;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['name'] = this.name;
    data['pan'] = this.pan;
    data['panCardImageUrl'] = this.panCardImageUrl;
    data['phoneNumber'] = this.phoneNumber;
    if (this.residenceAddress != null) {
      data['residenceAddress'] = this.residenceAddress.toJson();
    }
    data['status'] = this.status;
    data['verified'] = this.verified;
    return data;
  }
}

class ResidenceAddress {
  String city;
  String firstLine;
  double latitude;
  double longitude;
  int pincode;
  String secondLine;
  String state;

  ResidenceAddress(
      {this.city,
      this.firstLine,
      this.latitude,
      this.longitude,
      this.pincode,
      this.secondLine,
      this.state});

  ResidenceAddress.fromJson(Map<String, dynamic> json) {
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
    data['pincode'] = this.pincode ?? 452010;
    data['secondLine'] = this.secondLine;
    data['state'] = this.state;
    return data;
  }

  @override
    String toString() {
      return this.firstLine + ', ' + this.secondLine + ', ' + this.city + ', ' + this.state + ' - ' + this.pincode.toString();
    }
}