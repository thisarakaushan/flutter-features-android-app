class UserDetails {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String userCode;
  final String birthday;
  final String department;
  final String gender;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userCode,
    required this.birthday,
    required this.department,
    required this.gender,
  });

  factory UserDetails.fromFirestore(Map<String, dynamic> data, String id) {
    return UserDetails(
      id: id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      userCode: data['userCode'] ?? '',
      birthday: data['birthday'] ?? '',
      department: data['department'] ?? 'None',
      gender: data['gender'] ?? 'Male',
    );
  }
}
