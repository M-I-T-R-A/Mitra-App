class Khata {
  String invoiceImageUrl;
  ShopCustomer shopCustomer;
  String timeOfSell;

  Khata({this.invoiceImageUrl, this.shopCustomer, this.timeOfSell});

  Khata.fromJson(Map<String, dynamic> json) {
    invoiceImageUrl = json['invoiceImageUrl'];
    shopCustomer = json['shopCustomer'] != null
        ? new ShopCustomer.fromJson(json['shopCustomer'])
        : null;
    timeOfSell = json['timeOfSell'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceImageUrl'] = this.invoiceImageUrl;
    if (this.shopCustomer != null) {
      data['shopCustomer'] = this.shopCustomer.toJson();
    }
    data['timeOfSell'] = this.timeOfSell;
    return data;
  }
}

class ShopCustomer {
  double creditAmount;
  bool creditAmountVerified;
  int id;
  String name;
  String phoneNumber;

  ShopCustomer(
      {this.creditAmount,
      this.creditAmountVerified,
      this.id,
      this.name,
      this.phoneNumber});

  ShopCustomer.fromJson(Map<String, dynamic> json) {
    creditAmount = json['creditAmount'];
    creditAmountVerified = json['creditAmountVerified'];
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditAmount'] = this.creditAmount;
    data['creditAmountVerified'] = this.creditAmountVerified;
    data['id'] = this.id;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
