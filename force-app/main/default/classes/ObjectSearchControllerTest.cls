@isTest
public class ObjectSearchControllerTest {
    @isTest
    static void testlwc(){
        Account acc = TestDataFactory.createAccount();
        Contact con = TestDataFactory.createContact(acc.Id);
        
        String searchexpression = [SELECT Search_Expression__c from Contact where id=:con.Id].Search_Expression__c;
        ObjectSearchController.GetDB('Contact',searchexpression);
        ObjectSearchController.getFields('Contact');
    }
}