//Generated by wsdl2apex

public class EOI_IIB_SAPAddressDQService {
    public class Real_time_Services {
        //public String endpoint_x = 'http://taadvpp.wkgbssvcs.com/DataServices/servlet/webservices';
        public String endpoint_x = WK_Utility.ServiceIntegrations().IIB_DQAddressValidationURL__c;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse/input', 'EOI_IIB_AddressValidationRequest', 'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse_Suggestions/input', 'EOI_IIB_AddressSuggestionRequest', 'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse_Suggestions/output', 'EOI_IIB_AddressSuggestionResponse', 'http://www.businessobjects.com', 'EOI_IIB_SAPAddressDQService', 'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse/output', 'EOI_IIB_AddressValidationResponse'};
        public EOI_IIB_AddressValidationResponse.DataSet_element Service_Realtime_DQ_SAP_Address_Cleanse(EOI_IIB_AddressValidationRequest.Record_element[] Record,EOI_IIB_AddressValidationRequest.UUIDMetaDataRequestDataType UUIDMetaDataRequest) {
            EOI_IIB_AddressValidationRequest.DataSet_element request_x = new EOI_IIB_AddressValidationRequest.DataSet_element();
            request_x.Record = Record;
            request_x.UUIDMetaDataRequest = UUIDMetaDataRequest;
            EOI_IIB_AddressValidationResponse.DataSet_element response_x;
            Map<String, EOI_IIB_AddressValidationResponse.DataSet_element> response_map_x = new Map<String, EOI_IIB_AddressValidationResponse.DataSet_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'service=Service_Realtime_DQ_SAP_Address_Cleanse',
              'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse/input',
              'DataSet',
              'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse/output',
              'DataSet',
              'EOI_IIB_AddressValidationResponse.DataSet_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EOI_IIB_AddressSuggestionResponse.DataSet_element Service_Realtime_DQ_SAP_Address_Cleanse_Suggestions(EOI_IIB_AddressSuggestionRequest.Record_element[] Record,EOI_IIB_AddressSuggestionRequest.UUIDMetaDataRequestDataType UUIDMetaDataRequest) {
            EOI_IIB_AddressSuggestionRequest.DataSet_element request_x = new EOI_IIB_AddressSuggestionRequest.DataSet_element();
            request_x.Record = Record;
            request_x.UUIDMetaDataRequest = UUIDMetaDataRequest;
            EOI_IIB_AddressSuggestionResponse.DataSet_element response_x;
            Map<String, EOI_IIB_AddressSuggestionResponse.DataSet_element> response_map_x = new Map<String, EOI_IIB_AddressSuggestionResponse.DataSet_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'service=Service_Realtime_DQ_SAP_Address_Cleanse_Suggestions',
              'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse_Suggestions/input',
              'DataSet',
              'http://businessobjects.com/service/Service_Realtime_DQ_SAP_Address_Cleanse_Suggestions/output',
              'DataSet',
              'EOI_IIB_AddressSuggestionResponse.DataSet_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}