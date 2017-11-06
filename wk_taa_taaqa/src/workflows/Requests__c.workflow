<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Prioritization_Status_to_Cancelled</fullName>
        <field>Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Prioritization Status to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prioritization_Status_to_Completed</fullName>
        <field>Prioritization_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Prioritization Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Prioritizied</fullName>
        <field>Date_Prioritized__c</field>
        <formula>TODAY()</formula>
        <name>Update Date Prioritizied</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Original_Due_Date</fullName>
        <field>Original_Due_Date__c</field>
        <formula>Current_Due_Date_Completion_Date__c</formula>
        <name>Update Original Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Date Prioritized</fullName>
        <actions>
            <name>Update_Date_Prioritizied</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Requests__c.Prioritization_Status__c</field>
            <operation>equals</operation>
            <value>Reviewed - Prioritized</value>
        </criteriaItems>
        <criteriaItems>
            <field>Requests__c.Date_Prioritized__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Prioritization Status to Cancelled</fullName>
        <actions>
            <name>Prioritization_Status_to_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Requests__c.Prioritization_Status__c</field>
            <operation>equals</operation>
            <value>Reviewed - Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Requests__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Prioritization Status to Completed</fullName>
        <actions>
            <name>Prioritization_Status_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Requests__c.Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Requests__c.Prioritization_Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Original Due Date</fullName>
        <actions>
            <name>Update_Original_Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Requests__c.Current_Due_Date_Completion_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Requests__c.Original_Due_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
