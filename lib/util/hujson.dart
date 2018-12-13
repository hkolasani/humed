/*
  This file  contains the code for HuJSON utility class that can take a JSON object and can traverse
  to a node using a PATH to fetch it's value .
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

class HuJSON {

  Map<String, dynamic> jsonMap;

  //constructor
  HuJSON(Map<String, dynamic> jsonMap) {
    this.jsonMap = jsonMap;
  }

 //gets the string element at the specified path.  eg. ["dep",0,"emp"]
  dynamic parse(List<dynamic> pathInfo) {
      dynamic obj = this.jsonMap;
      for (dynamic pathElement in pathInfo) {
        if(obj != null && (obj is Map<String, dynamic> || obj is List<dynamic>)) {
          obj = obj[pathElement];
        }
        else {
          obj = null;
        }
      }
      return obj;
  }

  //gets the string element at the specified path.  eg. ["dep",0,"emp",0,address]
  String getString(List<dynamic> pathInfo) {

    dynamic obj = this.parse(pathInfo);

    if (obj != null &&  obj is String) {
      return obj.toString();
    }
    else {
      return null;
    }
  }

  //gets the double element at the specified path.  eg. ["dep",0,"emp",0,salary]
  double getDouble(List<dynamic> pathInfo) {

    dynamic obj = this.parse(pathInfo);

    if (obj != null &&  obj is num) {
      return obj.toDouble();
    }
    else {
      return null;
    }
  }

  //gets the int element at the specified path.  eg. ["dep",0,"emp",0,salary]
  int getInt(List<dynamic> pathInfo) {

    dynamic obj = this.parse(pathInfo);

    if (obj != null &&  obj is num) {
      return obj.toInt();
    }
    else {
      return null;
    }
  }

  //gets the array element at the specified path.  eg. ["dep",0,"emp",0,"skills"]
  List<dynamic> getArray(List<dynamic> pathInfo) {

    dynamic obj = this.parse(pathInfo);

    if (obj != null &&  obj is List<dynamic> ) {
      return obj.toList();
    }
    else {
      return null;
    }
  }

  //gets the json element at the specified path.  eg. ["dep",0,"emp",0,"details"]
  HuJSON getJSON(List<dynamic> pathInfo) {

    dynamic obj = this.parse(pathInfo);

    if (obj != null &&  obj is Map<String, dynamic> ) {
      return new HuJSON(obj);
    }
    else {
      return null;
    }
  }

}
