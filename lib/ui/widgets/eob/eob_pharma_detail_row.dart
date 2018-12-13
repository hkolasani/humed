/*
  This file  contains the code for the buuilding various rows for Pharma Benefit Entry Detail
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
import 'package:intl/intl.dart';

Widget buildSummaryRow(int row,BenefitEntry benefitEntry) {

  BenefitEntryItem entryItem = benefitEntry.benefitEntryItems[0]; //For pharmacy: it's assumed that there is always only one item

  String title = "";
  String subTitle = "";
  switch (row) {
    case 0:
      String ndcCode = entryItem.serviceCode;
      String ndcCodeSystem = entryItem.serviceCodeSystem;
      String ndcCodeDisplay = entryItem.serviceCodeDisplay == null?"Unknown":benefitEntry.benefitEntryItems[row].serviceCodeDisplay;
      title =  "NDC:$ndcCode";
      subTitle = ndcCodeDisplay;
      break;
    case 1:
      title = "Prescription Date";
      subTitle = formatDate(benefitEntry.eobDate);
      break;
   case 2:
      String disageInfo = getDosageInfo(entryItem);
      title = "Dosage";
      subTitle = disageInfo;
      break;
   case 3:
      String npi = benefitEntry.facilityNPI;
      String name  = "";
      if(benefitEntry.facility != null) {
          name = benefitEntry.facility.facilityName;  //TODO: Get Pharmacy Name from look up
      }
      if(name == null) {
        name = "";
      }
      title = "Pharmacy";
      //subTitle = "$name. (NPI - $npi)";
      subTitle = name;
      break;
   case 4:
      title = "Rx. Ref#";
      subTitle = benefitEntry.rxRefNum + ". " + benefitEntry.id;
      break;
    default:
      break;
  }

  return new ListTile(
      //leading: const Icon(Icons.flight_land),
      isThreeLine: false,
      title: Text(title, style: new TextStyle(fontSize: 12.0)),
      subtitle: Text(subTitle, style: new TextStyle(fontSize: 14.0,color: Colors.black)));
}

Widget buildProviderRow(int row,BenefitEntry benefitEntry) {

  String npi = benefitEntry.providers[row].providerNPI;
  String role = benefitEntry.providers[row].providerRole;
  String name = benefitEntry.providers[row].providerName == null?'':benefitEntry.providers[row].providerName;

  return new ListTile(
      //leading: const Icon(Icons.flight_land),
      isThreeLine: false,
      title: Text("$role. ", style: new TextStyle(fontSize: 12.0)),
      //subtitle: Text("$name. (NPI - $npi)", style: new TextStyle(fontSize: 12.0)));
      subtitle: Text("Dr. $name.", style: new TextStyle(fontSize: 14.0)));
}

Widget buildAdjudicatioinRow(int row,BenefitEntry benefitEntry) {

  BenefitEntryItem entryItem = benefitEntry.benefitEntryItems[0]; //For pharmacy: it's assumed that there is always only one item
  Adjudication adjudication = entryItem.adjudications[row];
  String title = adjudication.category;
  String subTitle = formatAmount(adjudication.amount);

  return new ListTile(
      //leading: const Icon(Icons.flight_land),
      isThreeLine: false,
      title: Text(title, style: new TextStyle(fontSize: 12.0)),
      subtitle: Text(subTitle, style: new TextStyle(fontSize: 14.0)));
}


String formatAmount(double amount) {

  if(amount == null) {
    return " ";
  }
  return NumberFormat("\$###########.00").format(amount);
}

String getDosageInfo(BenefitEntryItem benefitEntryItem) {

      int quanitty = benefitEntryItem.quantity;
      int numberOfDrugFills = benefitEntryItem.numberOfDrugFills;
      int numberOfDaysSuppy = benefitEntryItem.numberOfDaysSuppy;

      return "Qty: $quanitty. Supply for $numberOfDaysSuppy Days. No.of Refills: $numberOfDrugFills.";
}


String formatDate(date) {
    if(date == null) {
      return " ";
    }
    var dateTime = DateTime.parse(date);
    var formatter = new DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
}
