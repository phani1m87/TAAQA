<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_ATA_AssignmentType_Map_External_ID</fullName>
        <field>External_ID__c</field>
        <formula>Rule_Type__c +  FieldSet__c +  Field_API_Name__c +  Field_Value__c</formula>
        <name>Set ATA AssignmentType Map External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set ATA AssignmentType Map External ID</fullName>
        <actions>
            <name>Set_ATA_AssignmentType_Map_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ATA_AssignmentType_Map__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
