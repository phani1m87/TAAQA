<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Current_Software_Revenue_Update</fullName>
        <field>Current_Software_revenue__c</field>
        <formula>Total_Current_revenue__c</formula>
        <name>Current Software Revenue Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update Total Current revenue</fullName>
        <actions>
            <name>Current_Software_Revenue_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SFDC_Account__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
