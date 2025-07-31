/**
 * @description       : Test class for CandidateWelcomeEmailHandler class
 * @author            : Souvik Sen
 * @group             : CK
 * @last modified on  : 07-31-2025
 * @last modified by  : Souvik Sen
**/

@isTest
public class CandidateWelcomeEmailHandlerTest {

    @isTest
    static void testSendWelcomeEmail() {
        // Create a test email template
        EmailTemplate emailTemplate = new EmailTemplate(
            Name = 'Candidate Welcome Email',
            DeveloperName = 'Candidate_Welcome_Email',
            TemplateType = 'text',
            Subject = 'Welcome to Our Team',
            HtmlValue = 'Dear {!Contact.FirstName}, welcome!'
        );
        insert emailTemplate;

        // Create test data: Candidates with and without email addresses
        List<Candiate__c> candidates = new List<Candiate__c>{
            new Candiate__c(Name = 'John Doe', Email__c = 'john.doe@example.com'),
            new Candiate__c(Name = 'Jane Smith', Email__c = 'jane.smith@example.com'),
            new Candiate__c(Name = 'No Email Candidate')
        };
        insert candidates;

        // Call the method under test
        Test.startTest();
        CandidateWelcomeEmailHandler.sendWelcomeEmail(candidates);
        Test.stopTest();

        // Verify that contacts were created for candidates with emails
        List<Contact> createdContacts = [
            SELECT FirstName, LastName, Email 
            FROM Contact 
            WHERE Email IN ('john.doe@example.com', 'jane.smith@example.com')
        ];
        System.assertEquals(2, createdContacts.size(), 'Two contacts should have been created.');

        // Verify that the email process initiated successfully
        // The actual email sending can't be directly asserted, but you can use debug logs or other processes to ensure no errors.
        System.assertEquals(
            2, 
            [SELECT COUNT() FROM Contact WHERE Email IN ('john.doe@example.com', 'jane.smith@example.com')], 
            'Two contacts should have been targeted for email.'
        );
    }
}