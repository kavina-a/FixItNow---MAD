class CustomerModel {

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String city;

  CustomerModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.city,

  });

  factory CustomerModel.fromJson(Map<String, dynamic> profileJson) {
    return CustomerModel(
      firstName: profileJson['first_name'],
      lastName: profileJson['last_name'],
      phoneNumber: profileJson['phone_number'],
      address: profileJson['address'],
      city: profileJson['city'],

    );
  }
}
