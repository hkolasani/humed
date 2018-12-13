/*
  This file  contains the code for the buuilding various rows for Non Pharma Benefit ENtry Detail
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

Widget buildSummaryRow(int row, BenefitEntry benefitEntry) {
  String title = "";
  String subTitle = "";
  switch (row) {
    case 0:
      title = "Clam Id";
      subTitle = benefitEntry.claimId;
      break;
    case 1:
      title = "Billable Period";
      subTitle = formatDate(benefitEntry.billablePeriodStart) +
          "  to  " +
          formatDate(benefitEntry.billablePeriodEnd);
      break;
    case 2:
      title = "Payment Amount";
      subTitle = formatAmount(benefitEntry.paymentAmount);
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

Widget buildProviderRow(int row, BenefitEntry benefitEntry) {
  String npi = benefitEntry.providers[row].providerNPI;
  String role = benefitEntry.providers[row].providerRole;
  String name = benefitEntry.providers[row].providerName == null?'':benefitEntry.providers[row].providerName; //TODO: Get Provider Name from look up

  return new ListTile(
      //leading: const Icon(Icons.flight_land),
      isThreeLine: false,
      title: Text("$role. ", style: new TextStyle(fontSize: 12.0)),
      subtitle:
          Text("Dr.$name.", style: new TextStyle(fontSize: 14.0,color: Colors.black)));
}

Widget buildDiagnosisRow(int row, BenefitEntry benefitEntry) {
  String diagniosisCode = benefitEntry.diagnosisCodes[row].code;
  String diagniosisCodeSystem = benefitEntry.diagnosisCodes[row].system;
  String diagniosisCodeDisplay =
      benefitEntry.diagnosisCodes[row].display == null
          ? "Unknown"
          : benefitEntry.diagnosisCodes[row].display;

  return new ListTile(
      //leading: const Icon(Icons.flight_land),
      isThreeLine: false,
      title: Text("ICD Code: $diagniosisCode",
          style: new TextStyle(fontSize: 12.0)),
      subtitle:
          Text(diagniosisCodeDisplay, style: new TextStyle(fontSize: 14.0,color: Colors.black)));
}

Widget buildAmountsRow(int row, BenefitEntry benefitEntry) {
  String title = "";
  String subTitle = "";
  switch (row) {
    case 0:
      title = "Submitted Charge";
      subTitle = formatAmount(benefitEntry.submittedChargeAmount);
      break;
    case 1:
      title = "Allowed Amount";
      subTitle = formatAmount(benefitEntry.allowedAmount);
      break;
    case 2:
      title = "Deductible Applied";
      subTitle = formatAmount(benefitEntry.deductibleAppliedAmount);
      break;
    case 3:
      title = "Provider Payment";
      subTitle = formatAmount(benefitEntry.providerPaymentAmount);
      break;
    case 4:
      title = "Primary Payer Payment";
      subTitle = formatAmount(benefitEntry.primaryPayerPayment);
      break;
    case 5:
      title = "Patient Payment";
      subTitle = formatAmount(benefitEntry.patientPaymentAmount);
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

Widget buildProceduresRow(int row, BenefitEntry benefitEntry) {
  String serviceCode = benefitEntry.benefitEntryItems[row].serviceCode;
  String serviceCodeSystem =
      benefitEntry.benefitEntryItems[row].serviceCodeSystem;
  //String serviceCodeDisplay = benefitEntry.benefitEntryItems[row].serviceCodeDisplay == null?"Unknown":benefitEntry.benefitEntryItems[row].serviceCodeDisplay;
  String serviceCodeDisplay = getServiceCodeDisplay(serviceCode);

  return new ListTile(
      //leading: const Icon(Icons.flight_land),
      isThreeLine: false,
      title: Text("HCPCS Code: $serviceCode",
          style: new TextStyle(fontSize: 12.0)),
      subtitle: Text(serviceCodeDisplay, style: new TextStyle(fontSize: 14.0,color: Colors.black)));
}

String formatAmount(double amount) {
  if (amount == null) {
    return " ";
  }
  return NumberFormat("\$###########.00").format(amount);
}

//a high level hcpcs code translation
String getServiceCodeDisplay(String code) {
  String display = "Unable to get the description";

  if (code == null) {
    return display;
  }

  if (int.tryParse(code) != null) {
    int codeNum = int.parse(code);

    if (codeNum >= 00100 && codeNum <= 01999) {
      display = "Anesthesia";
    } else if (codeNum >= 10021 && codeNum <= 69990) {
      display = "Surgery";
    } else if (codeNum >= 70010 && codeNum <= 79999) {
      display = "Radiology Procedures";
    } else if (codeNum >= 80047 && codeNum <= 89398) {
      display = "Pathology and Laboratory Procedures";
    } else if (codeNum >= 90281 && codeNum <= 99200) {
      display = "Medicine Services and Procedures";
    } else if (codeNum >= 99201 && codeNum <= 99499) {
      display = "Evaluation and Management Services";
    }
  }

  return display;
}

String formatDate(date) {
  if (date == null) {
    return " ";
  }
  var dateTime = DateTime.parse(date);
  var formatter = new DateFormat('MMM dd, yyyy');
  return formatter.format(dateTime);
}
