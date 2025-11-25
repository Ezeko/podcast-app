class LoginResponse {
  final String? message;
  final LoginData? data;

  LoginResponse({
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class LoginData {
  final User? user;
  final Subscription? subscription;
  final String? token;

  LoginData({
    this.user,
    this.subscription,
    this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      subscription: json['subscription'] != null 
          ? Subscription.fromJson(json['subscription']) 
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'subscription': subscription?.toJson(),
      'token': token,
    };
  }
}

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? jollyEmail;
  final String? country;
  final List<String>? personalizations;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.jollyEmail,
    this.country,
    this.personalizations,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      jollyEmail: json['jolly_email'],
      country: json['country'],
      personalizations: json['personalizations'] != null 
          ? List<String>.from(json['personalizations'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'jolly_email': jollyEmail,
      'country': country,
      'personalizations': personalizations,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}

class Subscription {
  final int? id;
  final int? userId;
  final String? userIdString;
  final String? effectiveTime;
  final String? expiryTime;
  final String? updateTime;
  final String? isOTC;
  final String? productId;
  final String? serviceId;
  final String? spId;
  final String? statusCode;
  final SubscriptionDetails? details;
  final String? createdAt;
  final String? updatedAt;

  Subscription({
    this.id,
    this.userId,
    this.userIdString,
    this.effectiveTime,
    this.expiryTime,
    this.updateTime,
    this.isOTC,
    this.productId,
    this.serviceId,
    this.spId,
    this.statusCode,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      userIdString: json['userId'],
      effectiveTime: json['effectiveTime'],
      expiryTime: json['expiryTime'],
      updateTime: json['updateTime'],
      isOTC: json['isOTC'],
      productId: json['productId'],
      serviceId: json['serviceId'],
      spId: json['spId'],
      statusCode: json['statusCode'],
      details: json['details'] != null 
          ? SubscriptionDetails.fromJson(json['details']) 
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'userId': userIdString,
      'effectiveTime': effectiveTime,
      'expiryTime': expiryTime,
      'updateTime': updateTime,
      'isOTC': isOTC,
      'productId': productId,
      'serviceId': serviceId,
      'spId': spId,
      'statusCode': statusCode,
      'details': details?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  
  bool get isActive => statusCode == 'stActive';
}

class SubscriptionDetails {
  final int? id;
  final String? code;
  final String? title;
  final int? amount;
  final String? createdAt;
  final String? updatedAt;

  SubscriptionDetails({
    this.id,
    this.code,
    this.title,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      amount: json['amount'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'amount': amount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
