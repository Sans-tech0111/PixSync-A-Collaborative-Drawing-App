import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixsync/brush_model.dart';
import 'package:pixsync/theme/apptheme.dart';

class PixSync extends StatefulWidget {
  const PixSync({super.key, required this.sessionId});
  final String sessionId;
  @override
  State<PixSync> createState() => _PixSyncState();
}

class _PixSyncState extends State<PixSync> {
  // List<Offset?> _points = [];
  List<BrushModel?> _points1 = [];
  final firestore = FirebaseFirestore.instance;
  final database = FirebaseDatabase.instance.ref();
  double thickness = 0.002;
  double rad = 50;
  double r = 40;
  double g = 40;
  double b = 40;
  double bk = 40;
  double eraser = 40;
  int colorIndex = 3;
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.black,
    Colors.white
  ];

  @override
  void initState() {
    super.initState();
    fetchPoints();
    // if (_points.isEmpty) {
    //   initSession();
    // }
  }

  void fetchPoints() async {
    final snapshot = await database.child(widget.sessionId).get();
    final data = snapshot.value as Map<String, dynamic>?;
    if (data != null && data.isNotEmpty) {
      _points1 = data.values.map(
        (item) {
          final point = Map<String, dynamic>.from(item);
          if (point['dx'] == -1 && point['dy'] == -1) {
            return null;
          }
          return BrushModel(
              offset: Offset(point['dx'], point['dy']),
              color: point['color'],
              thickness: point['thick']);
        },
      ).toList();
    } else {
      _points1 = [];
    }
  }

  void _undo() {
    setState(() {
      _points1.removeLast();
      if (_points1.isNotEmpty) {
        int lastNullIndex = _points1.lastIndexWhere((point) => point == null);
        if (lastNullIndex != 0 && lastNullIndex != -1) {
          _points1.removeRange(lastNullIndex, _points1.length);
          _points1.add(null);
        } else {
          print("Removed all points!");
          _points1.clear();
        }

        Map<String, dynamic> orderedMap = {};
        for (int i = 0; i < _points1.length; i++) {
          String key = i.toString().padLeft(10, '0'); // Ensure proper ordering
          if (_points1[i] == null) {
            orderedMap[key] = {'dx': -1, 'dy': -1};
          } else {
            orderedMap[key] = {
              'dx': _points1[i]!.offset.dx,
              'dy': _points1[i]!.offset.dy,
              'color': _points1[i]!.color,
              'thick': _points1[i]!.thickness
            };
          }
        }
        database.child(widget.sessionId).set(orderedMap);
        // database.child(widget.sessionId).set(
        //       _points1.asMap().map(
        //         (index, brush) {
        //           if (brush == null) {
        //             return MapEntry(
        //                 "-${index.toString()}", {'dx': -1, 'dy': -1});
        //           }
        //           return MapEntry("-${index.toString()}", {
        //             'dx': brush.offset.dx,
        //             'dy': brush.offset.dy,
        //             'color': brush.color,
        //             'thick': brush.thickness
        //           });
        //         },
        //       ),
        //     );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: customThemeData(),
        home: Scaffold(
            backgroundColor: CustomTheme.primaryBackground,
            appBar: AppBar(
              leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios_new)),
              toolbarHeight: 70,
              title: Column(
                children: [
                  const Text("Drawing Space"),
                  Text(
                    "Session ID : ${widget.sessionId}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  )
                ],
              ),
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
                      InkWell(
                        onTap: _undo,
                        radius: 50,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTapUp: (details) {
                          setState(() {
                            rad = 50;
                          });
                        },
                        onTapDown: (details) {
                          setState(() {
                            rad = 30;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: rad,
                          height: rad,
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
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    colorIndex = 3;
                                    thickness = 0.002;
                                  });
                                },
                                onTapUp: (details) {
                                  setState(() {
                                    bk = 40;
                                  });
                                },
                                onTapDown: (details) {
                                  setState(() {
                                    bk = 20;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  width: bk,
                                  height: bk,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorIndex == 3
                                              ? CustomTheme.primary
                                              : CustomTheme.alternate,
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    colorIndex = 0;
                                    thickness = 0.002;
                                  });
                                },
                                onTapUp: (details) {
                                  setState(() {
                                    r = 40;
                                  });
                                },
                                onTapDown: (details) {
                                  setState(() {
                                    r = 20;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  width: r,
                                  height: r,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorIndex == 0
                                              ? CustomTheme.primary
                                              : CustomTheme.alternate,
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    colorIndex = 1;
                                    thickness = 0.002;
                                  });
                                },
                                onTapUp: (details) {
                                  setState(() {
                                    g = 40;
                                  });
                                },
                                onTapDown: (details) {
                                  setState(() {
                                    g = 20;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  width: g,
                                  height: g,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorIndex == 1
                                              ? CustomTheme.primary
                                              : CustomTheme.alternate,
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    colorIndex = 2;
                                    thickness = 0.002;
                                  });
                                },
                                onTapUp: (details) {
                                  setState(() {
                                    b = 40;
                                  });
                                },
                                onTapDown: (details) {
                                  setState(() {
                                    b = 20;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  width: b,
                                  height: b,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorIndex == 2
                                              ? CustomTheme.primary
                                              : CustomTheme.alternate,
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    colorIndex = 4;
                                    thickness = 0.1;
                                  });
                                },
                                onTapUp: (details) {
                                  setState(() {
                                    eraser = 40;
                                  });
                                },
                                onTapDown: (details) {
                                  setState(() {
                                    eraser = 20;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  width: eraser,
                                  height: eraser,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorIndex == 4
                                          ? CustomTheme.primary
                                          : CustomTheme.alternate,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorIndex == 4
                                              ? CustomTheme.primary
                                              : CustomTheme.alternate,
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                        )
                                      ]),
                                  child: Image.asset(
                                    "assets/images/eraser.jpg",
                                    fit: BoxFit.cover,
                                  ),
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
                                    _points1.add(BrushModel(
                                        offset: normalizedOffset,
                                        color: colorIndex,
                                        thickness: thickness));
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
                                  // database
                                  //     .child(widget.sessionId)
                                  //     .set(_points.map((offset) {
                                  //       if (offset == null) {
                                  //         return {'dx': -1, 'dy': -1};
                                  //       }
                                  //       return {
                                  //         'dx': offset.dx,
                                  //         'dy': offset.dy
                                  //       };
                                  //     }).toList());
                                  database.child(widget.sessionId).push().set({
                                    'dx': offset.dx / constraints.maxWidth,
                                    'dy': offset.dy / constraints.maxHeight,
                                    'color': colorIndex,
                                    'thick': thickness
                                  });
                                },
                                onPanStart: (details) {
                                  fetchPoints();
                                },
                                onPanEnd: (details) {
                                  setState(() {
                                    _points1.add(null);
                                  });

                                  // database
                                  //     .child(widget.sessionId)
                                  //     .set(_points.map((offset) {
                                  //       if (offset == null) {
                                  //         return {'dx': -1, 'dy': -1};
                                  //       }
                                  //       return {
                                  //         'dx': offset.dx,
                                  //         'dy': offset.dy
                                  //       };
                                  //     }).toList());
                                  database
                                      .child(widget.sessionId)
                                      .push()
                                      .set({'dx': -1, 'dy': -1});
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
                                        stream: database
                                            .child(widget.sessionId)
                                            .onValue,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CustomPaint(
                                              size: Size(constraints.maxWidth,
                                                  constraints.maxHeight),
                                              painter: CanvasPainter(
                                                _points1,
                                              ),
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
                                          } else {
                                            final document = snapshot.data!;

                                            final event = document.snapshot
                                                .value as Map<String, dynamic>?;

                                            final List<BrushModel?> points =
                                                event!.values.map((map) {
                                              final point =
                                                  Map<String, dynamic>.from(
                                                      map);
                                              if (point['dx'] == -1 &&
                                                  point['dy'] == -1) {
                                                return null;
                                              }

                                              return BrushModel(
                                                  offset: Offset(point['dx']!,
                                                      point['dy']!),
                                                  color: point['color'],
                                                  thickness: point['thick']);
                                            }).toList();

                                            _points1 = points;

                                            return CustomPaint(
                                              size: Size(constraints.maxWidth,
                                                  constraints.maxHeight),
                                              painter: CanvasPainter(
                                                points,
                                              ),
                                            );
                                          }
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
  final List<BrushModel?> points;
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.black,
    Colors.white
  ];
  // int colorIndex;
  CanvasPainter(this.points);
  // final thickness;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        final paint = Paint()
          ..color = colors[points[i]!.color ?? 3]
          ..strokeCap = StrokeCap.round
          ..strokeWidth =
              size.width * points[i]!.thickness ?? size.width * 0.002;
        final p1 = Offset(points[i]!.offset.dx * size.width,
            points[i]!.offset.dy * size.height);
        final p2 = Offset(points[i + 1]!.offset.dx * size.width,
            points[i + 1]!.offset.dy * size.height);
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
