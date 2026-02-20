class Nakshatra {
  final int id;
  final String name;
  final String deity;
  final String rulingPlanet;
  final String symbol;
  final String nature;
  final List<String> characteristics;

  Nakshatra({
    required this.id,
    required this.name,
    required this.deity,
    required this.rulingPlanet,
    required this.symbol,
    required this.nature,
    required this.characteristics,
  });

  factory Nakshatra.fromJson(Map<String, dynamic> json) {
    return Nakshatra(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      deity: json['deity'] ?? '',
      rulingPlanet: json['rulingPlanet'] ?? '',
      symbol: json['symbol'] ?? '',
      nature: json['nature'] ?? '',
      characteristics: List<String>.from(json['characteristics'] ?? []),
    );
  }
}

class NavtaraAnalysis {
  final String readingId;
  final String janmaNakshatra;
  final String analysisType;
  final Map<String, List<String>> navtaraChakra;
  final NavtaraTransits currentTransits;
  final NavtaraPrediction prediction;
  final NavtaraNext30Days next30Days;
  final NavtaraRemedies remedies;
  final Map<String, dynamic>? aiMetadata;

  NavtaraAnalysis({
    required this.readingId,
    required this.janmaNakshatra,
    required this.analysisType,
    required this.navtaraChakra,
    required this.currentTransits,
    required this.prediction,
    required this.next30Days,
    required this.remedies,
    this.aiMetadata,
  });

  factory NavtaraAnalysis.fromJson(Map<String, dynamic> json) {
    return NavtaraAnalysis(
      readingId: json['readingId'] ?? '',
      janmaNakshatra: json['janmaNakshatra'] ?? '',
      analysisType: json['analysisType'] ?? '',
      navtaraChakra:
          (json['navtaraChakra'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v)),
          ) ??
          {},
      currentTransits: NavtaraTransits.fromJson(json['currentTransits'] ?? {}),
      prediction: NavtaraPrediction.fromJson(json['prediction'] ?? {}),
      next30Days: NavtaraNext30Days.fromJson(json['next30Days'] ?? {}),
      remedies: NavtaraRemedies.fromJson(json['remedies'] ?? {}),
      aiMetadata: json['aiMetadata'],
    );
  }
}

class NavtaraTransits {
  final String analysisDate;
  final List<PlanetaryPosition> planetaryPositions;
  final String overallFavorability;
  final int favorabilityScore;

  NavtaraTransits({
    required this.analysisDate,
    required this.planetaryPositions,
    required this.overallFavorability,
    required this.favorabilityScore,
  });

  factory NavtaraTransits.fromJson(Map<String, dynamic> json) {
    return NavtaraTransits(
      analysisDate: json['analysisDate'] ?? '',
      planetaryPositions:
          (json['planetaryPositions'] as List?)
              ?.map((e) => PlanetaryPosition.fromJson(e))
              .toList() ??
          [],
      overallFavorability: json['overallFavorability'] ?? '',
      favorabilityScore: json['favorabilityScore'] ?? 0,
    );
  }
}

class PlanetaryPosition {
  final String planet;
  final String? nakshatra;
  final String? navtaraCategory;
  final String effect;
  final String interpretation;

  PlanetaryPosition({
    required this.planet,
    this.nakshatra,
    this.navtaraCategory,
    required this.effect,
    required this.interpretation,
  });

  factory PlanetaryPosition.fromJson(Map<String, dynamic> json) {
    return PlanetaryPosition(
      planet: json['planet'] ?? '',
      nakshatra: json['nakshatra'],
      navtaraCategory: json['navtaraCategory'],
      effect: json['effect'] ?? '',
      interpretation: json['interpretation'] ?? '',
    );
  }
}

class NavtaraPrediction {
  final String summary;
  final String detailedAnalysis;
  final List<String> strengthAreas;
  final List<String> challengeAreas;
  final String timingAdvice;

  NavtaraPrediction({
    required this.summary,
    required this.detailedAnalysis,
    required this.strengthAreas,
    required this.challengeAreas,
    required this.timingAdvice,
  });

