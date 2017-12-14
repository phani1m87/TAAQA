<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_ATA_Geographic_Assignment_Externl_ID</fullName>
        <field>External_ID__c</field>
        <formula>Role_Name__c +  Latitude__c +  Longitude__c +  PostalCode__c +   County__c +  Region__c +  State__c +  Country__c</formula>
        <name>Set ATA Geographic Assignment Externl ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set ATA Geographic Assignment External ID</fullName>
        <actions>
            <name>Set_ATA_Geographic_Assignment_Externl_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ATA_Geographic_Assignment__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
