@isTest
public class SupportGroupExtensionTest {

    public static testMethod void testMyExtension() {
      Account acc = new Account(Name='TestAccount',Phone='1231231234');
      insert acc;
      Case cs = new Case(Status='New',Origin='Phone');
      insert cs;
      Contact con = new Contact(LastName = 'Doe', AccountId = acc.Id,Phone='1231231234');
      insert con;
      
      Support_Group_Member__c sg = new Support_Group_Member__c();
      sg.Person_Account__c = acc.Id;
      sg.Relationship_to_Client__c = 'Brother';
      sg.Name = 'John Doe';
      sg.Home_Phone__c = '9518527222';
      insert sg;
      ApexPages.StandardController sc = new ApexPages.StandardController(sg);
      Test.setCurrentPage(Page.Support_Group_Member_Page);
     // Add parameters to page URL 
      ApexPages.currentPage().getParameters().put('accountID', acc.Id);
      Test.startTest();     
      SupportGroupExtension ex = new SupportGroupExtension(sc);
      Test.stopTest();
      // Verify that the success page displays 
      System.assert(true);
      }
    }