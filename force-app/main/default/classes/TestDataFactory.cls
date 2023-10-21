@isTest
public class TestDataFactory {
    public static Account createAccount() {
        String uid = [SELECT Id from User where profile.Name='System Administrator' LIMIT 1].Id;
        Account acc = new Account();
        acc.name='Test Account';
        acc.Type='Prospect';
        acc.AccountSource='Web';
        acc.OwnerId=uid;
        insert acc;
        return acc;
    }
    public static Contact createContact(Id accountId) {
		Contact ct = new Contact();
        ct.FirstName='Test';
        ct.LastName='Contact';
        ct.AccountId=accountId;
        ct.Email='testcontact@gmail.com';
        ct.Title='SVP, Operations';
        ct.MailingCity='Lawrence';
        ct.MailingCountry='USA';
        insert ct;
		return ct;
	}    
        
}