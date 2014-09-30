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
private class VOBControllerTest {


    static testMethod void testVOBController1()
    {
        System.Debug('Unit Test: testVOBController1');

        Case c = new Case ();
        insert c;

        VOB__c v = new VOB__c (caseid__c=c.Id);
        insert v;

        ApexPages.currentPage().getParameters().put('id', v.Id);
        VOBController vob_id = new VOBController();
        

    }

    static testMethod void testVOBController2()
    {
        System.Debug('Unit Test: testVOBController2');

        Case c = new Case (Funding_Type__c='Private Pay');
        insert c;

        VOB__c v = new VOB__c (caseid__c=c.Id, complete__c=true);
        insert v;

        ApexPages.currentPage().getParameters().put('caseid', c.Id);
        VOBController vob_caseid = new VOBController();
        
        vob_caseid.save();
        vob_caseid.updateCase();
        vob_caseid.getQueueId(c.Id);
        
        vob_caseid.checkCaseBeforePopulate(c);
    }

    static testMethod void testVOBController2a()
    {
        System.Debug('Unit Test: testVOBController2a');

        Case c = new Case (Funding_Type__c='Private Pay');
        insert c;
        
        VOB__c v = new VOB__c (caseid__c=c.Id);
        insert v;
        
        ApexPages.currentPage().getParameters().put('id', v.Id);
        VOBController vobid = new VOBController();
        vobid.updateCase();
                
    }

    static testMethod void testVOBController3()
    {
        System.Debug('Unit Test: testVOBController3');

        Case c = new Case ();
        insert c;

        ApexPages.currentPage().getParameters().put('caseid', c.Id);
        VOBController vob_caseid = new VOBController();
    }

    static testMethod void testVOBController4()
    {
        System.Debug('Unit Test: testVOBController4');

        VOBController vob_caseid = new VOBController();
        
        vob_caseid.PreSave();

    }

    static testMethod void testVOBController_save()
    {
        System.Debug('Unit Test: testVOBController_save');

        VOBController vob = new VOBController();
        
        vob.save();
        vob.getVob();
        vob.cancel();
        vob.gotocase();
        vob.getMessage();
        vob.getJsMessage();
        vob.getJsMessageURL();
        vob.updateCase();
        vob.PreSave();
               
    }


    static testMethod void testVOBController_functions()
    {
        Case c = new Case (Funding_Type__c='Private Pay');
        insert c;

        VOB__c v = new VOB__c (caseid__c=c.Id, OwnerId = UserInfo.getUserId(), complete__c=true);
        insert v;

        VOB__c v2 = new VOB__c (caseid__c=c.Id, complete__c=true);
        insert v2;

        ApexPages.currentPage().getParameters().put('id', v.Id);
        VOBController vob_id = new VOBController();
        

        vob_id.getVob();
        vob_id.save();
        vob_id.cancel();
        vob_id.gotocase();
        vob_id.getMessage();
        vob_id.getJsMessage();
        vob_id.getJsMessageURL();
        vob_id.updateCase();
        vob_id.PreSave();
        
        vob_id.checkCaseBeforePopulate(c);
        
        ApexPages.currentPage().getParameters().put('id', v2.Id);
        VOBController vob2_id = new VOBController();

        vob2_id.updateCase();
        vob2_id.PreSave();
        vob2_id.save();

        
    }

    static testMethod void testVOBController_exist()
    {
        Case c = new Case (Funding_Type__c='');
        insert c;

        ApexPages.currentPage().getParameters().put('caseid', c.Id);
        VOBController vob = new VOBController();
        
        vob.PreSave();        
    }
    
}