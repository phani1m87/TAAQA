<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Number_of_Messages_Received</fullName>
        <field>Emails_Received_Count__c</field>
        <formula>IF(ISBLANK( Parent.Emails_Received_Count__c ), 1,  Parent.Emails_Received_Count__c +1)</formula>
        <name>Case: Number of Messages Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Sales411 new email received count</fullName>
        <actions>
            <name>Case_Number_of_Messages_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>counts the number of new emails received. Used for notification to owner of a new email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
