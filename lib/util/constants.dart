
/*
  This file  contains the static constants used in various parts of the applciaiton.
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

class HuMedStatics {

    static const String NPI_LOOKUP_ENDPOINT            =   "https://npiregistry.cms.hhs.gov/api";
    static const String CMS_BB_AUTH_ENDPOINT           =   "https://sandbox.bluebutton.cms.gov/v1/o/authorize/";
    static const String CMS_BB_HUMED_APP_CLIENT_ID     =   "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"; //get a client id by registering your own app
    static const String CMS_BB_HUMED_APP_CALLBACK_URL  =   "http://localhost:8080/callback";
    static const String CMS_BB_AUTH_URL                =   CMS_BB_AUTH_ENDPOINT + "?client_id=" +
                                                           CMS_BB_HUMED_APP_CLIENT_ID +
                                                           "&redirect_uri=" + CMS_BB_HUMED_APP_CALLBACK_URL +
                                                           "&response_type=token" ;

    static const String CMS_BB_API_ENDPOINT            =   "https://sandbox.bluebutton.cms.gov/v1";
    static const String CMS_BB_API_USERINFO_URI        =   CMS_BB_API_ENDPOINT + "/connect/userinfo";
    static const String CMS_BB_API_PATIENT_URI         =   CMS_BB_API_ENDPOINT + "/fhir/Patient/";
    static const String CMS_BB_API_EOB_URI             =   CMS_BB_API_ENDPOINT + "/fhir/ExplanationOfBenefit";
    static const int    CMS_BB_API_EOB_MAX_PAGE_COUNT  =   50;

}

class HumedStyles {

  // static const THEME = const new  ThemeData(

  //   // Define the default Brightness and Colors
  //   brightness: Brightness.dark,
  //   primaryColor: Colors.lightBlue[800],
  //   accentColor: Colors.cyan[600],

  //   // Define the default Font Family
  //   fontFamily: 'Montserrat',

  //   // Define the default TextTheme. Use this to specify the default
  //   // text styling for headlines, titles, bodies of text, and more.
  //   textTheme: TextTheme(
  //     headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  //     title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  //     body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  //   ),
  // );

  static const APP_BAR_COLOR  = const Color(0xffbce6e3);
  static const APP_BAR_TITLE_COLOR  =  Colors.black;
  static const APP_BAR_TITLE_FONT_SZIE  =  20.0;
  //static const TIME_LINE_COLOR  =   Colors.grey[300];
}
