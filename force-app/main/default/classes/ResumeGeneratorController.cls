/**
 * @description       : controller class generting resume for candidate
 * @author            : Souvik Sen
 * @group             : CK
 * @last modified on  : 07-31-2025
 * @last modified by  : Souvik Sen
**/
public class ResumeGeneratorController {
    /**
    * @description This method is used to generate resume for candidate
    * @author Souvik Sen | 07-31-2025 
    * @param candidateId 
    **/
    @AuraEnabled
    public static void generateResume(String candidateId){
        try {
            Candiate__c candidate = [SELECT Id, Name, Email__c, Mobile__c, Work_Experience__c, Education__c, Skills_And_Certifications__c 
                                       FROM Candiate__c WHERE Id = :candidateId WITH SYSTEM_MODE];
            
            PageReference pdfPage = Page.Candidate_Resume; // Replace with your Visualforce page name
            pdfPage.getParameters().put('id', candidate.Id);
            Blob pdfBlob = pdfPage.getContentAsPDF();
            
            Attachment resumeAttachment = new Attachment();
            resumeAttachment.Name = candidate.Name + '_Resume.pdf';
            resumeAttachment.Body = pdfBlob;
            resumeAttachment.ParentId = candidate.Id;
            resumeAttachment.ContentType = 'application/pdf';
            insert resumeAttachment;
        } catch (Exception e) {
            System.debug('Error in resume generation: ' + e.getMessage());
            throw new AuraHandledException('Resume generation failed. ' + e.getMessage());
        }
    }
}