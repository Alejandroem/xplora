import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/quest_providers.dart';
import '../../domain/models/quest.dart';
import '../../theme.dart';

class QuestList extends ConsumerStatefulWidget {
  final bool isHero;
  const QuestList({
    this.isHero = false,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestListState();
}

class _QuestListState extends ConsumerState<QuestList> {
  Quest? scannedQuest;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isBlinking = false;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  @override
  void dispose() {
    controller?.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  // Start blinking effect for in-progress quests
  void _startBlinking() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBlinking = !_isBlinking;
      });
    });
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    await for (final scanData in controller.scannedDataStream) {
      log('QR Code scanned: ${scanData.code}');

      if (scanData.code != null &&
          scannedQuest?.stepCode != null &&
          scanData.code == scannedQuest?.stepCode) {
        final questCrudService = ref.watch(questCrudServiceProvider);
        final authService = ref.watch(authServiceProvider);

        final user = await authService.getAuthUser();

        if (user != null) {
          // Award the quest by updating the userId and refreshing the list
          await questCrudService.create(scannedQuest!.copyWith(
            questId: scannedQuest!.id,
            userId: user.id,
          ));

          // Refresh the nearby quest provider to reflect the awarded quest
          //ref.refresh(nearbyQuestProvider);
        }

        controller.pauseCamera();
      } else {
        controller.pauseCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questInProgress = ref.watch(questInProgressTrackerProvider);
    //invalidate nearbyQuestProvider when quetInProgressBecomesNull

    return ref.watch(nearbyQuestProvider).when(
      data: (data) {
        return Container(
          padding: widget.isHero
              ? const EdgeInsets.all(0)
              : const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!widget.isHero)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.flag, color: raisingBlack),
                      Text(
                        'Quest',
                        style: TextStyle(fontSize: 20, color: raisingBlack),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: widget.isHero
                        ? BorderRadius.circular(0)
                        : BorderRadius.circular(10),
                  ),
                  child: Card(
                    shape: widget.isHero
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))
                        : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: (data).length,
                      itemExtent: widget.isHero ? 50 : 27,
                      itemBuilder: (context, index) {
                        Quest quest = data[index];

                        // Determine if the quest is the one currently in progress
                        final isBlinkingQuest = questInProgress != null &&
                            questInProgress.quest.id == quest.id;
                        final questColor = isBlinkingQuest && _isBlinking
                            ? Colors.yellow.withOpacity(0.5)
                            : (index.isEven
                                ? Colors.grey.shade100
                                : Colors.white);

                        return Container(
                          decoration: BoxDecoration(
                            color: questColor,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (quest.stepType == QuestType.location) {
                                // Handle location quest
                              } else if (quest.stepType == QuestType.qr) {
                                setState(() {
                                  scannedQuest = quest;
                                });
                                _showQRScannerDialog(context, quest);
                              } else if (quest.stepType ==
                                  QuestType.timeLocation) {
                                // Handle time-location quest
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Text(
                                      quest.title,
                                      style: TextStyle(
                                        fontSize: widget.isHero ? 20 : 14,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  if (quest.stepType == QuestType.location)
                                    Icon(Icons.map, color: raisingBlack),
                                  if (quest.stepType == QuestType.qr)
                                    Icon(Icons.qr_code, color: raisingBlack),
                                  if (quest.stepType == QuestType.timeLocation)
                                    Icon(Icons.hourglass_bottom,
                                        color: raisingBlack),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 1,
                                    color: Colors.grey,
                                    margin: const EdgeInsets.only(left: 8),
                                  ),
                                  Container(
                                    width: widget.isHero ? 60 : 30,
                                    decoration: BoxDecoration(
                                      color: quest.userId == null
                                          ? Colors.white
                                          : Colors.blue,
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return Text('Error: $error');
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showQRScannerDialog(BuildContext context, Quest quest) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.infinity,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).primaryColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 200,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller?.pauseCamera();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
