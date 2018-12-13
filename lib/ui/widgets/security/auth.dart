/*
  This file  contains the code for the Authentication widet that presents a web view for CMS BlueButton API.
  Handles the call back and gets the accesstoken from the callback URL.
  And pssses the access token to Home widge that uses it to fecth data and display.
  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../care/care_list.dart';
import 'dart:core';
import 'package:uuid/uuid.dart';
import '../../../util/constants.dart';

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => new _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {

  FlutterWebviewPlugin _flutterWebViewPlugin = new FlutterWebviewPlugin();

  String _authURL = HuMedStatics.CMS_BB_AUTH_URL + "&state="  + new Uuid().v4().toString();

  bool _isLaunched = false;

  @override
  initState() {
    super.initState();
  }

  //main buidl widget method. also launches the CMS BlueButton API oAUTH2 Login web view
  @override
  Widget build(BuildContext context) {

    var appBarColor  = HumedStyles.APP_BAR_COLOR;
    var appBarTitleColor = HumedStyles.APP_BAR_TITLE_COLOR;
    var appBarFontSize = HumedStyles.APP_BAR_TITLE_FONT_SZIE;

    var app = new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
                bottomOpacity: 0.0,
                backgroundColor: appBarColor,
                brightness: Brightness.light,
                title: new Text(
                  "HuMed",
                  style: new TextStyle(color: appBarTitleColor,fontSize: appBarFontSize),
                ),
                centerTitle: true,
                elevation: 0.0,
                iconTheme: Theme.of(context).iconTheme),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  new Center(child: CircularProgressIndicator()),
                  new Text("Launching CMS MyMedicare.gov for Authentication..")
                ]))));

    launchWebView();

    return app;
  }

  void launchWebView() {

    if (!_isLaunched) {
      setState(() {
        _isLaunched = true;
      });
    } else {
      return;
    }

    print(_authURL);

    //launch the web veiw the CMS Blue Bttton API oAUTH2 URL
    _flutterWebViewPlugin.launch(_authURL,
        rect: new Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        hidden: true,
        userAgent: null);

    _flutterWebViewPlugin.onStateChanged
        .listen((WebViewStateChanged stateChange) {
      var state = stateChange.type;

      if (state == WebViewState.finishLoad) {
        _flutterWebViewPlugin.show();
      }
    });

    // Add a listener to on url changed. for the call back from CMS BlueButton oAuth2 Login.
    _flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          final Uri uri = Uri.parse(url);
          if (uri.host == "localhost") {
            //access token comes in as a parm om the callback URL.
            final parms = Uri.splitQueryString(uri
                .fragment); //token response from CMS BlueButton API comes back as fragment
            final token = parms["access_token"];
            print("Access Token:$token");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CareList(accessToken: token)));
            _flutterWebViewPlugin.close();
          }
        });
      }
    });
  }
}
