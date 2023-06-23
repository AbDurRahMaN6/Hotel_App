enum Roles { roleAdmin, roleUser, roleManager }

extension RolesString on Roles {
  String? get names {
    switch (this) {
      case Roles.roleAdmin:
        return "ROLE_ADMIN";
      case Roles.roleManager:
        return "ROLE_MANAGER";
      case Roles.roleUser:
        return "ROLE_USER";
      default:
    }
    return null;
  }
}
