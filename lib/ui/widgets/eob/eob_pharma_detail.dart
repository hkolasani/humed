/*
  This file  contains the code for a single EOB for a Pharms entry. Part D
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
import 'eob_pharma_detail_row.dart';
import '../../../util/constants.dart';

class EOBPharmaDetail extends StatefulWidget with SectionedList  {

  final BenefitEntry benefitEntry;

  EOBPharmaDetail({Key key, @required this.benefitEntry}) : super(key: key);

  @override
  _EOBPharmaDetailState createState() => new _EOBPharmaDetailState();

  @override
  int getNumberOfSections() {
    return 3;
  }

  @override
  int getNumberOfRowsInSection(int section) {
    int numberOfRows = 0;

    switch (section) {
      case 0:
        numberOfRows = 5;  //summary
        break;
      case 1:
        numberOfRows = benefitEntry.providers.length;  //provider
        break;
      case 2:
        numberOfRows = benefitEntry.benefitEntryItems[0].adjudications.length;  //assumed only one Benefit Entry for Pharmacy
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
        sectionHeader = "Prescription";
        sectionIcon = Icon(Icons.note_add,color:Colors.blue);
        break;
      case 1:
        sectionHeader = "Provider";
        sectionIcon = Icon(Icons.person,color:Colors.red);
        break;
      case 2:
        sectionHeader = "Adjudication";
        sectionIcon = Icon(Icons.attach_money,color:Colors.teal);
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
        return buildAdjudicatioinRow(row,benefitEntry);
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

class _EOBPharmaDetailState extends State<EOBPharmaDetail>  {


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
