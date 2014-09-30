public with sharing class V12_SendPostRequestController {
    public V12_SendPostRequestcontroller() {
        // do nothing
    }
    
    /*
     * Used to test functionality of sendRequest method.
     */
    public static void sendRequestWrapper() {
        system.debug('called sendRequest');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,sendRequest('123456789********************EOF', '916_file.txt')));
    }
    
    /*
     * The endpoint used is Mike's Google Cloud account test app. It only has one method 'sftp' which only accepts POST requests.
     * 
     *
     * Test SFTP credentials:
     *  host: stepat.net
     *  port: 22
     *  user: v12
     *  pass: justme1208
     * 
     * As of now the SFTP site is hard-coded into the Google Cloud app, so to change where it points you'll have to access that code.
     */
    public static String sendRequest(String str, String filename) {
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        
        String boundary = '-----AcbD0x5DeF';
        
        /*
         * Using hard-to-guess username and password + HTTP Basic Auth over SSL as authentication.
         */
        String username = 'de429a8a7a8405f289708f2257438cef';
        String password = '4725d97761adaad50661eab8b312a9f3';

        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        
        String body = '--' + boundary + '\n' + 'Content-Disposition: form-data; name="file"; filename="' 
                           + filename + '"\nContent-Type: text/plain\n\n'
                           + str + '\n--' + boundary + '--';
                          
        req.setEndpoint('https://reflected-jet-700.appspot.com/sftp');
        req.setHeader('Host', 'reflected-jet-700.appspot.com');
        req.setHeader('Content-Length', body.length()+'');
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
    
        //Set the HTTPRequest body 
        req.setBody(body);

        Http http = new Http();

        String ret = req.getBody();

        try {

            //Execute web service call here      
            HTTPResponse res = http.send(req);   
 
            //Helpful debug messages
            ret += res.toString() + '\n';
            ret += 'STATUS:'+res.getStatus() + '\n';
            ret += 'STATUS_CODE:'+res.getStatusCode();
        } catch(System.CalloutException e) {
            //Exception handling goes here....
            ret += e.getMessage();
        }
        
    return ret;
    }
}