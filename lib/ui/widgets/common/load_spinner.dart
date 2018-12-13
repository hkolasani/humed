/*
  This file  contains the code for reusable methods for building the widgets like Loading Progress Indicatores.
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

class LoadSpinner extends StatefulWidget {
  final bool loading;
  final bool loadingError;

  final double dotSize = 12.0;

  const LoadSpinner({Key key, this.loading,this.loadingError}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new LoadSpinnerState();
  }
}

class LoadSpinnerState extends State<LoadSpinner> {

  @override
  Widget build(BuildContext context) {
        if(widget.loadingError) {
            return new Center(
                child:new Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Error Loading Data!",
                          style: new TextStyle(
                              fontSize: 20.0,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                            ),
                            new Text(
                            "Please try again later! ",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: 12.0,
                                letterSpacing: -0.2,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Roboto",
                                color: Colors.black),
                          ),
                      ]
                )
              );
        }
        else {
            return new Center(
                child:new Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(child:CircularProgressIndicator()),
                        new Text("Loading data ..")
                      ]
                )
              );
        }
  }
}
