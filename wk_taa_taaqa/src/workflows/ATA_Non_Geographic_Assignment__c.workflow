<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_ATA_Non_Geographic_Assign_Externl_ID</fullName>
        <field>External_ID__c</field>
        <formula>FieldName__c +  FieldValue__c +  RoleName__c +  DTN__c +  TEXT(Type__c)</formula>
        <name>Set ATA Non Geographic Assign Externl ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set ATA Non Geographic Assignment External ID</fullName>
        <actions>
            <name>Set_ATA_Non_Geographic_Assign_Externl_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ATA_Non_Geographic_Assignment__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
