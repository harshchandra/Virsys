@isTest
private class MasterAccountRelatedCasesListExtTest {

public  static testMethod void testMasterAccountRelatedCasesListExt() {
      List<Case> cases = new List<Case>();
      Account a= new Account(FirstName ='Jon',LastName='Doe');
      insert a;
      
      Case c= new Case(AccountId = a.Id);
      insert c;
      
      cases.add(c);
      
      ApexPages.StandardController controller = new ApexPages.StandardController(a);
      MasterAccountRelatedCasesListExt ext = new  MasterAccountRelatedCasesListExt(controller);
      Test.startTest();
      ext.cases = cases;
      System.assert(ext.cases.size() > 0);
      Test.stopTest();
    }
}