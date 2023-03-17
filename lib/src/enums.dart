import 'dart:io' show Platform;

String version = "1.0.0";

enum PNLogLevel {
  verbose,
  debug,
  info,
  warn,
  error,
  critical,
  none
}
 
enum PNSubscriberStatus {
  subscribed("SUBSCRIBED", "0"),
  dismissed("DISMISSED", "1"),
  denied("DENIED", "2"),
  notDetermined("NOT_DETERMINED", "3");

  final String androidValue;
  final String iOSValue;
  const PNSubscriberStatus(this.androidValue, this.iOSValue);

  static const String kSubscriberStatus = "subscriberStatus";

  static PNSubscriberStatus fromValue(String status) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == status;
      } else if (Platform.isIOS) {
        return element.iOSValue == status;
      }
      return false;
    }, orElse: () => PNSubscriberStatus.notDetermined);
  }
}

enum PNECommItemType {
  event("EVENT", "event"),
  product("PRODUCT", "product"),
  unknown("UNKNOWN", "unknown");

  final String androidValue;
  final String iOSValue;
  const PNECommItemType(this.androidValue, this.iOSValue);

  static PNECommItemType fromValue(String status) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == status;
      } else if (Platform.isIOS) {
        return element.iOSValue == status;
      }
      return false;
    }, orElse: () => PNECommItemType.unknown);
  }
}

enum PNAppMessagePosition {
  top("TOP", "top"),
  bottom("BOTTOM", "bottom"),
  center("CENTER", "center"),
  fullscreen("FULLSCREEN", "fullscreen");

  final String androidValue;
  final String iOSValue;
  const PNAppMessagePosition(this.androidValue, this.iOSValue);

  static PNAppMessagePosition fromValue(String position) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == position;
      } else if (Platform.isIOS) {
        return element.iOSValue == position;
      }
      return false;
    }, orElse: () => PNAppMessagePosition.top);
  }
}

enum PNSessionScope {
  lifetime("LIFETIME", "event"),
  session("SESSION", "product"),
  none("NONE", "unknown");

  final String androidValue;
  final String iOSValue;
  const PNSessionScope(this.androidValue, this.iOSValue);

  static PNSessionScope fromValue(String scope) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == scope;
      } else if (Platform.isIOS) {
        return element.iOSValue == scope;
      }
      return false;
    }, orElse: () => PNSessionScope.none);
  }
}

enum PNConditionTriggerQualifier {
  gt("GT", "gt"),
  gte("GTE", "gte"),
  lt("LT", "lt"),
  lte("LTE", "lte"),
  eq("EQ", "eq");

  final String androidValue;
  final String iOSValue;
  const PNConditionTriggerQualifier(this.androidValue, this.iOSValue);

  static PNConditionTriggerQualifier fromValue(String status) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == status;
      } else if (Platform.isIOS) {
        return element.iOSValue == status;
      }
      return false;
    }, orElse: () => PNConditionTriggerQualifier.eq);
  }
}

enum RelativeDateDisplayMetric {
  seconds("SECONDS", "0"),
  minutes("MINUTES", "1"),
  hours("HOURS", "2"),
  days("DAYS", "3");

  final String androidValue;
  final String iOSValue;
  const RelativeDateDisplayMetric(this.androidValue, this.iOSValue);

  static RelativeDateDisplayMetric fromValue(String status) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == status;
      } else if (Platform.isIOS) {
        return element.iOSValue == status;
      }
      return false;
    }, orElse: () => RelativeDateDisplayMetric.seconds);
  }
}

enum PNPermissionResponse {
  granted("GRANTED"),
  denied("DENIED"),
  dismissed("DISMISSED");

  final String value;
  const PNPermissionResponse(this.value);

  static PNPermissionResponse fromValue(String permission) {
    return values.firstWhere((element) {
        return element.value == permission;
    }, orElse:() => PNPermissionResponse.dismissed);
  } 
}

