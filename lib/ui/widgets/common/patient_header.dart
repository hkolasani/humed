/*
  This file  contains the code for the widget that displays the patient header

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
import '../../../util/constants.dart';

class PatientHeader extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientDOB;

  final double dotSize = 12.0;

  const PatientHeader({Key key, this.patientId,this.patientName,this.patientDOB}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PatientHeaderState();
  }
}

class PatientHeaderState extends State<PatientHeader> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var patientId = widget.patientId;
    var patientDOB = widget.patientDOB;
    return  new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                  width: screenSize.width,
                  height: screenSize.height / 4,
                  decoration: new BoxDecoration(
                    color: HumedStyles.APP_BAR_COLOR
                  ),
                  child: new Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Flexible(
                          child: new Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: ExactAssetImage('images/avatar1.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 7.0),
                          child: new Text(
                            widget.patientName,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ),
                        new Text(
                          "ID: $patientId.  DOB: $patientDOB",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontSize: 12.0,
                              letterSpacing: -0.2,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              color: Colors.black54),
                        ),
                      ]
                    ),
                  )
              ),
            ],
          ),
        );
  }
}
