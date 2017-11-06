<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Blank_out_Demo_Status</fullName>
        <field>Demo_Status__c</field>
        <name>Blank out Demo Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_out_Demo_Type</fullName>
        <field>Demo_Type__c</field>
        <name>Blank out Demo Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_Event_Completed</fullName>
        <field>Demo_Completion_Date__c</field>
        <formula>NOW()</formula>
        <name>Mark Event Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Short_Notes_Events</fullName>
        <field>Short_Notes__c</field>
        <formula>Left( Description ,200)</formula>
        <name>Short Notes - Events</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Demo_Status</fullName>
        <field>Demo_Status__c</field>
        <literalValue>Scheduled</literalValue>
        <name>Update Demo Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Demo_Type</fullName>
        <field>Demo_Type__c</field>
        <literalValue>Sales Presentation</literalValue>
        <name>Update Demo Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Blank out Demo Type and Status</fullName>
        <actions>
            <name>Blank_out_Demo_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Blank_out_Demo_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.Event_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Event.Demo_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Event.Demo_Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Needed due to issue synching with LinkPoint - workflows fire even if criteria is not met. This workflow removes incorrect values from the field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mark Event Complete</fullName>
        <actions>
            <name>Mark_Event_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.Completed_Demo1__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a user selects the complete demo checbox on an Event, the Demo Completed Date and Time are stamped on the record.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Demo Status to Scheduled</fullName>
        <actions>
            <name>Update_Demo_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.Event_Type__c</field>
            <operation>equals</operation>
            <value>Demo - Professional,Demo - Corp. Direct,Demo - Corp. Indirect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event.Demo_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Demo Type to Sales Presentation</fullName>
        <actions>
            <name>Update_Demo_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.Event_Type__c</field>
            <operation>equals</operation>
            <value>Demo - Prof. Software,Demo - Corp. Direct,Demo - Corp. Indirect,Demo - R&amp;L</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event.Demo_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Short Notes - Events</fullName>
        <actions>
            <name>Short_Notes_Events</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(
ISBLANK(Description))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
