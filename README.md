# HuMed

HuMed is a Mobile app built using Flutter.io framework,that pulls Medicare(PartA,B and D) data using CMS Blue Button API. 

This repo has reference code that demonstartes the CMS BlueButton API's oAuth and data retrieval into a Flutter Mobile App. 

The codeis no where close to production quality and it neeeds lot of love and refactoring!.  The FHIR data formats of the API are evolving and the JSON parsing has lot of room for improvement. 

The app can be run in VS Code using a simulator (you need replace clientId in /lib/utils/constants.dart with yours). You can use one of the test users like BBUser29999 (password: PW29999!)

For more info on CMS BlueButton API: https://bluebutton.cms.gov/developers/ 
