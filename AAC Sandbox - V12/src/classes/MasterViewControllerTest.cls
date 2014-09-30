/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class MasterViewControllerTest {

    private static testMethod void GenericTest() {
        Account a = new Account(firstname = 'john', lastname ='doh');
        insert a;
        
        Case c = new Case(AccountId = a.Id, Insurance_Status__c = 'Submitted',Status = '3- Pending Assessment Review & Approval',X1st_Policy_Insurance_Type__c = 'PPO');
        insert c;
        
        InsuranceVerificationForm__c i = new InsuranceVerificationForm__c(Case__c = c.Id, ClientName__c = 'John Doe');
        insert i;
        
        Assessment__c s = new Assessment__c(Case__c = c.Id);
        insert s;
        
        Transportation__c t = new Transportation__c(Case__c = c.Id);
        insert t;
        
        Payment_Arrangement__c p = new Payment_Arrangement__c(Case__c = c.Id);
        insert p;
        
        
        
        Test.startTest();
        MasterViewController con = new MasterViewController();
        List<MasterViewItem> items = con.getItems();
        
        con.sortExpression = 'CaseNumber';
        con.SortData();
        con.sortExpression = 'CaseStatus';
        con.SortData();
        con.sortExpression = 'CreatedDate';
        con.SortData();
        con.sortExpression = 'AccountName';
        con.SortData();
        con.sortExpression = 'InsuranceStatus';
        con.SortData();
        con.sortExpression = 'PolicyType';
        con.SortData();
        con.sortExpression = 'OwnerName';
        con.SortData();
        con.sortExpression = 'ParentAccountType';
        con.SortData();
        
        con.SortDataInsurance();
        con.SortDataAssessment();
        con.SortDataPaymentArrangement();
        
        
        System.assert(items.size() > 0);
        
        Test.stopTest();
    }
}