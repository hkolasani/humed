/*
  This file  contains the code classes for EOB and also the code to construct them by parsing EOB JSON from
  CMS BLueButton APIO repsonse. Ref: https://bluebutton.cms.gov/assets/ig/index.html.
  The Heierarchy is: ExplnationOfBenfits --> Benefity Enties[]-->BenfitENtryItems.
  This class uses a HuJSON utility class that can take a JSON object and can traverse to a node using a PATH
  and fetch it's value .

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

import '../util/hujson.dart';
import 'EOBJsonStatics.dart';

class ExplnationOfBenfits {

    //fields
    String currentPageURL;
    String nextPageURL;
    String prviousPageURL;
    String firstPageURL;
    String lastPageURL;

    String lastUpdated;
    int totalClaims;

    List<BenefitEntry> benefitEntries;  //multiple benefit enties for the user.

    ExplnationOfBenfits(HuJSON jsonData) {

        List<dynamic> links = jsonData.getArray(EOBJsonStatics.LINKS_PATH);

        this.buildLinks(links);

        this.lastUpdated = jsonData.getString(EOBJsonStatics.LAST_UPDATED_PATH);

        this.totalClaims = jsonData.getInt(EOBJsonStatics.TOTAL_PATH);

        List<dynamic> entries = jsonData.getArray(EOBJsonStatics.ENTRY_PATH);

        this.benefitEntries = new List<BenefitEntry>();

        //build benefit entries
        for (Map<String,dynamic> entryJSON in entries) {
             BenefitEntry benefitEntry = new BenefitEntry(new HuJSON(entryJSON));
             this.benefitEntries.add(benefitEntry);
        }
    }

    buildLinks(List<dynamic> links) {

        for (Map<String,dynamic> link in links) {
            var relation = link[EOBJsonStatics.LINK_RELATION_ATTRIBUTE];
            var url = link[EOBJsonStatics.URL_ATTRIBUTE];
            switch (relation) {
              case EOBJsonStatics.LINK_SELF_RELATION:
                  this.currentPageURL = url;
                  break;
              case EOBJsonStatics.LINK_NEXT_RELATION:
                  this.nextPageURL = url;
                  break;
              case EOBJsonStatics.LINK_PREVIOUS_RELATION:
                  this.prviousPageURL = url;
                  break;
              case EOBJsonStatics.LINK_FIRST_RELATION:
                  this.firstPageURL = url;
                  break;
              case EOBJsonStatics.LINK_LAST_RELATION:
                  this.lastPageURL = url;
                  break;
              default:
                  break;
            }
        }
    }

    //filter by  type: //institutional,oral,pharmacy,professional,vision. default desc sort order by date
    List<BenefitEntry> filter(String claimType) {

      List<BenefitEntry> filtered = this.benefitEntries.where((benefitEntry) => benefitEntry.claimTypeCode == claimType).toList();

      filtered.sort((entry1,entry2) => entry2.eobDate.compareTo(entry1.eobDate));

      return filtered;
    }
}

//class rerpesents a single benefit entry
class BenefitEntry {

    String id;

    String claimId;
    String claimGroup;
    String rxRefNum;

    String organizationNPI;
    String facilityNPI;

    String eobDate;

    String billablePeriodStart;
    String billablePeriodEnd;

    double paymentAmount;

    List<String> typeDescriptions;
    String claimTypeDisplay;
    String claimTypeCode;  //institutional(hospital),oral/dental,pharmacy/prescriptions,professional/office visits, vision

    List<DiagniosisCode> diagnosisCodes;

    String insuranceCoverageReference;

    Facility facility;

    List<Provider> providers;
    double primaryPayerPayment;
    double deductibleAppliedAmount;
    double providerPaymentAmount;
    double patientPaymentAmount;
    double submittedChargeAmount;
    double allowedAmount;

    List<BenefitEntryItem> benefitEntryItems;  //a benefit entry can have multiple benefit entry items

    BenefitEntry(HuJSON entryJson) {

        //id
        this.id = entryJson.getString(EOBJsonStatics.ID_PATH);

        //identifiers
        List<dynamic> identifiersJson = entryJson.getArray(EOBJsonStatics.IDENTIFIER_PATH);
        if(identifiersJson != null) {
          this.buildIdentifiers(identifiersJson);
        }

        //organization and Facility
        this.organizationNPI = entryJson.getString(EOBJsonStatics.ORGANIZATION_NPI_PATH);
        this.facilityNPI = entryJson.getString(EOBJsonStatics.FACILITY_NPI_PATH);

        //billable period
        this.billablePeriodStart = entryJson.getString(EOBJsonStatics.BILLABLE_PERIOD_START_PATH);
        this.billablePeriodEnd = entryJson.getString(EOBJsonStatics.BILLABLE_PERIOD_END_PATH);

        //payment amount
        this.paymentAmount = entryJson.getDouble(EOBJsonStatics.PAYMENT_AMOUNT_PATH);

        //type descriptions
        List<dynamic> typeCodingsJSON = entryJson.getArray(EOBJsonStatics.TYPE_CODING_PATH);
        if(typeCodingsJSON != null) {
           this.buildTypeDescriptions(typeCodingsJSON);
        }

        //disgnosis Codes
        List<dynamic>  disagnosisJSON = entryJson.getArray(EOBJsonStatics.DIAGNOSIS_PATH);
        if(disagnosisJSON != null) {
          this.buildDiagnosisCodes(disagnosisJSON);
        }

        //insurnace coverage reference
        this.insuranceCoverageReference = entryJson.getString(EOBJsonStatics.INSURANCE_COVERAGE_REFERENCE_PATH);

        //providers
        List<dynamic>  careTeamArray = entryJson.getArray(EOBJsonStatics.CARE_TEAM_PATH);
        this.providers = new List<Provider>();
        for (Map<String,dynamic> careTeam in careTeamArray) {
            HuJSON providerJSON = new HuJSON(careTeam);
            Provider provider = Provider(providerJSON);
            this.providers.add(provider);
        }

        //benefit amounts (in resource->extension)
        List<dynamic> resourceExtensionsJSON = entryJson.getArray(EOBJsonStatics.RESOURCE_EXTENSION_PATH);
        if(resourceExtensionsJSON != null) {
           this.buildPaymentAmounts(resourceExtensionsJSON);
        }

        //entry items
        List<dynamic> items  = entryJson.getArray(EOBJsonStatics.ITEM_PATH);
        this.benefitEntryItems = new List<BenefitEntryItem>();
        for (Map<String, dynamic> item in items) {
            HuJSON entryItemJson = new HuJSON(item);
             BenefitEntryItem benefitEntryItem = BenefitEntryItem(entryItemJson);
             this.benefitEntryItems.add(benefitEntryItem);
        }

        //service/entry date. For pharmacy it's the first and only beenfit entry item's service date.
        //for others it's the billabale start period at the Benefit entry leve.
        //Ref: https://bluebutton.cms.gov/assets/ig/StructureDefinition-bluebutton-pde-claim.html
        this.eobDate = this.claimTypeCode == EOBJsonStatics.PHARMACY?benefitEntryItems[0].serviceDate:this.billablePeriodStart;
    }

    buildIdentifiers(List<dynamic> identifiers) {

        for (Map<String,dynamic> identifier in identifiers) {

            String system = identifier[EOBJsonStatics.SYETEM_ATTRIBUTE];
            String value = identifier[EOBJsonStatics.VALUE_ATTRIBUTE];
            switch (system) {
                case EOBJsonStatics.CLAIM_ID_SYSTEM:
                    this.claimId = value;
                    break;
                case EOBJsonStatics.CLAIM_GROUP_SYSTEM:
                    this.claimGroup = value;
                    break;
                case EOBJsonStatics.RX_REF_NUM_SYSTEM:
                    this.rxRefNum = value;
                    break;
                default:
                    break;
            }
        }

    }

    buildPaymentAmounts(List<dynamic> resourceExtensions) {

       for (Map<String,dynamic> resourceExtension in resourceExtensions) {

            HuJSON resourceExtensionJSON = new HuJSON(resourceExtension);
            String  url = resourceExtensionJSON.getString(EOBJsonStatics.RESOURCE_EXTENSION_URL_PATH);
            double  amount = resourceExtensionJSON.getDouble(EOBJsonStatics.RESOURCE_EXTENSION_AMOUNT_VALUE_PATH);
            switch (url) {
                case EOBJsonStatics.RESOURCE_EXTENSION_PRIMARY_PAYER_PAYMENT:
                    this.primaryPayerPayment = amount;
                    break;
                case EOBJsonStatics.RESOURCE_EXTENSION_DEDUCTIBLE_APPLIED:
                    this.deductibleAppliedAmount = amount;
                    break;
                case EOBJsonStatics.RESOURCE_EXTENSION_PROVIDER_PAYMENT:
                    this.providerPaymentAmount = amount;
                    break;
                case EOBJsonStatics.RESOURCE_EXTENSION_PATIENT_PAYMENT:
                    this.patientPaymentAmount = amount;
                    break;
                case EOBJsonStatics.RESOURCE_EXTENSION_SUBMITTED_CHARGE:
                    this.submittedChargeAmount = amount;
                    break;
                case EOBJsonStatics.RESOURCE_EXTENSION_ALLOWED_AMOUNT:
                    this.allowedAmount = amount;
                    break;
                default:
                    break;
            }
        }

    }

    buildTypeDescriptions(List<dynamic> typeCodings) {

      this.typeDescriptions = new List<String>();

      for (Map<String,dynamic> typeCoding in typeCodings) {

            String  system = typeCoding[EOBJsonStatics.SYETEM_ATTRIBUTE];
            if(system == EOBJsonStatics.CLAIM_TYPE_SYSTEM) {
                this.claimTypeCode = typeCoding[EOBJsonStatics.CODE_ATTRIBUTE];
                this.claimTypeDisplay = typeCoding[EOBJsonStatics.DISPLAY_ATTRIBUTE];
            }
            String display = typeCoding[EOBJsonStatics.DISPLAY_ATTRIBUTE];
            if(display != null) {
                this.typeDescriptions.add(display);
            }
        }
    }

    buildDiagnosisCodes(List<dynamic> diagnosisCodings) {

      this.diagnosisCodes = new List<DiagniosisCode>();

      for (Map<String,dynamic> diagnosisCoding in diagnosisCodings) {

            HuJSON diagnosisCodingJSON = new HuJSON(diagnosisCoding);

            var diagnosisCode = new DiagniosisCode(diagnosisCodingJSON);
            this.diagnosisCodes.add(diagnosisCode);
        }
    }
}

class Provider {

    String providerNPI;
    String providerRole;
    String providerQualification;
    String providerPrefix;
    String providerName;
    String credential;
    String providerAddress;
    String providerCity;
    String providerState;
    String providerZip;

    Provider(HuJSON careTeamJson) {

        this.providerRole = careTeamJson.getString(EOBJsonStatics.CARE_TEAM_ROLE_PATH);
        this.providerQualification = careTeamJson.getString(EOBJsonStatics.CARE_TEAM_QUALIFICATION_PATH);
        this.providerNPI = careTeamJson.getString(EOBJsonStatics.CARE_TEAM_PROVIDER_NPI_PATH);

        //todo: get the others when they are available in the API.
    }

    //Build Provider from Lookup: https://npiregistry.cms.hhs.gov/api/
    Provider.fromLookup(Map<String, dynamic> npiLookupResponse)  {
        this.providerName = " ";  //default
        if(npiLookupResponse["result_count"] > 0) {
            this.providerNPI = npiLookupResponse["results"][0]["number"].toString();
            var providerObj = npiLookupResponse["results"][0]["basic"];
            this.providerName = providerObj["first_name"] + " " + providerObj["last_name"];
            this.providerPrefix = providerObj["name_prefix"];
            this.credential = providerObj["credential"];
         }
        }
}

class Facility {

    String facilityNPI;
    String facilityName;
    String facilityAddress;
    String facilityCity;
    String facilityState;
    String facilityZip;

    //Build Facilitu from Lookup: https://npiregistry.cms.hhs.gov/api/
    Facility.fromLookup(Map<String, dynamic> npiLookupResponse)  {
        if(npiLookupResponse["result_count"] > 0) {
            this.facilityNPI = npiLookupResponse["results"][0]["number"].toString();
            var facilityObj = npiLookupResponse["results"][0]["basic"];
            this.facilityName = facilityObj["name"];
            //TODO: Build the rest.
         }
        }
}

class BenefitEntryItem {

    int sequence;
    String category;
    String serviceCodeSystem;
    String serviceCode;  //NDC Code for Pharmacy and  HCPCS Code for non-pharm,acy
    String serviceCodeDisplay;
    String serviceDate;
    String servicePeriodStart;
    String servicePeriodEnd;
    int quantity;
    int numberOfDrugFills;  //applicable for pharma claims only
    int numberOfDaysSuppy;  //applicable for pharma claims only
    List<Adjudication> adjudications;

    BenefitEntryItem(HuJSON entryItemJson) {

        this.sequence = entryItemJson.getInt(EOBJsonStatics.ITEM_SEQUENCE_PATH);
        this.category = entryItemJson.getString(EOBJsonStatics.ITEM_CATEGORY_PATH);
        this.serviceCodeSystem = entryItemJson.getString(EOBJsonStatics.ITEM_SERVICE_CODE_SYSTEM_PATH);
        this.serviceCode = entryItemJson.getString(EOBJsonStatics.ITEM_SERVICE_CODE_PATH);
        this.serviceCodeDisplay = entryItemJson.getString(EOBJsonStatics.ITEM_SERVICE_CODE_DISPLAY_PATH);
        this.serviceDate = entryItemJson.getString(EOBJsonStatics.ITEM_SERVICE_DATE_PATH);
        this.servicePeriodStart = entryItemJson.getString(EOBJsonStatics.ITEM_SERVICE_PERIOD_START_PATH);
        this.servicePeriodEnd = entryItemJson.getString(EOBJsonStatics.ITEM_SERVICE_PERIOD_END_PATH);
        this.quantity = entryItemJson.getInt(EOBJsonStatics.ITEM_QUANTITY_PATH);

        //quantity extensions
        List<dynamic>  quantityExtensions =  entryItemJson.getArray(EOBJsonStatics.ITEM_QUANTITY_EXTENSION_PATH);
        if(quantityExtensions !=  null) {
          this.buildQuantityExtensions(quantityExtensions);
        }

        //adjudications
        List<dynamic>  adjudicationsJSON  = entryItemJson.getArray(EOBJsonStatics.ITEM_ADJUDICATION_PATH);
        this.adjudications = new List<Adjudication>();
        for (Map<String, dynamic> adjudicationJSON in adjudicationsJSON) {
            Adjudication adjudication = new Adjudication(new HuJSON(adjudicationJSON));
            this.adjudications.add(adjudication);
        }

    }

    buildQuantityExtensions(List<dynamic> quantityExtensions) {

      for (Map<String,dynamic> quantityExtension in quantityExtensions) {

            String url = quantityExtension[EOBJsonStatics.URL_ATTRIBUTE];
            HuJSON quantityExtensionJSON = new HuJSON(quantityExtension);

            int quantity = quantityExtensionJSON.getInt(EOBJsonStatics.ITEM_VALUE_QUANTITY_PATH);
            switch (url) {
                case EOBJsonStatics.FILL_NUM:
                    this.numberOfDrugFills = quantity;
                    break;
                case EOBJsonStatics.DAYS_SUPPLY:
                    this.numberOfDaysSuppy = quantity;
                    break;
                default:
                    break;
            }
        }

    }
}

class DiagniosisCode {

    String code;
    String system;
    String display;

    DiagniosisCode(HuJSON diagnosisCodingJSON) {

       this.code  = diagnosisCodingJSON.getString(EOBJsonStatics.DIAGNOSIS_CODE_PATH);
       this.system = diagnosisCodingJSON.getString(EOBJsonStatics.DIAGNOSIS_CODE_SYSTEM_PATH);
       this.display = diagnosisCodingJSON.getString(EOBJsonStatics.DIAGNOSIS_CODE_DISPLAY_PATH);
    }
}

class Adjudication {

    String category;
    String reason;
    double amount;

    Adjudication(HuJSON adjudicationJSON) {

        this.category = adjudicationJSON.getString(EOBJsonStatics.ITEM_ADJUDICATION_CATEGORY_CODING_PATH);
        this.reason   = adjudicationJSON.getString(EOBJsonStatics.ITEM_ADJUDICATION_REASON_PATH);
        this.amount   = adjudicationJSON.getDouble(EOBJsonStatics.ITEM_ADJUDICATION_AMOUNT_PATH);
    }
}
