/*
  This file  contains the code for calling CMS BlueButton API
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

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import '../util/hujson.dart';
import '../model/eob.dart';
import './constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart' show rootBundle;

Future<Map<String,dynamic>> getUserInfo(String accessToken) async {

   var userInfoURL =  HuMedStatics.CMS_BB_API_USERINFO_URI;
   var authHeader = "Bearer $accessToken";

   final response = await http.get(userInfoURL,headers:{"Authorization":authHeader});

   if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to get userinfo');
   }
}

Future<Map<String,dynamic>> getPatient(String accessToken, String patientId) async {

   var patientURL =  HuMedStatics.CMS_BB_API_PATIENT_URI + patientId;
   var authHeader = "Bearer $accessToken";

   final response = await http.get(patientURL,headers:{"Authorization":authHeader});

   if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to get patient');
   }
}

 //API has a limit of 50. .so needs to call it multiple times to fetch all data. NextURL diocates
Future<ExplnationOfBenfits> getEOB(String accessToken, String patientId) async {

   ExplnationOfBenfits eob;

   var authHeader = "Bearer $accessToken";
   final maxPageCount = HuMedStatics.CMS_BB_API_EOB_MAX_PAGE_COUNT;
   //first 50
   var eobURL =  HuMedStatics.CMS_BB_API_EOB_URI + "?patient=$patientId&startIndex=0&count=$maxPageCount";

   final response = await http.get(eobURL,headers:{"Authorization":authHeader});

   if (response.statusCode == 200) {
       eob = new ExplnationOfBenfits(new HuJSON(json.decode(response.body)));  //build model object from the response.
       var nextPageURL = eob.nextPageURL;
       //now page thru and get all eobs
       while(nextPageURL != null) {
         print(nextPageURL);
          final eobResponse = await http.get(nextPageURL,headers:{"Authorization":authHeader});
          if (eobResponse.statusCode == 200) {
              var moreEobs = new ExplnationOfBenfits(new HuJSON(json.decode(eobResponse.body)));
              eob.benefitEntries.addAll(moreEobs.benefitEntries); //accumulate benefit entries
              nextPageURL = moreEobs.nextPageURL;
          } else {
             throw Exception('Failed to get EOB Entries');
          }
       }

      //now sort the entries by entry date
      if( eob.benefitEntries != null &&  eob.benefitEntries.length > 0) {
        eob.benefitEntries.sort((entry1,entry2) => entry2.eobDate.compareTo(entry1.eobDate));
      }

      return eob;
    }
    else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to get EOB');
   }
}

//NPI Lookup - Provider
Future<Provider> lookupProvider(String npi) async {

   var npiLookupURL =  HuMedStatics.NPI_LOOKUP_ENDPOINT + "/?number=$npi";

   final response = await http.get(npiLookupURL);

   if (response.statusCode == 200 && response.body.indexOf("error") < 0) {
      return Provider.fromLookup(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to lookup NPI');
   }
}

//NPI Lookup - Facility
Future<Facility> lookupFacility(String npi) async {

   var npiLookupURL =  HuMedStatics.NPI_LOOKUP_ENDPOINT + "/?number=$npi";

   final response = await http.get(npiLookupURL);

   if (response.statusCode == 200 && response.body.indexOf("error") < 0) {
      return Facility.fromLookup(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to lookup NPI');
   }
}

 testLoadAllData()  {
  Future.wait([testDataLoad('data/pharma.json'), testDataLoad('data/eob.json'), testDataLoad('data/SampleClientEOB.json')])
                    .then((List responses) => testCollectResponses(responses));
}

testCollectResponses(List responses) {
  print(responses);
}

Future<String> testDataLoad(String name) async {

  const Duration delay = const Duration(milliseconds: 5000);

  return new Future.delayed(delay).then((_) {
    return name + ' Hello';
  });

}

Future<ExplnationOfBenfits> testDataLoad1(String fileName) async {

    print("fetching $fileName");

    //String dataString = await rootBundle.loadString('data/pharma.json');
    String dataString = await rootBundle.loadString(fileName);

    //final file = new File('data/eob.json');
    //final data =  await file.readAsString();
    final jsonData = json.decode(dataString);

    var huJSON = new HuJSON(jsonData);
    //print(huJSON.getString(["meta","lastUpdated"]));
    //print(huJSON.getDouble(["entry",0,"resource","payment","amountX","value"]));
    var eob = new ExplnationOfBenfits(huJSON);
    //print(eob);

    return eob;
}
