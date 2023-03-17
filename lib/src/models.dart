import 'dart:ffi';
import 'dart:io';

import 'package:pushly_pushsdk/pushsdk.dart';
import 'package:pushly_pushsdk/src/json.dart';
import 'package:pushly_pushsdk/src/errors.dart';
import 'dart:developer' as dt;

class PNApplicationConfig {
  String? originVersion;
  late int appId;
  late String name;
  late String appKey;
  late List<String> flags;
  PNAppFrequencyCaps? frequencyCaps;
  PNEcommConfig? ecommConfig;
  List<PNNotificationChannel>? channels;
  int? authorizationOptions;

  PNApplicationConfig(Map<String, dynamic> values) {
    try {
      originVersion = values['originVersion'];
      appId = values['appId'];
      name = values['name'];
      appKey = values['appKey'];
      flags = values['flags'].cast<String>();
      frequencyCaps = values['frequencyCaps'] != null ? PNAppFrequencyCaps(values['frequencyCaps'].cast<String, dynamic>()) : null;
      ecommConfig = values['ecommConfig'] != null ? PNEcommConfig(values['ecommConfig'].cast<String, dynamic>()) : null;
      // ignore: prefer_null_aware_operators
      channels =  values['channels'] != null ? values['channels'].cast<Map>().map((value) => PNNotificationChannel(value.cast<String, dynamic>())).toList().cast<PNNotificationChannel>() : null; 
      authorizationOptions = values['authorizationOptions'];
    } catch (e) {
      dt.log("Error processing PNApplicationConfig ${e.toString()}");
    }
  }
}

class PNEcommConfig {

  late PNECommItemType itemType;
  
  PNEcommConfig(Map<String, dynamic> input) {
    try {
      itemType = PNECommItemType.fromValue(input['itemType']);
    } catch (e) {
      dt.log("Error processing PNEcommConfig ${e.toString()}");
    }
  } 
}

class PNNotificationChannel {

    late String identifier;
    late String name;
    late int importance;
    String? description;
    String? groupId;
    String? sound;
    PNNotificationChannelLightConfig? lights;
    PNNotificationChannelVibrationConfig? vibration;
    bool? showBadge;
    int? lockScreenVisibility;
    late bool isDefault;

  PNNotificationChannel(Map<String, dynamic> input) {
    try {
      identifier = input['identifier'];
      name = input['name'];
      importance = input['importance'];
      description = input['description'];
      groupId = input['groupId'];
      sound = input['sound'];
      lights = input['lights'] != null ? PNNotificationChannelLightConfig(input['lights'].cast<String, dynamic>()) : null;
      vibration = input['vibration'] != null ? PNNotificationChannelVibrationConfig(input['vibration'].cast<String, dynamic>()) : null;
      showBadge = input['showBadge'];
      lockScreenVisibility = input['lockScreenVisibility'];
      isDefault = input['isDefault'];
    } catch (e) {
      dt.log("Error processing PNNotificationChannel ${e.toString()}");
    }
  }
}

class PNNotificationChannelLightConfig {

    int? color;
    late bool enabled;

  PNNotificationChannelLightConfig(Map<String, dynamic> input) {
    try {
      color = input['color'];
      enabled = input['enabled'];
    } catch (e) {
      dt.log("Error processing PNNotificationChannelLightConfig ${e.toString()}");
    }
  } 
}

class PNNotificationChannelVibrationConfig {

    List<Long>? pattern;
    late bool enabled;

  PNNotificationChannelVibrationConfig(Map<String, dynamic> input) {
    try {
      pattern = input['pattern'];
      enabled = input['enabled'];
    } catch (e) {
      dt.log("Error processing PNNotificationChannelVibrationConfig ${e.toString()}");
    }
  } 
}

class PNAppFrequencyCaps {

  FrequencyCapWithOccurrenceLimit? prompts;

  PNAppFrequencyCaps(Map<String, dynamic> input) {
    try {
      prompts = input['prompts'] != null ? FrequencyCapWithOccurrenceLimit(input['prompts'].cast<String, dynamic>()) : null;
    } catch (e) {
      dt.log("Error processing FrequencyCapWithOccurrenceLimit ${e.toString()}");
    }
  } 
}

class FrequencyCapWithOccurrenceLimit {
  
  late int occurrences;
  late double intervalSeconds;
  late RelativeDateDisplayMetric displayMetric;

  // TODO: test mappings with some config
  FrequencyCapWithOccurrenceLimit(Map<String, dynamic> input) {
    try {
      occurrences = input["occurrences"];
      intervalSeconds = input["intervalSeconds"];
      displayMetric = RelativeDateDisplayMetric.fromValue(input["displayMetric"]);
    } catch (e) {
      dt.log("Error processing FrequencyCapWithOccurrenceLimit ${e.toString()}");
    }
  }
}

class PNNotification {
  late int id;
  late String piid;
  late String landingURL;
  String? imageURL;
  String? contentWebhookURL;
  String? title;
  String? body;
  PNBadgeConfig? badgeConfig;
  late List<PNNotificationAction> actions;

  static PNNotification create(Map<String, dynamic> input) {
    if (Platform.isAndroid) {
      return PNAndroidNotification(input);
    } else if (Platform.isIOS) {
      return PNiOSNotification(input);
    } 
    throw NotSupportedException();
  }

