@isTest
private class PhonePageExtTest {
private static Account TestAccount;
public static testMethod void phonePageExtTest() 
{
  TestAccount = new Account(Name='Test');
  insert TestAccount;
  Test.startTest();
  Test.setCurrentPage(new PageReference('/apex/CallerRecordLocator?ANI=555-555-5555&DNIS=123-123-2134'));
  ApexPages.StandardController controller = new ApexPages.StandardController(TestAccount);
  PhonePageExt ext = new PhonePageExt(controller);
  
  
  ext.CallType = 'Test';
  ext.DisplayCallTypeFields();
  ext.CallType = 'Other';
  ext.DisplayCallTypeFields();
  ext.NoName = true;
  ext.DisplayNameFields();
  ext.NoName = false;
  ext.DisplayNameFields();
  
  ext.setNoName(false);
  ext.getNoName();
  
  ext.setOtherText('test');
  ext.getOtherText();
  
  
  ext.setScratchPad('test test test');
  ext.getScratchPad();
  
  ext.setCallType('Other');
  ext.getCallType();
  
  ext.setParentAccountId(TestAccount.Id);
  ext.getParentAccountId();
      
  ext.setCallerID('555-555-5555');
  ext.getCallerID();
  
  ext.setDID('555-555-5555');
  ext.getDID();
  
  ext.setFirstName('Jon');
  ext.getFirstName();
  
  ext.setLastName('Doe');
  ext.getLastName();
  
  ext.NewAccount();
  ext.NewContact();
  
  ext.NoName = true;
  ext.NewAccount();
  ext.NewContact();
  ext.CallerID = null;
  ext.NewAccount();
  ext.NewContact();
  
  ext.getCallTypes();
  
  Test.stopTest();
}
}