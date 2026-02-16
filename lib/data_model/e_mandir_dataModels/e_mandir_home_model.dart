class EMandirHomeDataModel {
  Wallet? wallet;
  StreakInfo? streakInfo;

  EMandirHomeDataModel({this.wallet, this.streakInfo});

  EMandirHomeDataModel.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    streakInfo = json['streakInfo'] != null
        ? StreakInfo.fromJson(json['streakInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (streakInfo != null) {
      data['streakInfo'] = streakInfo!.toJson();
    }
    return data;
  }
}

class Wallet {
  FirstTimeBonus? firstTimeBonus;
  String? sId;
  String? userId;
  String? userObjectId;
  int? coins;
  int? totalCoinsEarned;
  int? totalCoinsSpent;
  int? streak;
  String? lastStreakCheckIn;
  int? totalCheckIns;
  String? lastCheckInAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Wallet({
    this.firstTimeBonus,
    this.sId,
    this.userId,
    this.userObjectId,
    this.coins,
    this.totalCoinsEarned,
    this.totalCoinsSpent,
    this.streak,
    this.lastStreakCheckIn,
    this.totalCheckIns,
    this.lastCheckInAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Wallet.fromJson(Map<String, dynamic> json) {
    firstTimeBonus = json['firstTimeBonus'] != null
        ? FirstTimeBonus.fromJson(json['firstTimeBonus'])
        : null;
    sId = json['_id'];
    userId = json['userId'];
    userObjectId = json['userObjectId'];
    coins = json['coins'];
    totalCoinsEarned = json['totalCoinsEarned'];
    totalCoinsSpent = json['totalCoinsSpent'];
    streak = json['streak'];
    lastStreakCheckIn = json['lastStreakCheckIn'];
    totalCheckIns = json['totalCheckIns'];
    lastCheckInAt = json['lastCheckInAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstTimeBonus != null) {
      data['firstTimeBonus'] = firstTimeBonus!.toJson();
    }
    data['_id'] = sId;
    data['userId'] = userId;
    data['userObjectId'] = userObjectId;
    data['coins'] = coins;
    data['totalCoinsEarned'] = totalCoinsEarned;
    data['totalCoinsSpent'] = totalCoinsSpent;
    data['streak'] = streak;
    data['lastStreakCheckIn'] = lastStreakCheckIn;
    data['totalCheckIns'] = totalCheckIns;
    data['lastCheckInAt'] = lastCheckInAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class FirstTimeBonus {
  bool? received;
  String? receivedAt;
  int? amount;

  FirstTimeBonus({this.received, this.receivedAt, this.amount});

  FirstTimeBonus.fromJson(Map<String, dynamic> json) {
    received = json['received'];
    receivedAt = json['receivedAt'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['received'] = received;
    data['receivedAt'] = receivedAt;
    data['amount'] = amount;
    return data;
  }
}

class StreakInfo {
  int? currentStreak;
  int? coins;
  int? totalCoinsEarned;
  String? lastCheckInDate;
  int? daysSinceLastLogin;
  int? totalCheckIns;
  FirstTimeBonus? firstTimeBonus;

  StreakInfo({
    this.currentStreak,
    this.coins,
    this.totalCoinsEarned,
    this.lastCheckInDate,
    this.daysSinceLastLogin,
    this.totalCheckIns,
    this.firstTimeBonus,
  });

  StreakInfo.fromJson(Map<String, dynamic> json) {
    currentStreak = json['currentStreak'];
    coins = json['coins'];
    totalCoinsEarned = json['totalCoinsEarned'];
    lastCheckInDate = json['lastCheckInDate'];
    daysSinceLastLogin = json['daysSinceLastLogin'];
    totalCheckIns = json['totalCheckIns'];
    firstTimeBonus = json['firstTimeBonus'] != null
        ? FirstTimeBonus.fromJson(json['firstTimeBonus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentStreak'] = currentStreak;
    data['coins'] = coins;
    data['totalCoinsEarned'] = totalCoinsEarned;
    data['lastCheckInDate'] = lastCheckInDate;
    data['daysSinceLastLogin'] = daysSinceLastLogin;
    data['totalCheckIns'] = totalCheckIns;
    if (firstTimeBonus != null) {
      data['firstTimeBonus'] = firstTimeBonus!.toJson();
    }
    return data;
  }
}
