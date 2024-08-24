import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixsync/theme/apptheme.dart';

class PixSync extends StatefulWidget {
  const PixSync({super.key, required this.sessionId});
  final String sessionId;
  @override
  State<PixSync> createState() => _PixSyncState();
}

class _PixSyncState extends State<PixSync> {
  List<Offset?> _points = [];
  final firestore = FirebaseFirestore.instance;
  final database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchPoints();
  }

  void fetchPoints() async {
    final snapshot = await database.child(widget.sessionId).get();
    final data = snapshot.value as List?;
    if (data != null && data.isNotEmpty) {
      _points = data.map(
        (item) {
          final point = Map<String, dynamic>.from(item);
          if (point['dx'] == -1 && point['dy'] == -1) {
            return null;
          }
          
          return Offset(point['dx'], point['dy']);
        },
      ).toList();
    }else{
      _points = [];
    }
  }

  void _undo() {
    
    setState(() {
      _points.removeLast();
      if (_points.isNotEmpty){
        int lastNullIndex = _points.lastIndexWhere((point) => point == null);
        print(lastNullIndex);
        if (lastNullIndex != -1) {
          _points.removeRange(lastNullIndex, _points.length);
        } else {
          print("failed");
          _points.clear();
        }
        database.child(widget.sessionId).set(_points.map((offset) {
              if (offset == null) {
                return {'dx': -1, 'dy': -1};
              }
              return {'dx': offset.dx, 'dy': offset.dy};
            }).toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: CustomTheme.primaryBackground,
            appBar: AppBar(
              title: const Text("PixSync"),
              centerTitle: true,
              foregroundColor: CustomTheme.secondaryBackground,
              backgroundColor: CustomTheme.primary,
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _undo,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: CustomTheme.secondaryBackground,
                                boxShadow: [
                                  const BoxShadow(
                                    color: CustomTheme.alternate,
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                  )
                                ]),
                            child: const Icon(Icons.undo_rounded),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 50,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: CustomTheme.secondaryBackground,
                            boxShadow: [
                              const BoxShadow(
                                color: CustomTheme.alternate,
                                spreadRadius: 5,
                                blurRadius: 5,
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomTheme.alternate,
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomTheme.alternate,
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomTheme.alternate,
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomTheme.alternate,
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/images/eraser.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/images/thickness.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 50),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return MouseRegion(
                              cursor: SystemMouseCursors.cell,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  final offset = details.localPosition;
                                  final normalizedOffset = Offset(
                                      offset.dx / constraints.maxWidth,
                                      offset.dy / constraints.maxHeight);
                                  setState(() {
                                    _points.add(normalizedOffset);
                                  });
                                  // firestore
                                  //     .collection('canvas')
                                  //     .doc('123456')
                                  //     .update({
                                  //   'points': _points.map((offset) {
                                  //     if (offset == null) {
                                  //       return null;
                                  //     }
                                  //     return {'dx': offset.dx, 'dy': offset.dy};
                                  //   }).toList()
                                  // });
                                  database
                                      .child(widget.sessionId)
                                      .set(_points.map((offset) {
                                        if (offset == null) {
                                          return {
                                          'dx': -1,
                                          'dy': -1
                                        };
                                        }
                                        return {
                                          'dx': offset.dx,
                                          'dy': offset.dy
                                        };
                                      }).toList());
                                },
                                onPanStart: (details) {
                                  
                                  fetchPoints();
                                  
                                  },
                                onPanEnd: (details) {
                                  setState(() {
                                    _points.add(null);
                                  });
                                 
                                  database
                                      .child(widget.sessionId)
                                      .set(_points.map((offset) {
                                        if (offset == null) {
                                          return {
                                          'dx': -1,
                                          'dy': -1
                                        };
                                        }
                                        return {
                                          'dx': offset.dx,
                                          'dy': offset.dy
                                        };
                                      }).toList());
                                
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                      color: CustomTheme.secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                            color: CustomTheme.alternate,
                                            spreadRadius: 5,
                                            blurRadius: 5,
                                            offset: Offset(3, 3))
                                      ]),
                                  child: Center(
                                    child: StreamBuilder(
                                        // stream: firestore
                                        //     .collection('canvas')
                                        //     .doc('123456')
                                        //     .snapshots(),
                                        stream:
                                            database.child(widget.sessionId).onValue,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CustomPaint(
                                              size: Size(constraints.maxWidth,
                                                  constraints.maxHeight),
                                              painter: CanvasPainter(_points),
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            return const Center(
                                                child: Text(
                                                    'Error loading points'));
                                          }
                                          if (snapshot.data!.snapshot.value ==
                                              null) {
                                            return const Center(
                                                child:
                                                    Text('Start drawing...'));
                                          }
                                          final document = snapshot.data!;
                                          final event =
                                              document.snapshot.value as List;
                                          
                                          final List<Offset?> points =
                                              event.map((map) {
                                                final point =
                                                Map<String, double>.from(map);
                                            if (point['dx'] == -1 && point['dy'] == -1) {
                                              return null;
                                            }
                                            
                                            return Offset(
                                                point['dx']!, point['dy']!);
                                          }).toList();
                                          return CustomPaint(
                                            size: Size(constraints.maxWidth,
                                                constraints.maxHeight),
                                            painter: CanvasPainter(points),
                                          );
                                        }),
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
            )));
  }
}

class CanvasPainter extends CustomPainter {
  final List<Offset?> points;
  CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.001;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        final p1 =
            Offset(points[i]!.dx * size.width, points[i]!.dy * size.height);
        final p2 = Offset(
            points[i + 1]!.dx * size.width, points[i + 1]!.dy * size.height);
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}