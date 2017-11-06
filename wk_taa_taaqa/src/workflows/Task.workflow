<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mark_Task_Completed</fullName>
        <field>Demo_Completion_Date__c</field>
        <formula>NOW()</formula>
        <name>Mark Task Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_GA_Contact_Checkbox</fullName>
        <field>Gain_Access_Contact__c</field>
        <literalValue>1</literalValue>
        <name>Populate GA Contact Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Short_Notes_Tasks</fullName>
        <field>Short_Notes__c</field>
        <formula>LEFT(Description,200)</formula>
        <name>Short Notes - Tasks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate GA Contact Checkbox</fullName>
        <actions>
            <name>Populate_GA_Contact_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>Gain Access Call - Contact Made</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Short Notes - Tasks</fullName>
        <actions>
            <name>Short_Notes_Tasks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(
ISBLANK(Description))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
