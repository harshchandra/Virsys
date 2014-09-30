//Generated by wsdl2apex

public class AvayaService2 {
    public class GetCallsByAgentExtensionAndDate_element {
        public String extension;
        public DateTime startDate;
        public DateTime endDate;
        private String[] extension_type_info = new String[]{'extension','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'extension','startDate','endDate'};
    }
    public class CallDetail {
        public String PhoneNumber;
        public String HuntGroup;
        public DateTime CallDate;
        public Long CallLength;
        public String AgentName;
        public Long CallId;
        public String DDI;
        public String Direction;
        public String AgentExtension;
        public Long CallCount;
        public Long TotalTalkTimeMinutes;
        private String[] PhoneNumber_type_info = new String[]{'PhoneNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] HuntGroup_type_info = new String[]{'HuntGroup','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CallDate_type_info = new String[]{'CallDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] CallLength_type_info = new String[]{'CallLength','http://www.w3.org/2001/XMLSchema','long','1','1','false'};
        private String[] AgentName_type_info = new String[]{'AgentName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CallId_type_info = new String[]{'CallId','http://www.w3.org/2001/XMLSchema','long','1','1','false'};
        private String[] DDI_type_info = new String[]{'DDI','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Direction_type_info = new String[]{'Direction','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AgentExtension_type_info = new String[]{'AgentExtension','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CallCount_type_info = new String[]{'CallCount','http://www.w3.org/2001/XMLSchema','long','1','1','false'};
        private String[] TotalTalkTimeMinutes_type_info = new String[]{'TotalTalkTimeMinutes','http://www.w3.org/2001/XMLSchema','long','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'PhoneNumber','HuntGroup','CallDate','CallLength','AgentName','CallId','DDI','Direction','AgentExtension','CallCount','TotalTalkTimeMinutes'};
    }
    public class GetCallsByAgentName_element {
        public String agentName;
        private String[] agentName_type_info = new String[]{'agentName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'agentName'};
    }
    public class GetCallsByAgentExtensionAndDateResponse_element {
        public AvayaService2.ArrayOfCallDetail GetCallsByAgentExtensionAndDateResult;
        private String[] GetCallsByAgentExtensionAndDateResult_type_info = new String[]{'GetCallsByAgentExtensionAndDateResult','http://tempuri.org/','ArrayOfCallDetail','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetCallsByAgentExtensionAndDateResult'};
    }
    public class GetCallsCountByAgentExtensionAndDateResponse_element {
        public AvayaService2.ArrayOfCallDetail GetCallsCountByAgentExtensionAndDateResult;
        private String[] GetCallsCountByAgentExtensionAndDateResult_type_info = new String[]{'GetCallsCountByAgentExtensionAndDateResult','http://tempuri.org/','ArrayOfCallDetail','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetCallsCountByAgentExtensionAndDateResult'};
    }
    public class GetCallsForNumberResponse_element {
        public AvayaService2.ArrayOfCallDetail GetCallsForNumberResult;
        private String[] GetCallsForNumberResult_type_info = new String[]{'GetCallsForNumberResult','http://tempuri.org/','ArrayOfCallDetail','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetCallsForNumberResult'};
    }
    public class GetCallsByAgentNameResponse_element {
        public AvayaService2.ArrayOfCallDetail GetCallsByAgentNameResult;
        private String[] GetCallsByAgentNameResult_type_info = new String[]{'GetCallsByAgentNameResult','http://tempuri.org/','ArrayOfCallDetail','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetCallsByAgentNameResult'};
    }
    public class GetCallsCountByAgentExtensionAndDate_element {
        public String extension;
        public DateTime startDate;
        public DateTime endDate;
        private String[] extension_type_info = new String[]{'extension','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'extension','startDate','endDate'};
    }
    public class GetUniqueCallsCountByAgentExtensionAndDateResponse_element {
        public AvayaService2.ArrayOfCallDetail GetUniqueCallsCountByAgentExtensionAndDateResult;
        private String[] GetUniqueCallsCountByAgentExtensionAndDateResult_type_info = new String[]{'GetUniqueCallsCountByAgentExtensionAndDateResult','http://tempuri.org/','ArrayOfCallDetail','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetUniqueCallsCountByAgentExtensionAndDateResult'};
    }
    public class GetUniqueCallsCountByDIDAndDateResponse_element {
        public AvayaService2.ArrayOfCallDetail GetUniqueCallsCountByDIDAndDateResult;
        private String[] GetUniqueCallsCountByDIDAndDateResult_type_info = new String[]{'GetUniqueCallsCountByDIDAndDateResult','http://tempuri.org/','ArrayOfCallDetail','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetUniqueCallsCountByDIDAndDateResult'};
    }
    
    public class QueryServiceSoap {
        public String endpoint_x = 'http://68.71.110.242/SFDC/QueryService.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'AvayaService2'};
        public AvayaService2.ArrayOfCallDetail GetUniqueCallsCountByAgentExtensionAndDate(String extension,DateTime startDate,DateTime endDate) {
            AvayaService2.GetUniqueCallsCountByAgentExtensionAndDate_element request_x = new AvayaService2.GetUniqueCallsCountByAgentExtensionAndDate_element();
            AvayaService2.GetUniqueCallsCountByAgentExtensionAndDateResponse_element response_x;
            request_x.extension = extension;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            Map<String, AvayaService2.GetUniqueCallsCountByAgentExtensionAndDateResponse_element> response_map_x = new Map<String, AvayaService2.GetUniqueCallsCountByAgentExtensionAndDateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetUniqueCallsCountByAgentExtensionAndDate',
              'http://tempuri.org/',
              'GetUniqueCallsCountByAgentExtensionAndDate',
              'http://tempuri.org/',
              'GetUniqueCallsCountByAgentExtensionAndDateResponse',
              'AvayaService2.GetUniqueCallsCountByAgentExtensionAndDateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetUniqueCallsCountByAgentExtensionAndDateResult;
        }
        public AvayaService2.ArrayOfCallDetail GetUniqueCallsCountByDIDAndDate(DateTime startDate,DateTime endDate) 
        {
            AvayaService2.GetUniqueCallsCountByDIDAndDate_element request_x = new AvayaService2.GetUniqueCallsCountByDIDAndDate_element();
            AvayaService2.GetUniqueCallsCountByDIDAndDateResponse_element response_x;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            Map<String, AvayaService2.GetUniqueCallsCountByDIDAndDateResponse_element> response_map_x = new Map<String, AvayaService2.GetUniqueCallsCountByDIDAndDateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetUniqueCallsCountByDIDAndDate',
              'http://tempuri.org/',
              'GetUniqueCallsCountByDIDAndDate',
              'http://tempuri.org/',
              'GetUniqueCallsCountByDIDAndDateResponse',
              'AvayaService2.GetUniqueCallsCountByDIDAndDateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetUniqueCallsCountByDIDAndDateResult;
        }
        
        public AvayaService2.ArrayOfCallDetail GetCallsByAgentExtension(String extension) {
            AvayaService2.GetCallsByAgentExtension_element request_x = new AvayaService2.GetCallsByAgentExtension_element();
            AvayaService2.GetCallsByAgentExtensionResponse_element response_x;
            request_x.extension = extension;
            Map<String, AvayaService2.GetCallsByAgentExtensionResponse_element> response_map_x = new Map<String, AvayaService2.GetCallsByAgentExtensionResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetCallsByAgentExtension',
              'http://tempuri.org/',
              'GetCallsByAgentExtension',
              'http://tempuri.org/',
              'GetCallsByAgentExtensionResponse',
              'AvayaService2.GetCallsByAgentExtensionResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetCallsByAgentExtensionResult;
        }
        public AvayaService2.ArrayOfCallDetail GetCallsByAgentName(String agentName) {
            AvayaService2.GetCallsByAgentName_element request_x = new AvayaService2.GetCallsByAgentName_element();
            AvayaService2.GetCallsByAgentNameResponse_element response_x;
            request_x.agentName = agentName;
            Map<String, AvayaService2.GetCallsByAgentNameResponse_element> response_map_x = new Map<String, AvayaService2.GetCallsByAgentNameResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetCallsByAgentName',
              'http://tempuri.org/',
              'GetCallsByAgentName',
              'http://tempuri.org/',
              'GetCallsByAgentNameResponse',
              'AvayaService2.GetCallsByAgentNameResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetCallsByAgentNameResult;
        }
        public AvayaService2.ArrayOfCallDetail GetCallsByAgentExtensionAndDate(String extension,DateTime startDate,DateTime endDate) {
            AvayaService2.GetCallsByAgentExtensionAndDate_element request_x = new AvayaService2.GetCallsByAgentExtensionAndDate_element();
            AvayaService2.GetCallsByAgentExtensionAndDateResponse_element response_x;
            request_x.extension = extension;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            Map<String, AvayaService2.GetCallsByAgentExtensionAndDateResponse_element> response_map_x = new Map<String, AvayaService2.GetCallsByAgentExtensionAndDateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetCallsByAgentExtensionAndDate',
              'http://tempuri.org/',
              'GetCallsByAgentExtensionAndDate',
              'http://tempuri.org/',
              'GetCallsByAgentExtensionAndDateResponse',
              'AvayaService2.GetCallsByAgentExtensionAndDateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetCallsByAgentExtensionAndDateResult;
        }
        public AvayaService2.ArrayOfCallDetail GetCallsForNumber(String number_x) {
            AvayaService2.GetCallsForNumber_element request_x = new AvayaService2.GetCallsForNumber_element();
            AvayaService2.GetCallsForNumberResponse_element response_x;
            request_x.number_x = number_x;
            Map<String, AvayaService2.GetCallsForNumberResponse_element> response_map_x = new Map<String, AvayaService2.GetCallsForNumberResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetCallsForNumber',
              'http://tempuri.org/',
              'GetCallsForNumber',
              'http://tempuri.org/',
              'GetCallsForNumberResponse',
              'AvayaService2.GetCallsForNumberResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetCallsForNumberResult;
        }
        public AvayaService2.ArrayOfCallDetail GetCallsCountByAgentExtensionAndDate(String extension,DateTime startDate,DateTime endDate) {
            AvayaService2.GetCallsCountByAgentExtensionAndDate_element request_x = new AvayaService2.GetCallsCountByAgentExtensionAndDate_element();
            AvayaService2.GetCallsCountByAgentExtensionAndDateResponse_element response_x;
            request_x.extension = extension;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            Map<String, AvayaService2.GetCallsCountByAgentExtensionAndDateResponse_element> response_map_x = new Map<String, AvayaService2.GetCallsCountByAgentExtensionAndDateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/GetCallsCountByAgentExtensionAndDate',
              'http://tempuri.org/',
              'GetCallsCountByAgentExtensionAndDate',
              'http://tempuri.org/',
              'GetCallsCountByAgentExtensionAndDateResponse',
              'AvayaService2.GetCallsCountByAgentExtensionAndDateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetCallsCountByAgentExtensionAndDateResult;
        }
    }
    public class GetCallsByAgentExtension_element {
        public String extension;
        private String[] extension_type_info = new String[]{'extension','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'extension'};
    }
    public class ArrayOfCallDetail {
        public AvayaService2.CallDetail[] CallDetail;
        private String[] CallDetail_type_info = new String[]{'CallDetail','http://tempuri.org/','CallDetail','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'CallDetail'};
    }
    public class GetCallsByAgentExtensionResponse_element {
        public AvayaService2.ArrayOfCallDetail GetCallsByAgentExtensionResult;
        private String[] GetCallsByAgentExtensionResult_type_info = new String[]{'GetCallsByAgentExtensionResult','http://tempuri.org/','ArrayOfCallDetail','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetCallsByAgentExtensionResult'};
    }
    public class GetUniqueCallsCountByAgentExtensionAndDate_element {
        public String extension;
        public DateTime startDate;
        public DateTime endDate;
        private String[] extension_type_info = new String[]{'extension','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'extension','startDate','endDate'};
    }
    public class GetUniqueCallsCountByDIDAndDate_element {
        public DateTime startDate;
        public DateTime endDate;
        private String[] startDate_type_info = new String[]{'startDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'startDate','endDate'};
    }
    
    public class GetCallsForNumber_element {
        public String number_x;
        private String[] number_x_type_info = new String[]{'number','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'number_x'};
    }

   private static testMethod void TestAvayaService2()
   {
   	Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock());
   	 Test.startTest();
   	 AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
     service.timeout_x = 90000;
 	 AvayaService2.ArrayOfCallDetail callRecords = service.GetCallsByAgentExtensionAndDate('1234',DateTime.newInstance(2013,4,1),DateTime.newInstance(2013,4,19));
 	 Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock2());
 	 AvayaService2.ArrayOfCallDetail callRecords2 = service.GetCallsByAgentExtension('1234');
 	 Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock3());
     AvayaService2.ArrayOfCallDetail callRecords3 = service.GetCallsByAgentName('boverlund');
     Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock4());
 	 AvayaService2.ArrayOfCallDetail callRecords4 = service.GetCallsForNumber('1234567890');
 	 Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock5()); 
 	 AvayaService2.ArrayOfCallDetail callRecords5 = service.GetCallsCountByAgentExtensionAndDate('1234',DateTime.newInstance(2013,4,1),DateTime.newInstance(2013,4,19));
 	 Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock6()); 
 	 AvayaService2.ArrayOfCallDetail callRecords6 = service.GetUniqueCallsCountByAgentExtensionAndDate('1234',DateTime.newInstance(2013,4,1),DateTime.newInstance(2013,4,19));
 	 Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock7()); 
 	 AvayaService2.ArrayOfCallDetail callRecords7 = service.GetUniqueCallsCountByDIDAndDate(DateTime.newInstance(2013,4,1),DateTime.newInstance(2013,4,19));
 	 
 	 Test.stopTest();
   }

   public class MyWebServiceMock implements WebServiceMock 
   {
       public void doInvoke(
                            Object stub,
                            Object request,
                            Map<String, Object> response,
                            String endpoint,
                            String soapAction,
                            String requestName,
                            String responseNS,
                            String responseName,
                            String responseType) 
                            {        
                            // Create response element from the autogenerated class.        
                            // Populate response element.        
                            // Add response element to the response parameter, as follows:
                            GetCallsByAgentExtensionAndDateResponse_element respElement = new GetCallsByAgentExtensionAndDateResponse_element();
                            respElement.GetCallsByAgentExtensionAndDateResult = new ArrayOfCallDetail();
                            response.put('response_x', respElement);
                            }
   }
   
   public class MyWebServiceMock2 implements WebServiceMock 
   {
       public void doInvoke(
                            Object stub,
                            Object request,
                            Map<String, Object> response,
                            String endpoint,
                            String soapAction,
                            String requestName,
                            String responseNS,
                            String responseName,
                            String responseType) 
                            {        
                            // Create response element from the autogenerated class.        
                            // Populate response element.        
                            // Add response element to the response parameter, as follows:
                            
                            GetCallsByAgentExtensionResponse_element respElement = new GetCallsByAgentExtensionResponse_element();
                            respElement.GetCallsByAgentExtensionResult = new ArrayOfCallDetail();
                            response.put('response_x', respElement);
                            }
   }
   
   public class MyWebServiceMock3 implements WebServiceMock 
   {
       public void doInvoke(
                            Object stub,
                            Object request,
                            Map<String, Object> response,
                            String endpoint,
                            String soapAction,
                            String requestName,
                            String responseNS,
                            String responseName,
                            String responseType) 
                            {        
                            // Create response element from the autogenerated class.        
                            // Populate response element.        
                            // Add response element to the response parameter, as follows:
                            
                            GetCallsByAgentNameResponse_element respElement = new GetCallsByAgentNameResponse_element();
                            respElement.GetCallsByAgentNameResult = new ArrayOfCallDetail();
                            response.put('response_x', respElement);
                            }
   }
   public class MyWebServiceMock4 implements WebServiceMock 
   {
       public void doInvoke(
                            Object stub,
                            Object request,
                            Map<String, Object> response,
                            String endpoint,
                            String soapAction,
                            String requestName,
                            String responseNS,
                            String responseName,
                            String responseType) 
                            {        
                            // Create response element from the autogenerated class.        
                            // Populate response element.        
                            // Add response element to the response parameter, as follows:
                            
                            GetCallsForNumberResponse_element respElement = new GetCallsForNumberResponse_element();
                            respElement.GetCallsForNumberResult = new ArrayOfCallDetail();
                            response.put('response_x', respElement);
                            }
   }
   
   public class MyWebServiceMock5 implements WebServiceMock 
   {
       public void doInvoke(
                            Object stub,
                            Object request,
                            Map<String, Object> response,
                            String endpoint,
                            String soapAction,
                            String requestName,
                            String responseNS,
                            String responseName,
                            String responseType) 
                            {        
                            // Create response element from the autogenerated class.        
                            // Populate response element.        
                            // Add response element to the response parameter, as follows:
                            GetCallsCountByAgentExtensionAndDateResponse_element respElement = new GetCallsCountByAgentExtensionAndDateResponse_element();
                            respElement.GetCallsCountByAgentExtensionAndDateResult = new ArrayOfCallDetail();
                            response.put('response_x', respElement);
                            }
   }
   
   public class MyWebServiceMock6 implements WebServiceMock 
   {
       public void doInvoke(
                            Object stub,
                            Object request,
                            Map<String, Object> response,
                            String endpoint,
                            String soapAction,
                            String requestName,
                            String responseNS,
                            String responseName,
                            String responseType) 
                            {        
                            // Create response element from the autogenerated class.        
                            // Populate response element.        
                            // Add response element to the response parameter, as follows:
                            GetUniqueCallsCountByAgentExtensionAndDateResponse_element respElement = new GetUniqueCallsCountByAgentExtensionAndDateResponse_element();
                            respElement.GetUniqueCallsCountByAgentExtensionAndDateResult = new ArrayOfCallDetail();
                            response.put('response_x', respElement);
                            }
   }
   
   public class MyWebServiceMock7 implements WebServiceMock 
   {
       public void doInvoke(
                            Object stub,
                            Object request,
                            Map<String, Object> response,
                            String endpoint,
                            String soapAction,
                            String requestName,
                            String responseNS,
                            String responseName,
                            String responseType) 
                            {        
                            // Create response element from the autogenerated class.        
                            // Populate response element.        
                            // Add response element to the response parameter, as follows:
                            GetUniqueCallsCountByDIDAndDateResponse_element respElement = new GetUniqueCallsCountByDIDAndDateResponse_element();
                            respElement.GetUniqueCallsCountByDIDAndDateResult = new ArrayOfCallDetail();
                            response.put('response_x', respElement);
                            }
   }
   
}