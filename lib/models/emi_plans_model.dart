class EmiPlansModel {
  final EmiPlansData? data;

  EmiPlansModel({
    this.data,
  });

  factory EmiPlansModel.fromJson(Map<String, dynamic> json) => EmiPlansModel(
        data: json["data"] == null ? null : EmiPlansData.fromJson(json["data"]),
      );
}

class EmiPlansData {
  final List<GetBankEmiByProductSku?>? getBankEmiByProductSku;

  EmiPlansData({
    this.getBankEmiByProductSku,
  });

  factory EmiPlansData.fromJson(List<dynamic>? jsonList) => EmiPlansData(
        getBankEmiByProductSku: (jsonList == null || jsonList.isEmpty)
            ? null
            : List<GetBankEmiByProductSku?>.from(jsonList.map(
                (x) => x == null ? null : GetBankEmiByProductSku.fromJson(x))),
      );
}

class GetBankEmiByProductSku {
  final String? id;
  final String? title;
  final List<Bank?>? bank;

  GetBankEmiByProductSku({
    this.id,
    this.title,
    this.bank,
  });

  factory GetBankEmiByProductSku.fromJson(Map<String, dynamic> json) =>
      GetBankEmiByProductSku(
        id: json["id"],
        title: json["title"],
        bank: (json["bank"] == null || json["bank"].isEmpty)
            ? null
            : List<Bank?>.from(
                json["bank"].map((x) => x == null ? null : Bank.fromJson(x))),
      );
}

class Bank {
  final String? name;
  final String? alt;
  final String? logo;
  final int? bankId;
  final List<Plan?>? plans;

  Bank({
    this.name,
    this.alt,
    this.logo,
    this.bankId,
    this.plans,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        name: json["name"],
        alt: json["alt"],
        logo: json["logo"],
        bankId: json["bank_id"],
        plans: (json["plans"] == null || json["plans"].isEmpty)
            ? null
            : List<Plan?>.from(
                json["plans"].map((x) => x == null ? null : Plan.fromJson(x))),
      );
}

class Plan {
  final String? month;
  final String? interest;
  final String? emi;
  final int? bankId;

  Plan({
    this.month,
    this.interest,
    this.emi,
    this.bankId,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        month: json["month"],
        interest: json["interest"],
        emi: json["emi"],
        bankId: json["bank_id"],
      );
}
