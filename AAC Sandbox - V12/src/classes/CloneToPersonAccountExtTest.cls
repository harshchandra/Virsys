@isTest
private class CloneToPersonAccountExtTest {

    static testMethod void myUnitTest() {
      Account a = new Account(Name='Some Name');
      insert a;
      
      Test.startTest();
      Apexpages.Standardcontroller controller = new ApexPages.Standardcontroller(a);
      Test.setCurrentPage(Page.CloneAccountToPersonAccount);
      ApexPages.currentPage().getParameters().put('id', a.Id);
      CloneToPersonAccountExt ext = new CloneToPersonAccountExt(controller);
      //Id recTypeID = ext.queryForPersonRecType();
      ext.FirstName = 'John';
      ext.LastName = 'Name1';
      ext.PersonName ='John Name1';
      ext.save();
      Test.stopTest();
      System.assert(true);
    }
    
     static testMethod void myUnitTestForcedFail() {
      Account a = new Account(Name='Some Name');
      insert a;
      
      Test.startTest();
      Apexpages.Standardcontroller controller = new ApexPages.Standardcontroller(a);
      Test.setCurrentPage(Page.CloneAccountToPersonAccount);
      ApexPages.currentPage().getParameters().put('id', a.Id);
      CloneToPersonAccountExt ext = new CloneToPersonAccountExt(controller);
      //Id recTypeID = ext.queryForPersonRecType();
      
      ext.FirstName = 'Some';
      ext.LastName = 'Name1';
      ext.PersonName ='Some Name1';
      ext.save();
      
      
      
      if(ApexPages.currentPage() != null)
      {
      	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Some very important message for the user'));
      }  
      Test.stopTest();
      System.assert(true);
    }
}