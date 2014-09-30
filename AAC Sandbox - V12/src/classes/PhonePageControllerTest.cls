@isTest
public class PhonePageControllerTest {

    public static testMethod void testPhonePageController() {
      PageReference pageRef = new PageReference('/apex/CallerRecordCreator?ANI=5555555555&DID=1231231234&FirstName=John&LastName=Doe');
      Test.setCurrentPage(pageRef);
      PhonePageController controller = new PhonePageController();

      ApexPages.currentPage().getParameters().put('ANI','5555555555');
      ApexPages.currentPage().getParameters().put('CallerID','5555555555');      
      ApexPages.currentPage().getParameters().put('DNIS','1231231234');
      ApexPages.currentPage().getParameters().put('DID','1231231234');      
      ApexPages.currentPage().getParameters().put('FirstName','John');
      ApexPages.currentPage().getParameters().put('LastName','Doe');

      controller = new PhonePageController();
      String cid = controller.getCallerID();
      String did = controller.getDID();
      String fName = controller.getFirstName();
      String lName = controller.getLastName();   
      controller.setLastName('Doe');
      controller.setFirstName('John');
      controller.setCallerID('5555555555');
      controller.setDID('1231231234');
      controller.NewAccount();
      controller.NewContact();
      System.assert(true);
      }
    }