import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';

class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(AuthCubit authCubit) {
    _subscription = authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
