import 'package:equatable/equatable.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';

/// DTO for user payload from API.
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    username: json['username'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    website: json['website'] as String? ?? '',
    address: AddressModel.fromJson(
      json['address'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    ),
    company: CompanyModel.fromJson(
      json['company'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    ),
  );

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final AddressModel address;
  final CompanyModel company;

  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    username: username,
    email: email,
    phone: phone,
    website: website,
    address: address.toEntity(),
    company: company.toEntity(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'phone': phone,
    'website': website,
    'address': address.toJson(),
    'company': company.toJson(),
  };

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    username,
    email,
    phone,
    website,
    address,
    company,
  ];
}

/// DTO for nested user address.
class AddressModel extends Equatable {
  const AddressModel({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    street: json['street'] as String? ?? '',
    suite: json['suite'] as String? ?? '',
    city: json['city'] as String? ?? '',
    zipcode: json['zipcode'] as String? ?? '',
    geo: GeoModel.fromJson(
      json['geo'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    ),
  );

  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoModel geo;

  AddressEntity toEntity() => AddressEntity(
    street: street,
    suite: suite,
    city: city,
    zipcode: zipcode,
    geo: geo.toEntity(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'street': street,
    'suite': suite,
    'city': city,
    'zipcode': zipcode,
    'geo': geo.toJson(),
  };

  @override
  List<Object?> get props => <Object?>[street, suite, city, zipcode, geo];
}

/// DTO for nested user geo coordinates.
class GeoModel extends Equatable {
  const GeoModel({required this.lat, required this.lng});

  factory GeoModel.fromJson(Map<String, dynamic> json) => GeoModel(
    lat: json['lat'] as String? ?? '',
    lng: json['lng'] as String? ?? '',
  );

  final String lat;
  final String lng;

  GeoEntity toEntity() => GeoEntity(lat: lat, lng: lng);

  Map<String, dynamic> toJson() => <String, dynamic>{'lat': lat, 'lng': lng};

  @override
  List<Object?> get props => <Object?>[lat, lng];
}

/// DTO for nested user company.
class CompanyModel extends Equatable {
  const CompanyModel({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    name: json['name'] as String? ?? '',
    catchPhrase: json['catchPhrase'] as String? ?? '',
    bs: json['bs'] as String? ?? '',
  );

  final String name;
  final String catchPhrase;
  final String bs;

  CompanyEntity toEntity() =>
      CompanyEntity(name: name, catchPhrase: catchPhrase, bs: bs);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'catchPhrase': catchPhrase,
    'bs': bs,
  };

  @override
  List<Object?> get props => <Object?>[name, catchPhrase, bs];
}
