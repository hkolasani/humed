/*
  This file  contains the static constants used for parsing teh EOB Json obtained from CMS BlueButton APi
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

class EOBJsonStatics {

    //json element names
    static const String LINK_RELATION_ATTRIBUTE = "relation";
    static const String VALUE_ATTRIBUTE = "value";
    static const String SYETEM_ATTRIBUTE = "system";
    static const String DISPLAY_ATTRIBUTE = "display";
    static const String URL_ATTRIBUTE = "url";
    static const String CODE_ATTRIBUTE = "code";
    static const String IDENTIFIER_ATTRIBUTE = "identifier";

    //json element values
    static const String PHARMACY = "pharmacy";
    static const String PROFESSIONAL = "professional";
    static const String VISON = "vision";
    static const String INSTITUTIONAL = "insitutional";
    static const String ORAL = "oral";

    static const String LINK_SELF_RELATION = "self";
    static const String LINK_NEXT_RELATION = "next";
    static const String LINK_PREVIOUS_RELATION = "previous";
    static const String LINK_FIRST_RELATION = "first";
    static const String LINK_LAST_RELATION = "last";
    static const String CLAIM_ID_SYSTEM = "https://bluebutton.cms.gov/resources/variables/clm_id";
    static const String CLAIM_GROUP_SYSTEM = "https://bluebutton.cms.gov/resources/identifier/claim-group";
    static const String RX_REF_NUM_SYSTEM = "https://bluebutton.cms.gov/resources/variables/rx_srvc_rfrnc_num";
    static const String CLAIM_TYPE_SYSTEM = "http://hl7.org/fhir/ex-claimtype";
    static const String NDC_SYSTEM = "http://hl7.org/fhir/sid/ndc" ;  //for prescription drug
    static const String HCPCS_SYSTEM = "https://bluebutton.cms.gov/resources/codesystem/hcpcs" ;//procedure code;
    static const String FILL_NUM = "https://bluebutton.cms.gov/resources/variables/fill_num";
    static const String DAYS_SUPPLY = "https://bluebutton.cms.gov/resources/variables/days_suply_num";

    static const String RESOURCE_EXTENSION_PRIMARY_PAYER_PAYMENT = "https://bluebutton.cms.gov/resources/variables/prpayamt";
    static const String RESOURCE_EXTENSION_DEDUCTIBLE_APPLIED = "https://bluebutton.cms.gov/resources/variables/carr_clm_cash_ddctbl_apld_amt";
    static const String RESOURCE_EXTENSION_PROVIDER_PAYMENT = "https://bluebutton.cms.gov/resources/variables/nch_clm_prvdr_pmt_amt";
    static const String RESOURCE_EXTENSION_PATIENT_PAYMENT = "https://bluebutton.cms.gov/resources/variables/nch_clm_bene_pmt_amt";
    static const String RESOURCE_EXTENSION_SUBMITTED_CHARGE = "https://bluebutton.cms.gov/resources/variables/nch_carr_clm_sbmtd_chrg_amt";
    static const String RESOURCE_EXTENSION_ALLOWED_AMOUNT = "https://bluebutton.cms.gov/resources/variables/nch_carr_clm_alowd_amt";

    //paths
    static const List<dynamic> LINKS_PATH = ["link"];
    static const List<dynamic> LAST_UPDATED_PATH = ["meta","lastUpdated"];
    static const List<dynamic> TOTAL_PATH = ["total"];
    static const List<dynamic> ENTRY_PATH = ["entry"];

    static const List<dynamic> ID_PATH = ["resource","id"];
    static const List<dynamic> IDENTIFIER_PATH = ["resource","identifier"];
    static const List<dynamic> BILLABLE_PERIOD_START_PATH = ["resource","billablePeriod","start"];
    static const List<dynamic> BILLABLE_PERIOD_END_PATH = ["resource","billablePeriod","end"];
    static const List<dynamic> PAYMENT_AMOUNT_PATH = ["resource","payment","amount","value"];

    static const List<dynamic> TYPE_CODING_PATH = ["resource","type","coding"];

    static const List<dynamic> DIAGNOSIS_PATH = ["resource","diagnosis"];
    static const List<dynamic> DIAGNOSIS_CODE_PATH = ["diagnosisCodeableConcept","coding",0,"code"];
    static const List<dynamic> DIAGNOSIS_CODE_SYSTEM_PATH = ["diagnosisCodeableConcept","coding",0,"system"];
    static const List<dynamic> DIAGNOSIS_CODE_DISPLAY_PATH = ["diagnosisCodeableConcept","coding",0,"display"];

    static const List<dynamic> INSURANCE_COVERAGE_REFERENCE_PATH = ["resource","insurance","coverage","reference"];

    static const List<dynamic> ORGANIZATION_NPI_PATH = ["resource","organization","identifier","value"];
    static const List<dynamic> FACILITY_NPI_PATH = ["resource","facility","identifier","value"];

    static const List<dynamic> CARE_TEAM_PATH = ["resource","careTeam"];
    static const List<dynamic> CARE_TEAM_ROLE_PATH = ["role","coding",0,"display"];
    static const List<dynamic> CARE_TEAM_QUALIFICATION_PATH = ["qualification","coding",0,"display"];
    static const List<dynamic> CARE_TEAM_PROVIDER_NPI_PATH = ["provider","identifier","value"];

    static const List<dynamic> RESOURCE_EXTENSION_PATH = ["resource","extension"];
    static const List<dynamic> RESOURCE_EXTENSION_URL_PATH = ["url"];
    static const List<dynamic> RESOURCE_EXTENSION_AMOUNT_VALUE_PATH = ["valueMoney","value"];

    static const List<dynamic> ITEM_PATH = ["resource","item"];
    static const List<dynamic> ITEM_SEQUENCE_PATH = ["sequence"];
    static const List<dynamic> ITEM_CATEGORY_PATH = ["category","coding",0,"display"];
    static const List<dynamic> ITEM_SERVICE_CODE_SYSTEM_PATH = ["service","coding",0,"system"];
    static const List<dynamic> ITEM_SERVICE_CODE_PATH = ["service","coding",0,"code"];
    static const List<dynamic> ITEM_SERVICE_CODE_DISPLAY_PATH = ["service","coding",0,"display"];
    static const List<dynamic> ITEM_SERVICE_DATE_PATH = ["servicedDate"];
    static const List<dynamic> ITEM_SERVICE_PERIOD_START_PATH = ["servicedPeriod","start"];
    static const List<dynamic> ITEM_SERVICE_PERIOD_END_PATH = ["servicedPeriod","end"];
    static const List<dynamic> ITEM_QUANTITY_PATH = ["quantity","value"];
    static const List<dynamic> ITEM_QUANTITY_EXTENSION_PATH = ["quantity","extension"];
    static const List<dynamic> ITEM_VALUE_QUANTITY_PATH = ["valueQuantity","value"];
    static const List<dynamic> ITEM_ADJUDICATION_PATH = ["adjudication"];
    static const List<dynamic> ITEM_ADJUDICATION_CATEGORY_CODING_PATH = ["category","coding",0,"display"];
    static const List<dynamic> ITEM_ADJUDICATION_AMOUNT_PATH = ["amount","value"];
    static const List<dynamic> ITEM_ADJUDICATION_REASON_PATH = ["reason","coding",0,"display"];
}
