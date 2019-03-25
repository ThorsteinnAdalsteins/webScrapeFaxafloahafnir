# # About this scraper
This script is designed to collect information from the websites of [Faxaflóahafnir](https://www.faxafloahafnir.is/en/) (Reykjavík Harbor)
The harbor has a lot of nice statistics regarding amount of cargo that passes through the port and associating ports. This data is available through Qlick-view interface, so there is no need to need to collect this dataset. They also have the number of passengers and other information. 

One of the information they do not have clearly available is the flag-state, and information (size information aside from brutto-tonnage, MMSI, IMO number etc) for the vessels that are coming through the harbor. Such information can be collected from sites like Fleetmon and Marine Traffic, as well as from the classification societies of the vessels in question. 

## About the structure
  - This is not an R package
  - Bits and pieces of the scripts are stored in the R_Sources folder
  - The main operation is done in the build script, which should be modified as needed
  - The data from the website is not included

## The data

The data on departure and arrival of vessel into Reykjavík Harbor is collected by the harbor authority of Iceland through Safeseanet notification requirements. The publication of arrival/departure information is a part of the public information requirements of the Reykjavík Harbor, but is kindly offered in an easily accessible manner.

The data regarding vessels call signals and engine structure is a part of the official notification requirements of classification societies, and not a property of Marine Traffic, Fleetmon or any other ship-location websites.
