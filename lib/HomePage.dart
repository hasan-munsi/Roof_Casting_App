import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationController, textAniController;
  Animation animation;
  double lengthFt = 0.0;
  double heightFt = 0.0;
  double widthFt = 0.0;
  double errorOpacity = 0;
  double cem = 0, sand = 0, brick = 0, rod = 0, area = 0, dryVol = 0;
  final lengthController = TextEditingController();
  final heightController = TextEditingController();
  final widthController = TextEditingController();

  bool processOutput() {
    if (lengthController.text.trim().length >= 1 &&
        heightController.text.trim().length >= 1 &&
        widthController.text.trim().length >= 1) {
      if (validityCheck(lengthController.text.trim()) &&
          validityCheck(heightController.text.trim()) &&
          validityCheck(widthController.text.trim())) {
        lengthFt = double.parse(lengthController.text.trim());
        heightFt = double.parse(heightController.text.trim());
        widthFt = double.parse(widthController.text.trim());
        area = lengthFt * heightFt * widthFt;
        dryVol = area * 1.5;
        setState(() {
          cem = dryVol * 0.1 * 0.8;
          sand = dryVol * 0.3;
          brick = dryVol * 0.6 * 9;
          rod = area * 0.01 * 222;
        });
      } else {
        return false;
      }
    } else {
      return false;
    }

    return true;
  }

  bool validityCheck(String s) {
    int count = 0;
    bool rType = true;
    List chr = s.split('');
    for (final c in chr) {
      if (c == '.') {
        count++;
        continue;
      }
      try {
        double.parse(c);
      } catch (e) {
        rType = false;
      }
    }
    if (count >= 2) {
      rType = false;
    }
    return rType;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    textAniController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut);
    animationController.addListener(() {
      if (animationController.isCompleted) {
        textAniController.forward();
      }
      setState(() {});
    });
    textAniController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    lengthController.dispose();
    heightController.dispose();
    widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF162345),
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      child: Container(
        color: Color(0xFF212E4E),
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextAreaInput(
                      controller: lengthController,
                      hT: "ফুট",
                      lT: "ছাদের দৈর্ঘ্য",
                      aniBack: () async {
                        await textAniController.reverse();
                        animationController.reverse();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextAreaInput(
                      controller: widthController,
                      hT: "ফুট",
                      lT: "ছাদের প্রস্থ",
                      aniBack: () async {
                        await textAniController.reverse();
                        animationController.reverse();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextAreaInput(
                      controller: heightController,
                      hT: "ফুট",
                      lT: "ছাদের পুরুত্ব",
                      aniBack: () async {
                        await textAniController.reverse();
                        animationController.reverse();
                      },
                    ),
                  ),
                ],
              ),
              Opacity(
                opacity: errorOpacity,
                child: Text("সব ঘর সঠিক সংখ্যা দ্বারা পূরণ করুন"),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        OutputCircle(
                          amount: cem.toStringAsFixed(1),
                          details: "বস্তা সিমেন্ট",
                          size: animation.value,
                          tSize: textAniController.value,
                        ),
                        OutputCircle(
                          amount: sand.toStringAsFixed(1),
                          details: "সি এফ টি বালি",
                          size: animation.value,
                          tSize: textAniController.value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        OutputCircle(
                          amount: brick.toStringAsFixed(1),
                          details: "পিস ইট",
                          size: animation.value,
                          tSize: textAniController.value,
                        ),
                        OutputCircle(
                          amount: rod.toStringAsFixed(1),
                          details: "কেজি রড",
                          size: animation.value,
                          tSize: textAniController.value,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: RaisedButton(
                  color: Color(0xFF7F6FFB),
                  child: Text("হিসাব করুন"),
                  onPressed: () {
                    if (processOutput()) {
                      setState(() {
                        errorOpacity = 0;
                      });
                      animationController.forward();
                    } else
                      setState(() {
                        errorOpacity = 1;
                      });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutputCircle extends StatelessWidget {
  final String amount, details;
  final double size, tSize;
  OutputCircle({this.amount, this.details, this.size, this.tSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Opacity(
          opacity: tSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                amount,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                details,
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
      width: size * 150,
      height: size * 150,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF7F6FFB)),
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
    );
  }
}

class TextAreaInput extends StatelessWidget {
  final TextEditingController controller;
  final String hT, lT;
  final Function aniBack;
  TextAreaInput({this.controller, this.hT, this.lT, this.aniBack});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Color(0xFF7F6FFB),
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF7F6FFB),
            width: 2.0,
          ),
        ),
        hintText: hT,
        labelText: lT,
      ),
      onChanged: (v) {
        aniBack();
      },
    );
  }
}