enum PNAppMessageViewType {
  pageLoadCompleted("PAGE_LOAD_COMPLETED", "pageLoadCompleted"),
  promptAccepted("PROMPT_ACCEPTED", "promptAccepted"),
  promptDismissed("PROMPT_DISMISSED", "promptDismissed"),
  unknown("UNKNOWN", "unknown");

  final String androidValue;
  final String iOSValue;
  const PNAppMessageViewType(this.androidValue, this.iOSValue);

  static PNAppMessageViewType fromValue(String type) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == type;
      } else if (Platform.isIOS) {
        return element.iOSValue == type;
      }
      return false;
    }, orElse:() => PNAppMessageViewType.unknown);
  } 
}

enum PNPrePermissionResponse {
  accepted("ACCEPTED", "0"),
  dismissed("DISMISSED", "1");

  final String androidValue;
  final String iOSValue;
  const PNPrePermissionResponse(this.androidValue, this.iOSValue);

  static PNPrePermissionResponse fromValue(String permission) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == permission;
      } else if (Platform.isIOS) {
        return element.iOSValue == permission;
      }
      return false;
    }, orElse:() => PNPrePermissionResponse.dismissed);
  } 
}

enum PNNotificationActionType {
  close("CLOSE", "0"),
  openUrl("OPEN_URL", "1");

  final String androidValue;
  final String iOSValue;
  const PNNotificationActionType(this.androidValue, this.iOSValue);

  static PNNotificationActionType fromValue(String type) {
    return values.firstWhere((element) {
       if (Platform.isAndroid) {
        return element.androidValue == type;
      } else if (Platform.isIOS) {
        return element.iOSValue == type;
      }
      return false;
    }, orElse:() => PNNotificationActionType.openUrl);
  } 
}

enum PNNotificationBadgeBehavior {
  value("SET", "SET"),
  increment("INCREMENT", "INCREMENT");

  final String androidValue;
  final String iOSValue;
  const PNNotificationBadgeBehavior(this.androidValue, this.iOSValue);

  static PNNotificationBadgeBehavior fromValue(String behaviour) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == behaviour;
      } else if (Platform.isIOS) {
        return element.iOSValue == behaviour;
      }
      return false;
    }, orElse:() => PNNotificationBadgeBehavior.value);
  } 
}

enum PNAppMessageType {
  message("MESSAGE", "message"),
  prompt("PROMPT", "prompt");

  final String androidValue;
  final String iOSValue;
  const PNAppMessageType(this.androidValue, this.iOSValue);

  static PNAppMessageType fromValue(String type) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == type;
      } else if (Platform.isIOS) {
        return element.iOSValue == type;
      }
      return false;
    }, orElse:() => PNAppMessageType.message);
  } 
}

enum PNAppMessageStyle {
  fullScreen("FULLSCREEN", "0"),
  modal("MODAL", "1"),
  banner("BANNER", "2"),
  platform("NATIVE", "3");

  final String androidValue;
  final String iOSValue;
  const PNAppMessageStyle(this.androidValue, this.iOSValue);

  static PNAppMessageStyle fromValue(String style) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == style;
      } else if (Platform.isIOS) {
        return element.iOSValue == style;
      }
      return false;
    }, orElse:() => PNAppMessageStyle.platform);
  } 
}

enum PNNotificationClickType {
  defaultAction("DEFAULT_ACTION", "DEFAULT_ACTION"),
  dismissAction("DISMISS_ACTION", "DISMISS_ACTION"),
  customAction("CUSTOM_ACTION", "CUSTOM_ACTION");

  final String androidValue;
  final String iOSValue;
  const PNNotificationClickType(this.androidValue, this.iOSValue);

  static PNNotificationClickType fromValue(String type) {
    return values.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.androidValue == type;
      } else if (Platform.isIOS) {
        return element.iOSValue == type;
      }
      return false;
    }, orElse:() => PNNotificationClickType.defaultAction);
  } 
}

