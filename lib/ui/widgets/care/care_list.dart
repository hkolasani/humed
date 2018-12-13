/*
  This file  contains the code for the Hoem Screen: Displays the time line of all EOOB Entries for the suer
  It calls the CMS BlueButton get EOB API and builds the List with a header and a time line
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
import '../../../util/apiutils.dart';
import '../../../util/constants.dart';
import '../common/load_spinner.dart';
import '../../../model/eob.dart';
import '../../../model/EOBJsonStatics.dart';
import 'care_row_pharma.dart';
import 'care_row_non_pharma.dart';
import '../common/patient_header.dart';

class CareList extends StatefulWidget {

  final String accessToken;

  CareList({Key key, @required this.accessToken}) : super(key: key);

  @override
  _CareListState createState() => new _CareListState();
}

class _CareListState extends State<CareList> {

  var _accessToken;
  var _patientId = "";
  var _patientName = "";
  var _patientDOB = "";
  ExplnationOfBenfits _eobData;
  var _loading = true;
  var _loadingError = false;

  @override
  void initState()  {

    super.initState();
    setState(() {
        _accessToken = widget.accessToken;
        _loadingError = false;
    });

    refresh();
  }

  refresh() {

    print("refreshing");
    setState(() {
        _loading = true;
        _loadingError = false;
    });

    getData(_accessToken).then((eobData) {
        setState(() {
          _eobData = eobData;
          _loading = false;
      });
    }).catchError((error){
        print("Exception!: $error");
        //todo: show dialog
    });
  }

  @override
  Widget build(BuildContext context) {

    var appBarColor  = HumedStyles.APP_BAR_COLOR;
    var appBarTitleColor = HumedStyles.APP_BAR_TITLE_COLOR;
    var appBarFontSize = HumedStyles.APP_BAR_TITLE_FONT_SZIE;

    return new Scaffold(
        //drawer: drawer,
        //key: _scaffoldKey,
        appBar: new AppBar(
          bottomOpacity: 0.0,
          backgroundColor: appBarColor,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          title: new Text(
            "HuMed",
            style: new TextStyle(color: appBarTitleColor,fontSize: appBarFontSize),
          ),
          centerTitle: true,
          elevation: 0.0,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: _loading || _loadingError ? new LoadSpinner(loadingError: _loadingError,loading: _loading,):buildBody(context)
        );
  }

  Widget buildBody(BuildContext context) {
   return new Stack(
      children: <Widget>[
        // buildHeader(context),
         buildBodyDetail(context)
      ]
    );
  }

 Widget buildBodyDetail(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white30,
      body: new Stack(
        children: <Widget>[
          new PatientHeader(patientId: _patientId,patientName: _patientName,patientDOB: _patientDOB),
          buildTimeline(context),
          buildList(context),
        ],
      ),
    );
  }

  //the vdrtical line
  Widget buildTimeline(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return new Positioned(
      top: ((screenSize.height / 4) + 70),
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  //the list
  Widget buildList(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Padding(
      padding: new EdgeInsets.only(top: ((screenSize.height / 4) + 20)),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //List Hedder
          new Padding(
              padding: new EdgeInsets.only(left: 30.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    'My Care',
                    style: new TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          //the ListView
          new Expanded(
              child: new ListView(
                     children: _eobData.benefitEntries.map((benefitEntry) => buildCareRow(benefitEntry)).toList(),
                    )
          ),
        ],
      ),
    );
  }


  Widget buildCareRow(BenefitEntry benefityEntry) {

    if(benefityEntry.claimTypeCode == EOBJsonStatics.PHARMACY) {
      return CareRowPharma(benefitEntry:benefityEntry);
    }
    else {
      return CareRowNonPharma(benefitEntry:benefityEntry);
    }
  }

  //call the API and get the EOB  Data
  Future<ExplnationOfBenfits> getData(String accessToken) async {

    var eobData;
    try {
        var userInfo = await getUserInfo(_accessToken);
        setState(() {
            _patientId = userInfo["patient"];
            _patientName = userInfo["name"];
        });

        var patientId = userInfo["patient"].toString();
        var patient = await getPatient(_accessToken,patientId);
        setState(() {
            _patientDOB = patient["birthDate"];
        });

        print("getting EOB DAta");
        eobData = await getEOB(_accessToken,patientId);
    }
    catch (e) {
        print(e.toString());
         setState(() {
           _loading = false;
           _loadingError = true;
        });
    }

    return eobData;

   }
}
