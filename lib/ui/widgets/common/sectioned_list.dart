/*
  This file  contains the code for the widget that displays a sectioned list. Similar to iOS Grouped TableView

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

abstract class SectionedList {
  int getNumberOfSections();

  int getNumberOfRowsInSection(int section);

  Widget buildSectionHeader(int section);

  Widget buildRow(int section, int row);

  Widget buildList(BuildContext context) {
    int sections = getNumberOfSections();

    return new Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
            itemCount: sections,
            itemBuilder: (context, section) {
              return new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: buildSectionHeader(section)),
                    new Card(
                        elevation: 5 ,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Container(
                            decoration: BoxDecoration(color: Colors.teal[20]),
                            child: buildSection(section)))
                  ]);
            }));
  }

  //section is a list view rows
  Widget buildSection(int section) {
    int rows = getNumberOfRowsInSection(section);
    return ListView.separated(
        itemCount: rows,
        shrinkWrap: true, //this is important for nested list view to work
        separatorBuilder: (BuildContext context, int index) => Divider(),
        physics:
            ClampingScrollPhysics(), //this is to prevent scrolling inside the mnested lsit view
        itemBuilder: (context, row) {
          return buildRow(section, row); //Build the tile here...
        }
    );
  }
}