  PNNotification(Map<String, dynamic> input) {
    try {
      id = input['id'];
      piid = input['piid'];
      landingURL = input['landingURL'];
      imageURL = input['imageURL'];
      contentWebhookURL = input['contentWebhookURL'];
      title = input['title'];
      body = input['body'];
      badgeConfig = input['badgeConfig'] != null ? PNBadgeConfig(input['badgeConfig'].cast<String, dynamic>()) : null;
      actions = input['actions'].cast<Map>().map((value) => PNNotificationAction(value.cast<String, dynamic>())).toList().cast<PNNotificationAction>();
    } catch (e) {
      dt.log("Error processing PNNotification ${e.toString()}");
    }
  }
}

class PNiOSNotification extends PNNotification {
 
  String? titleLocKey;
  List<String>? titleLocArgs;
  String? subtitle;
  String? subtitleLocKey;
  List<String>? subtitleLocArgs;
  String? locKey;
  List<String>? locArgs;
  String? launchImage;
  String? category;
  int? badge;
  String? sound;
  String? threadId;
  late bool contentAvailable;
  late bool mutableContent;
  String? targetContentId;
  String? interruptionLevel;
  int? relevanceScore;
  String? filterCriteria;
  
  PNiOSNotification(Map<String, dynamic> input) : super(input) {
    try {
      titleLocKey = input['titleLocKey'];
      titleLocArgs = input['titleLocArgs'];
      subtitle = input['subtitle'];
      subtitleLocKey = input['subtitleLocKey'];
      subtitleLocArgs = input['subtitleLocArgs'];
      locKey = input['locKey'];
      locArgs = input['locArgs'];
      launchImage = input['launchImage'];
      category = input['category'];
      badge = input['badge'];
      sound = input['sound'];
      threadId = input['threadId'];
      contentAvailable = input['contentAvailable'];
      mutableContent = input['mutableContent'];
      targetContentId = input['targetContentId'];
      interruptionLevel = input['interruptionLevel'];
      relevanceScore = input['relevanceScore'];
      filterCriteria = input['filterCriteria'];
    } catch (e) {
      dt.log("Error processing PNiOSNotification ${e.toString()}");
    }
  }
}

class PNAndroidNotification extends PNNotification {
  String? iconURL;
  late int ttl;
  late int priority;
  late int collapseKey;
  late String channelId;
  late String groupId;
  late bool isSilent;
  
  PNAndroidNotification(Map<String, dynamic> input) : super(input) {
    try {
      iconURL = input['iconURL'];
      ttl = input['ttl'];
      priority = input['priority'];
      collapseKey = input['collapseKey'];
      channelId = input['channelId'];
      groupId = input['groupId'];
      isSilent = input['isSilent'];
    } catch (e) {
      dt.log("Error processing PNAndroidNotification ${e.toString()}");
    }
  }
}

class PNNotificationInteraction {
  String? actionIdentifier;
  PNNotificationClickType? type;
  PNNotification? notification;
  PNNotificationAction? action;

  PNNotificationInteraction(Map<String, dynamic> input) {
    try {
      type = PNNotificationClickType.fromValue(input['type']);
      actionIdentifier = input['actionIdentifier'];
      notification = PNNotification.create(input['notification'].cast<String, dynamic>()); 
      action = input['action'] != null ? PNNotificationAction(input['action']) : null;
    } catch (e) {
      dt.log("Error processing PNNotificationInteraction ${e.toString()}");
    }
  }
}

class PNNotificationAction {
  late int action;
  late int ordinal;
  late String title;
  late PNNotificationActionType type;
  String? landingURL;
  Map<String, PNNotificationActionVariation>? variations;

  PNNotificationAction(Map<String, dynamic> input) {
    try {
      action = input['action'];
      ordinal = input['ordinal'];
      title = input['title'];
      type = PNNotificationActionType.fromValue(input['type']);
      landingURL = input['landingURL'];
      variations = input['variations']?.isNotEmpty == true ? input['variations'].map((key, value) => MapEntry(key, PNNotificationActionVariation(value.cast<String, dynamic>()))) : null;
    } catch (e) {
      dt.log("Error processing PNNotificationAction ${e.toString()}");
    }
  }
}

class PNNotificationActionVariation {

  late String title;

  PNNotificationActionVariation(Map<String, dynamic> input) {
    try {
      title = input['title'];
    } catch (e) {
      dt.log("Error processing PNNotificationActionVariation ${e.toString()}");
    }
  }
}

class PNBadgeConfig {

  late int count;
  late PNNotificationBadgeBehavior behaviour;

  PNBadgeConfig(Map<String, dynamic> input) {
    try {
      count = input['count'];
      behaviour = PNNotificationBadgeBehavior.fromValue(input['behavior']);
    } catch (e) {
      dt.log("Error processing PNBadgeConfig ${e.toString()}");
    }
  }
}

class PNECommItem extends JsonObject {
  final String _id;
  final int _quantity;

  PNECommItem(String id, int quantity) : _id = id, _quantity = quantity;
  
  @override
  String toJson() {
    return convert({
      "id": _id,
      "quantity": _quantity
    });
  }
}

class UserProfile {
  late String anonymousId;
  String? externalId;
  late bool isDeleted;
  late bool isEligibleToPrompt;
  late bool isSubscribed;
  late PNSubscriberStatus subscriberStatus;
  String? token;

  UserProfile(Map<String, dynamic> input) {
    try {
      anonymousId = input['anonymousId'];
      externalId = input['externalId'];
      isDeleted = input['isDeleted'];
      isEligibleToPrompt = input['isEligibleToPrompt'];
      isSubscribed = input['isSubscribed'];
      subscriberStatus = PNSubscriberStatus.fromValue(input['subscriberStatus']);
      token = input['token'];
    } catch (e) {
      dt.log("Error processing UserProfile ${e.toString()}");
    }
  }
}