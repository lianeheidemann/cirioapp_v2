import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../map/map_provider.dart';
import '../notifications/notifications_provider.dart';

/// Solicita uma única vez as permissões usadas pelo app em tempo de execução.
///
/// Caso o usuário não conceda alguma delas, as telas de Mapa e Notificações
/// continuam oferecendo a solicitação novamente quando a função for usada.
class StartupPermissionsGate extends StatefulWidget {
  final Widget child;

  const StartupPermissionsGate({
    super.key,
    required this.child,
  });

  @override
  State<StartupPermissionsGate> createState() => _StartupPermissionsGateState();
}

class _StartupPermissionsGateState extends State<StartupPermissionsGate> {
  static const _requestedKey = 'startup_permissions_requested_v1';
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestOnFirstLaunch();
    });
  }

  Future<void> _requestOnFirstLaunch() async {
    if (_isRequesting || !mounted) return;
    _isRequesting = true;

    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(_requestedKey) == true || !mounted) return;

    final notifications = context.read<NotificationsProvider>();
    final map = context.read<MapProvider>();

    // Os diálogos do sistema são aguardados para nunca serem sobrepostos.
    await notifications.enableNotifications();
    if (!mounted) return;
    await map.locateUser(requestPermission: true);

    await preferences.setBool(_requestedKey, true);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
