import 'dart:math';

import 'package:book_club/models/user_model.dart';
import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/group_model.dart';
import '../../shared/appBars/home_app_bar.dart';
import '../../shared/app_drawer.dart';
import '../../shared/helpers.dart';

class Donate extends StatefulWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  const Donate(
      {Key? key, required this.currentUser, required this.currentGroup})
      : super(key: key);

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  final String _url = 'https://ko-fi.com/ockhambyron';
  late WebViewXController webviewController;
  final initialContent =
      'https://ko-fi.com/ockhambyron/?hidefeed=true&widget=true&embed=true&preview=true';
  final executeJsErrorMessage =
      'Failed to execute this task because the current content is (probably) URL that allows iframe embedding, on Web.\n\n'
      'A short reason for this is that, when a normal URL is embedded in the iframe, you do not actually own that content so you cant call your custom functions\n'
      '(read the documentation to find out why).';

  Size get screenSize => MediaQuery.of(context).size;

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Suivez-moi sur ma page Ko-Fi pour rester au courant de mes réalisations !",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 250,
                child: ListTile(
                  leading: Icon(
                    Icons.coffee,
                    color: Theme.of(context).focusColor,
                  ),
                  title: Text(
                    "Visitez ma page Ko-Fi",
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                  onTap: _launchURL,
                ),
              ),
              _buildWebViewX(),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(
        currentGroup: widget.currentGroup,
        currentUser: widget.currentUser,
      ),
    );
  }

  Widget _buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: initialContent,
      initialSourceType: SourceType.url,
      height: 600,
      width: screenSize.width,
      onWebViewCreated: (controller) => webviewController = controller,
      onPageStarted: (src) =>
          debugPrint('A new page has started loading: $src\n'),
      onPageFinished: (src) =>
          debugPrint('The page has finished loading: $src\n'),
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) => showSnackBar(msg.toString(), context),
        )
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        debugPrint(navigation.content.sourceType.toString());
        return NavigationDecision.navigate;
      },
    );
  }

  Widget buildSpace({
    Axis direction = Axis.horizontal,
    double amount = 0.2,
    bool flex = true,
  }) {
    return flex
        ? Flexible(
            child: FractionallySizedBox(
              widthFactor: direction == Axis.horizontal ? amount : null,
              heightFactor: direction == Axis.vertical ? amount : null,
            ),
          )
        : SizedBox(
            width: direction == Axis.horizontal ? amount : null,
            height: direction == Axis.vertical ? amount : null,
          );
  }
}