  factory NavtaraPrediction.fromJson(Map<String, dynamic> json) {
    return NavtaraPrediction(
      summary: json['summary'] ?? '',
      detailedAnalysis: json['detailedAnalysis'] ?? '',
      strengthAreas: List<String>.from(json['strengthAreas'] ?? []),
      challengeAreas: List<String>.from(json['challengeAreas'] ?? []),
      timingAdvice: json['timingAdvice'] ?? '',
    );
  }
}

class NavtaraNext30Days {
  final List<String> favorableDates;
  final List<String> unfavorableDates;
  final List<String> moderateDates;

  NavtaraNext30Days({
    required this.favorableDates,
    required this.unfavorableDates,
    required this.moderateDates,
  });

  factory NavtaraNext30Days.fromJson(Map<String, dynamic> json) {
    return NavtaraNext30Days(
      favorableDates: List<String>.from(json['favorableDates'] ?? []),
      unfavorableDates: List<String>.from(json['unfavorableDates'] ?? []),
      moderateDates: List<String>.from(json['moderateDates'] ?? []),
    );
  }
}

class NavtaraRemedies {
  final List<String> mantras;
  final List<String> charities;
  final List<String> gemstones;
  final List<String> colors;
  final List<String> behaviors;

  NavtaraRemedies({
    required this.mantras,
    required this.charities,
    required this.gemstones,
    required this.colors,
    required this.behaviors,
  });

  factory NavtaraRemedies.fromJson(Map<String, dynamic> json) {
    return NavtaraRemedies(
      mantras: List<String>.from(json['mantras'] ?? []),
      charities: List<String>.from(json['charities'] ?? []),
      gemstones: List<String>.from(json['gemstones'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      behaviors: List<String>.from(json['behaviors'] ?? []),
    );
  }
}

class NavtaraCompatibility {
  final String readingId;
  final Person person1;
  final Person person2;
  final String relationshipType;
  final CompatibilityAnalysis compatibilityAnalysis;
  final NavtaraRemedies remedies;

  NavtaraCompatibility({
    required this.readingId,
    required this.person1,
    required this.person2,
    required this.relationshipType,
    required this.compatibilityAnalysis,
    required this.remedies,
  });

  factory NavtaraCompatibility.fromJson(Map<String, dynamic> json) {
    return NavtaraCompatibility(
      readingId: json['readingId'] ?? '',
      person1: Person.fromJson(json['person1'] ?? {}),
      person2: Person.fromJson(json['person2'] ?? {}),
      relationshipType: json['relationshipType'] ?? '',
      compatibilityAnalysis: CompatibilityAnalysis.fromJson(
        json['compatibilityAnalysis'] ?? {},
      ),
      remedies: NavtaraRemedies.fromJson(json['remedies'] ?? {}),
    );
  }
}

class Person {
  final String name;
  final String janmaNakshatra;

  Person({required this.name, required this.janmaNakshatra});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] ?? '',
      janmaNakshatra: json['janmaNakshatra'] ?? '',
    );
  }
}

class CompatibilityAnalysis {
  final double compatibilityScore;
  final String compatibilityLevel;
  final CompatibilityCategory person1ToPerson2;
  final CompatibilityCategory person2ToPerson1;
  final String mutualHarmony;
  final List<String> strengths;
  final List<String> challenges;
  final String advice;
  final List<String> recommendations;

  CompatibilityAnalysis({
    required this.compatibilityScore,
    required this.compatibilityLevel,
    required this.person1ToPerson2,
    required this.person2ToPerson1,
    required this.mutualHarmony,
    required this.strengths,
    required this.challenges,
    required this.advice,
    required this.recommendations,
  });

