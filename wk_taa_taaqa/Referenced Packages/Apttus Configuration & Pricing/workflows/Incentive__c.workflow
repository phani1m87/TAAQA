<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SearchFieldUpdate</fullName>
        <description>Update the incentive search field with Incentive Number</description>
        <field>SearchField__c</field>
        <formula>IncentiveNumber__c</formula>
        <name>Search Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetIncentiveCode</fullName>
        <description>Set incentive code from the auto generated incentive number</description>
        <field>IncentiveCode__c</field>
        <formula>IncentiveNumberAuto__c</formula>
        <name>Set Incentive Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetIncentiveNumber</fullName>
        <description>Set incentive number from the auto generated incentive number</description>
        <field>IncentiveNumberText__c</field>
        <formula>IncentiveNumberAuto__c</formula>
        <name>Set Incentive Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>Search Field Update</fullName>
        <actions>
            <name>SearchFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Incentive__c.IncentiveNumber__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Populate an external Id search field with incentive number, so that side bar support can work with Incentive Number search</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Incentive Code</fullName>
        <actions>
            <name>SetIncentiveCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Incentive__c.IncentiveCode__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set incentive code for new incentives. The incentive code is auto generated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Incentive Number</fullName>
        <actions>
            <name>SetIncentiveNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Incentive__c.IncentiveNumberText__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set incentive number for new incentives. The incentive number is auto generated.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
