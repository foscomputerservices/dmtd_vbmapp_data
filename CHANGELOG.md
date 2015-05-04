# Change log for: dmtd_vbmapp_data

## 1.0.1

* Added support for setting the X-DocType via DmtdFoundation.configure document_type: 'text' || 'html'
* Fixed a bug in the client_spec. It now specifies the correct organization id.
* Changed Client.new() to allow specification of the id or code and then be used throughout the API without needing to pull it from the server.