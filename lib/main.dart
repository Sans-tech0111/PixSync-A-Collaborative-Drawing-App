import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixsync/firebase_options.dart';
import 'package:pixsync/homepage.dart';
import 'package:pixsync/theme/apptheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return runApp(MaterialApp(
    theme: customThemeData(),
    home: const InitialPage(),
  ));
}

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  void navigateToHome() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>
        PixSync(sessionId: textController.text)
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomTheme.primaryBackground,
        appBar: AppBar(
          title: const Text(
            "PixSync",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          foregroundColor: CustomTheme.secondaryBackground,
          backgroundColor: CustomTheme.primary,
        ),
        body: Center(
          child: Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create/Join a drawing space",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  softWrap: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Session Id",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  decoration: BoxDecoration(
                      // color: CustomTheme.accent1,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: textController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter session Id";
                          }
                          if (value.trim().length < 6) {
                            return "should be of atlest 6 digits";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            counterText: "",
                            hintText: "Enter a session Id",
                            hintStyle: TextStyle(
                                color: CustomTheme.secondaryText, fontSize: 12),
                            fillColor: CustomTheme.accent1,
                            filled: true,
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomTheme.error)),
                            errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomTheme.error)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomTheme.primary)),
                            contentPadding: EdgeInsets.all(5)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: navigateToHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomTheme.tertiary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: const Text(
                          "Join",
                          style:
                              TextStyle(color: CustomTheme.secondaryBackground),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}
