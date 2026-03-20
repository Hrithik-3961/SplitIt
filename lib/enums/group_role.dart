enum GroupRole {
  admin,
  member;

  factory GroupRole.from(String value) {
    switch (value) {
      case 'admin':
        return GroupRole.admin;
      case 'member':
        return GroupRole.member;
      default:
        throw Exception('Invalid group role: $value');
    }
  }
}