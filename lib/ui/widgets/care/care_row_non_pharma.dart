/*
  This file  contains the code for the widget that displays a single EOB Entry

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
import '../../../model/eob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../eob/eob_non_pharma_detail.dart';
import '../../../util/apiutils.dart';

class CareRowNonPharma extends StatefulWidget {
  final BenefitEntry benefitEntry;

  final double dotSize = 12.0;

  const CareRowNonPharma({Key key, this.benefitEntry}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new CareRowNonPharmaState();
  }
}

class CareRowNonPharmaState extends State<CareRowNonPharma> {

  var _loadingDetials = false;

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: new GestureDetector(
            onTap: showClaimDetail,
            child: buildRow(context)
        ));
  }

  Widget buildRow(BuildContext context) {

    return new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.symmetric(
                      horizontal: 32.0 - widget.dotSize / 2),
                  child: _loadingDetials ? new SizedBox(width: 10.0, height: 10.0, child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green))): new Container(
                    height: widget.dotSize,
                    width: widget.dotSize,
                    decoration: new BoxDecoration(
                        //for timeline dot
                        shape: BoxShape.circle,
                        color: Colors.orange
                    ),
                  ),
                ),
                new Expanded(
                  //row content
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          buildRowContent() //main middle content of the rows
                      ),
                ),
                new Padding(
                    padding: const EdgeInsets.only(left: 10, right: 16.0),
                    child: Icon(Icons.keyboard_arrow_right,
                        color: Colors.grey, size: 20.0)),
              ],
            );
  }

  //builds the Text widgets that go in the middle of each row.
  List<Text> buildRowContent() {

    List<Text> rowContent = new List<Text>();

    String serviceLabel = "";

    //date
    rowContent.add(new Text(
      formattedDate(),
      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
    ));

    var diagnosisCodes = widget.benefitEntry.diagnosisCodes;
    //var provider = widget.benefitEntry.providers[0].providerName;
    // var claimType = widget.benefitEntry.claimTypeCode;
    /*rowContent.add(new Text(
      "Dr. Van Norfronvich",
      style: new TextStyle(fontSize: 12.0),
    ));*/
    for (var diagnosisCode in diagnosisCodes) {
      //there can be multiple disagnossis codes for each entry
      serviceLabel = diagnosisCode.display;
      if (serviceLabel != null) {
        rowContent.add(new Text(
          "$serviceLabel",
          style: new TextStyle(fontSize: 14.0),
        ));
      }
    }

    return rowContent;
  }

  showClaimDetail() {

    setState(() {
        _loadingDetials = true;
    });


    //before going to detial: look up provider NPI
    lookUpProviders().then((lookedUpProviders) {
       setState(() {
          _loadingDetials = false;
        });
        widget.benefitEntry.providers = lookedUpProviders;
            Navigator.push(context,
                MaterialPageRoute(
                builder: (context) =>
                    EOBNonPharmaDetail(benefitEntry: widget.benefitEntry)));
    }).catchError((error){
        setState(() {
          _loadingDetials = false;
        });

          print("Exception!: $error");
    });
  }

  Future<List<Provider>> lookUpProviders() async {

      var providers = widget.benefitEntry.providers;
      List<Provider> lookedUpProviders = new List<Provider>();
      for(var provider in providers) {
          var providerNPI = provider.providerNPI;
          if(providerNPI == "999999999999" || providerNPI == "999999999999999") {  //TODO:  replace fake NOI wtth some teal test one.
              providerNPI = "1003897281";  //TODO: DELETE THIS !!!
          }
          var lookedupProvider = await lookupProvider(providerNPI);
          lookedupProvider.providerRole = provider.providerRole;
          lookedUpProviders.add(lookedupProvider);
      }

      return lookedUpProviders;
  }

  String formattedDate() {
    String eobDate = widget.benefitEntry.eobDate;
    var eobDateTime = DateTime.parse(eobDate);
    var formatter = new DateFormat('MMM dd, yyyy');
    return formatter.format(eobDateTime);
  }
}
