import 'package:flutter/material.dart';

import 'app.dart';
import 'startup/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.run();
  runApp(const YellowFlowersApp());
}
