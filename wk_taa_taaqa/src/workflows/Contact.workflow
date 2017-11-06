<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Default_Contact_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>data.administrator@wolterskluwer.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Contact Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Informatica_Field_Update_Time</fullName>
        <field>SFS_Informatica_Field_Update_Time__c</field>
        <formula>NOW()</formula>
        <name>Informatica Field Update Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SFDC_Contact_Text</fullName>
        <field>SFDC_Contact_Text__c</field>
        <formula>SFDC_Contact__c</formula>
        <name>Update SFDC Contact Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SFS Informatica Field Update Time</fullName>
        <actions>
            <name>Informatica_Field_Update_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(LastName)  ||  ISCHANGED(FirstName)  ||  ISCHANGED(Phone)  ||  ISCHANGED(Email)  ||  ISCHANGED(DoNotCall)  ||  ISCHANGED(Is_Primary__c)  ||  ISCHANGED(Mobile_DNC_Reason__c)  ||  ISCHANGED(Mobile_DNC__c)  ||  ISCHANGED(Phone_DNC_Reason__c)  ||  ISCHANGED(Phone_DNC__c)  ||  ISCHANGED(DNC_Last_Modified_Filename__c)  ||  ISCHANGED(SFDC_Contact__c)  ||  ISCHANGED(AccountId)  ||  ISCHANGED(SFS_Contact_Record_ID__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact Owner to Default</fullName>
        <actions>
            <name>Default_Contact_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.OwnerId</field>
            <operation>notEqual</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update SFDC Contact %23</fullName>
        <actions>
            <name>Update_SFDC_Contact_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.SFDC_Contact__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
