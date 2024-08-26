import 'package:freezed_annotation/freezed_annotation.dart';

import 'quest_step.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

@freezed
class Quest with _$Quest {
  const factory Quest({
    required String? id,
    required String? userId,
    required bool? isActive,
    required String title,
    required String shortDescription,
    required String longDescription,
    required String imageUrl,
    required double experience,
    required int timeInSeconds,
    required int priceLevel,
    required List<QuestStep> steps,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

  factory Quest.demo() => const Quest(
        id: '1',
        userId: null,
        isActive: null,
        title: 'Test Quest',
        shortDescription: 'Lorem ipsum dolor sit amet',
        longDescription:
            'Lorem ipsum dolor sit amet, c-onsectetur adipiscing elit.',
        imageUrl: 'https://via.placeholder.com/150',
        experience: 100,
        timeInSeconds: 3600,
        priceLevel: 1,
        steps: [
          QuestStep(
            id: null,
            completed: null,
            questId: '1',
            stepName: 'scan qr',
            stepDescription:
                'step 1 description lorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit amet',
            stepType: StepType.qr,
            stepCode: 'step1',
            stepLatitude: null,
            stepLongitude: null,
            stepTime: null,
          ),
          QuestStep(
            id: null,
            completed: null,
            questId: '1',
            stepName: 'arrive at location',
            stepDescription:
                'step 2 description lorem ipsum dolor sit amet lorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit amet',
            stepType: StepType.location,
            stepLatitude: -25.392179,
            stepLongitude: -57.354031,
            stepCode: null,
            stepTime: null,
          ),
          QuestStep(
            id: null,
            completed: null,
            questId: '1',
            stepName: 'time location',
            stepDescription:
                'step 3 description lorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit amet',
            stepType: StepType.timeLocation,
            stepTime: 60,
            stepLatitude: -25.392179,
            stepLongitude: -57.354031,
            stepCode: null,
          ),
        ],
      );

  factory Quest.demoUser(String userId) => Quest(
        id: '2',
        userId: userId,
        isActive: true,
        title: 'Test Quest',
        shortDescription: 'Lorem ipsum dolor sit amet',
        longDescription:
            'Lorem ipsum dolor sit amet, c-onsectetur adipiscing elit.',
        imageUrl: 'https://via.placeholder.com/150',
        experience: 100,
        timeInSeconds: 3600,
        priceLevel: 1,
        steps: [
          const QuestStep(
            id: null,
            completed: true,
            questId: '1',
            stepName: 'scan qr',
            stepDescription:
                'step 1 description lorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit amet',
            stepType: StepType.qr,
            stepCode: 'step1',
            stepLatitude: null,
            stepLongitude: null,
            stepTime: null,
          ),
          const QuestStep(
            id: null,
            completed: true,
            questId: '1',
            stepName: 'arrive at location',
            stepDescription:
                'step 2 description lorem ipsum dolor sit amet lorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit amet',
            stepType: StepType.location,
            stepLatitude: -25.392179,
            stepLongitude: -57.354031,
            stepCode: null,
            stepTime: null,
          ),
          const QuestStep(
            id: null,
            completed: null,
            questId: '1',
            stepName: 'time location',
            stepDescription:
                'step 3 description lorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem ipsum dolor sit amet',
            stepType: StepType.timeLocation,
            stepTime: 60,
            stepLatitude: -25.392179,
            stepLongitude: -57.354031,
            stepCode: null,
          ),
        ],
      );
}
