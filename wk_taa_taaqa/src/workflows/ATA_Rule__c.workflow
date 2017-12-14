<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_ATA_Rule_External_ID</fullName>
        <field>External_ID__c</field>
        <formula>TEXT(Rule_Type__c) + FieldSet__c +  Field_API_Name__c +  Sobject__c</formula>
        <name>Set ATA Rule External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set ATA Rule External ID</fullName>
        <actions>
            <name>Set_ATA_Rule_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ATA_Rule__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
