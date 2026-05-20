import 'package:equatable/equatable.dart';

/// Core user entity used in presentation and domain layers.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final AddressEntity address;
  final CompanyEntity company;

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

/// Address value object in user aggregate.
class AddressEntity extends Equatable {
  const AddressEntity({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoEntity geo;

  @override
  List<Object?> get props => <Object?>[street, suite, city, zipcode, geo];
}

/// Geo value object in user address.
class GeoEntity extends Equatable {
  const GeoEntity({required this.lat, required this.lng});

  final String lat;
  final String lng;

  @override
  List<Object?> get props => <Object?>[lat, lng];
}

/// Company value object in user aggregate.
class CompanyEntity extends Equatable {
  const CompanyEntity({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  final String name;
  final String catchPhrase;
  final String bs;

  @override
  List<Object?> get props => <Object?>[name, catchPhrase, bs];
}
