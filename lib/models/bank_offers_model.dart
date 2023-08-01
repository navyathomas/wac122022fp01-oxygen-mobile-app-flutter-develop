class BankOffersModel {
  BankOffersModel({
    this.data,
  });

  BankOffersData? data;

  factory BankOffersModel.fromJson(Map<String, dynamic> json) =>
      BankOffersModel(
        data:
            json["data"] != null ? BankOffersData.fromJson(json["data"]) : null,
      );
}

class BankOffersData {
  BankOffersData({
    this.getBankOffersByProductSku,
  });

  List<GetBankOffersByProductSku?>? getBankOffersByProductSku;

  factory BankOffersData.fromJson(Map<String, dynamic> json) => BankOffersData(
        getBankOffersByProductSku: json["getBankOffersByProductSku"] == null
            ? null
            : List<GetBankOffersByProductSku?>.from(
                json["getBankOffersByProductSku"].map((x) =>
                    x != null ? GetBankOffersByProductSku.fromJson(x) : null)),
      );
}

class GetBankOffersByProductSku {
  GetBankOffersByProductSku({
    this.bankOfferDetail,
    this.id,
    this.title,
  });

  List<BankOfferDetail?>? bankOfferDetail;
  String? id;
  String? title;

  factory GetBankOffersByProductSku.fromJson(Map<String, dynamic> json) =>
      GetBankOffersByProductSku(
        bankOfferDetail: json["bank_offer_detail"] == null
            ? null
            : List<BankOfferDetail?>.from(json["bank_offer_detail"]
                .map((x) => x != null ? BankOfferDetail.fromJson(x) : null)),
        id: json["id"],
        title: json["title"],
      );
}

class BankOfferDetail {
  BankOfferDetail({
    this.description,
    this.identifier,
    this.linkLabel,
    this.title,
  });

  String? description;
  String? identifier;
  String? linkLabel;
  String? title;

  factory BankOfferDetail.fromJson(Map<String, dynamic> json) =>
      BankOfferDetail(
        description: json["description"],
        identifier: json["identifier"],
        linkLabel: json["link_label"],
        title: json["title"],
      );
}
