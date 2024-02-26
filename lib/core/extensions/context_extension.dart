import 'package:cursach_app/core/common/app/providers/user_provider.dart';
import 'package:cursach_app/src/auth/domain/entities/local_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  ThemeData get theme => Theme.of(this);
}
