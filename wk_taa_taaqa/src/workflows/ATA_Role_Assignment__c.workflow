<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_ATA_Role_Assignment_External_ID</fullName>
        <field>External_ID__c</field>
        <formula>Assignment_Type__c +  TEXT(Role_Assignment_Type__c) +  Role_Name__c +  TEXT(Assignment_Mechanism__c) +  Account_FieldName_Nongeographic__c</formula>
        <name>Set ATA Role Assignment External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set ATA Role Assignment External ID</fullName>
        <actions>
            <name>Set_ATA_Role_Assignment_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ATA_Role_Assignment__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
