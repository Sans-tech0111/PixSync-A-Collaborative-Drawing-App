import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixsync/firebase_options.dart';
import 'package:pixsync/homepage.dart';
import 'package:pixsync/theme/apptheme.dart';
import 'package:url_launcher/url_launcher.dart';

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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => PixSync(sessionId: textController.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primaryBackground,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PixSync",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                const Text(
                  "A Collaborative Drawing Space",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            InkWell(
                onTap: () async {
                  await launchUrl(
                      Uri.parse("https://github.com/Sans-tech0111/PixSync-A-Collaborative-Drawing-App"));
                },
                child: Image.asset(
                  "assets/images/github.png",
                  height: 36,
                ))
          ],
        ),
        centerTitle: true,
        foregroundColor: CustomTheme.secondaryBackground,
        backgroundColor: CustomTheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                  ),
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
                                  color: CustomTheme.secondaryText,
                                  fontSize: 12),
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
                            style: TextStyle(
                                color: CustomTheme.secondaryBackground),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: CustomTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: CustomTheme.primary, width: 0.5),
                      // boxShadow: [BoxShadow(color: const Color.fromARGB(255, 155, 155, 155),blurRadius: 10,spreadRadius: 1)]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_rounded,
                                color: CustomTheme.primary,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "How to use?",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Text(
                              "1. Enter or create a 6 digit ID and then click on 'Join' button.\n2. Ask your friends/colleagues to join by entering the same ID.")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              color: CustomTheme.primaryText,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Made with ",
                        style: TextStyle(color: CustomTheme.primaryBackground)),
                    Icon(
                      Icons.favorite,
                      color: CustomTheme.error,
                    ),
                    Text(
                      " by Sanskar Jawalkar",
                      style: TextStyle(color: CustomTheme.primaryBackground),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