  factory CompatibilityAnalysis.fromJson(Map<String, dynamic> json) {
    return CompatibilityAnalysis(
      compatibilityScore: (json['compatibilityScore'] ?? 0.0).toDouble(),
      compatibilityLevel: json['compatibilityLevel'] ?? '',
      person1ToPerson2: CompatibilityCategory.fromJson(
        json['person1ToPerson2'] ?? {},
      ),
      person2ToPerson1: CompatibilityCategory.fromJson(
        json['person2ToPerson1'] ?? {},
      ),
      mutualHarmony: json['mutualHarmony'] ?? '',
      strengths: List<String>.from(json['strengths'] ?? []),
      challenges: List<String>.from(json['challenges'] ?? []),
      advice: json['advice'] ?? '',
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class CompatibilityCategory {
  final String category;
  final String nature;
  final int favorability;

  CompatibilityCategory({
    required this.category,
    required this.nature,
    required this.favorability,
  });

  factory CompatibilityCategory.fromJson(Map<String, dynamic> json) {
    return CompatibilityCategory(
      category: json['category'] ?? '',
      nature: json['nature'] ?? '',
      favorability: json['favorability'] ?? 0,
    );
  }
}

class NavtaraTiming {
  final String readingId;
  final String janmaNakshatra;
  final String activityType;
  final TimingAnalysis timingAnalysis;
  final NavtaraRemedies remedies;

  NavtaraTiming({
    required this.readingId,
    required this.janmaNakshatra,
    required this.activityType,
    required this.timingAnalysis,
    required this.remedies,
  });

  factory NavtaraTiming.fromJson(Map<String, dynamic> json) {
    return NavtaraTiming(
      readingId: json['readingId'] ?? '',
      janmaNakshatra: json['janmaNakshatra'] ?? '',
      activityType: json['activityType'] ?? '',
      timingAnalysis: TimingAnalysis.fromJson(json['timingAnalysis'] ?? {}),
      remedies: NavtaraRemedies.fromJson(json['remedies'] ?? {}),
    );
  }
}

class TimingAnalysis {
  final List<AuspiciousDate> auspiciousDates;
  final List<AuspiciousDate> moderateDates;
  final List<AuspiciousDate> unfavorableDates;
  final String bestDate;
  final String recommendations;

  TimingAnalysis({
    required this.auspiciousDates,
    required this.moderateDates,
    required this.unfavorableDates,
    required this.bestDate,
    required this.recommendations,
  });

  factory TimingAnalysis.fromJson(Map<String, dynamic> json) {
    return TimingAnalysis(
      auspiciousDates:
          (json['auspiciousDates'] as List?)
              ?.map((e) => AuspiciousDate.fromJson(e))
              .toList() ??
          [],
      moderateDates:
          (json['moderateDates'] as List?)
              ?.map((e) => AuspiciousDate.fromJson(e))
              .toList() ??
          [],
      unfavorableDates:
          (json['unfavorableDates'] as List?)
              ?.map((e) => AuspiciousDate.fromJson(e))
              .toList() ??
          [],
      bestDate: json['bestDate'] ?? '',
      recommendations: json['recommendations'] ?? '',
    );
  }
}

class AuspiciousDate {
  final String date;
  final String reason;
  final List<String> activities;
  final List<String> avoid;
  final int score;
  final Map<String, dynamic>? planetarySupport;
  final String specificAdvice;

  AuspiciousDate({
    required this.date,
    required this.reason,
    required this.activities,
    required this.avoid,
    required this.score,
    this.planetarySupport,
    required this.specificAdvice,
  });

  factory AuspiciousDate.fromJson(Map<String, dynamic> json) {
    return AuspiciousDate(
      date: json['date'] ?? '',
      reason: json['reason'] ?? '',
      activities: List<String>.from(json['activities'] ?? []),
      avoid: List<String>.from(json['avoid'] ?? []),
      score: json['score'] ?? 0,
      planetarySupport: json['planetarySupport'],
      specificAdvice: json['specificAdvice'] ?? '',
    );
  }
}

class NavtaraStats {
  final int totalReadings;
  final int completedReadings;
  final int failedReadings;
  final String? firstReading;
  final String? lastReading;
  final List<dynamic> analysisTypeDistribution;
  final List<dynamic> nakshatraDistribution;

  NavtaraStats({
    required this.totalReadings,
    required this.completedReadings,
    required this.failedReadings,
    this.firstReading,
    this.lastReading,
    required this.analysisTypeDistribution,
    required this.nakshatraDistribution,
  });

  factory NavtaraStats.fromJson(Map<String, dynamic> json) {
    return NavtaraStats(
      totalReadings: json['totalReadings'] ?? 0,
      completedReadings: json['completedReadings'] ?? 0,
      failedReadings: json['failedReadings'] ?? 0,
      firstReading: json['firstReading'],
      lastReading: json['lastReading'],
      analysisTypeDistribution: json['analysisTypeDistribution'] ?? [],
      nakshatraDistribution: json['nakshatraDistribution'] ?? [],
    );
  }
}
