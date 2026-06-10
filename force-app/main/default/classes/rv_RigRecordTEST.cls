// Test Class to create a Customer and Rig record
@IsTest
public class rv_RigRecordTEST {
  @TestSetup
  static void accountData() {
    // Create a Person Account
    Id personRT = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Person Account')
      .getRecordTypeid();
    Account personCustomer = new Account(
      RecordTypeId = personRT,
      FirstName = 'Test',
      LastName = 'Customer'
    );
    insert personCustomer;
  }

  @IsTest
  static void validateCustomer() {
    // Validate that the person account was created
    Test.startTest();
    Account cpa = [SELECT Id, Name FROM Account LIMIT 1];
    Test.stopTest();

    System.assertEquals(
      'Test Customer',
      cpa.Name,
      'Person Account name should be Test Customer'
    );
  }
}
