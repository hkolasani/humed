/*
  This file  contains the code for a single EOB for a non Pharms entry. Part A and B
  It uses the SectionedList mixin to display various parts of the EOB entry like Claim Info, Provider, Item and Adjudication details.

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
import '../../../model/eob.dart';
import '../common/sectioned_list.dart';
import 'eob_non_pharma_detail_row.dart';
import '../../../util/constants.dart';

class EOBNonPharmaDetail extends StatefulWidget with SectionedList {

  final BenefitEntry benefitEntry;

  EOBNonPharmaDetail({Key key, @required this.benefitEntry}) : super(key: key);

  @override
  _EOBNonPharmaDetailState createState() => new _EOBNonPharmaDetailState();

  @override
  int getNumberOfSections() {
    return 5;
  }

  @override
  int getNumberOfRowsInSection(int section) {
    int numberOfRows = 0;

    switch (section) {
      case 0:
        numberOfRows = 3;  //summary
        break;
      case 1:
        numberOfRows = benefitEntry.providers.length;  //provider
        break;
      case 2:
        numberOfRows = benefitEntry.diagnosisCodes.length; //diagnosis code
        break;
      case 3:
        numberOfRows = 6;  //amounts at the entry level
        break;
      case 4:
        numberOfRows = benefitEntry.benefitEntryItems.length;  //service/proceudre codes at Item level
        break;
      default:
        numberOfRows = 0;
    }

    return numberOfRows;
  }

  @override
  Widget buildSectionHeader(int section) {
    String sectionHeader = "";
    Icon sectionIcon;

    switch (section) {
      case 0:
        sectionHeader = "Claim";
        sectionIcon = Icon(Icons.receipt,color:Colors.blue);
        break;
      case 1:
        sectionHeader = "Provider";
        sectionIcon = Icon(Icons.person,color:Colors.red);
        break;
      case 2:
        sectionHeader = "Diagnosis";
        sectionIcon = Icon(Icons.bug_report,color:Colors.green);
        break;
      case 3:
        sectionHeader = "Claim Amounts";
        sectionIcon = Icon(Icons.attach_money,color:Colors.orange);
        break;
      case 4:
        sectionHeader = "Procedures";
        sectionIcon = Icon(Icons.build,color:Colors.orange);
        break;
      default:
        sectionHeader = "";
        sectionIcon = Icon(Icons.person,color:Colors.black);
    }

    return Row(children: <Widget>[
      sectionIcon,
      Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(sectionHeader, style: new TextStyle(fontSize: 16.0)))
    ]);
  }

  @override
  Widget buildRow(int section, int row) {

    switch (section) {
      case 0:
        return buildSummaryRow(row,benefitEntry);
        break;
      case 1:
        return buildProviderRow(row,benefitEntry);
        break;
      case 2:
        return buildDiagnosisRow(row,benefitEntry);
        break;
      case 3:
        return buildAmountsRow(row,benefitEntry);
        break;
      case 4:
        return buildProceduresRow(row,benefitEntry);
        break;
      default:
        break;
    }

    return new ListTile(
      //leading: const Icon(Icons.flight_land),
      isThreeLine: false,
      title: Text('Title-$section', style: new TextStyle(fontSize: 12.0)),
      subtitle: Text('Sub Title-$row', style: new TextStyle(fontSize: 10.0)),
    );
  }

}

class _EOBNonPharmaDetailState extends State<EOBNonPharmaDetail>   {


  @override
  Widget build(BuildContext context) {

    var appBarColor  = HumedStyles.APP_BAR_COLOR;
    var appBarTitleColor = HumedStyles.APP_BAR_TITLE_COLOR;
    var appBarFontSize = HumedStyles.APP_BAR_TITLE_FONT_SZIE;

    return new Scaffold(
        //drawer: drawer,
        //key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          bottomOpacity: 0.0,
          backgroundColor: appBarColor,
          brightness: Brightness.light,
          //automaticallyImplyLeading: false,
          title: new Text(
            "Care Details",
            style: new TextStyle(color: appBarTitleColor,fontSize: appBarFontSize),
          ),
          centerTitle: true,
          elevation: 0.0,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: widget.buildList(context));
  }
}
