# Change log for: dmtd_vbmapp_data

## 1.0.1

* Added support for setting the X-DocType via DmtdFoundation.configure document_type: 'text' || 'html'
* Fixed a bug in the client_spec. It now specifies the correct organization id.
* Changed Client.new() to allow specification of the id or code and then be used throughout the API without needing to pull it from the server.

## 1.0.2

* Added an AssessmentReport class that simplifies the functionality of generating an IEP report

## 1.0.3

* Added language support

## 1.0.4

* Implemented the Guide's caching support

## 1.1.0

* Implemented the VB-Mapp controller's caching support
* Completely reworked the documentation to be 'yard'-style format
* Privatized the 'index' methods on guide & vbmapp as they really aren't needed publicly
* Minor bug fixes
 
## 1.1.1
 
* Standardized all type key attr_readers (i.e. chapter, section, sub_section, area, group, etc.) to return symbols instead of strings
 
## 1.1.2

* Added VbmappAreaQuestion fields: definition, objective, question_title 
