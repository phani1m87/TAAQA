<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_RT_to_Completed</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Completed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set to Completed</fullName>
        <actions>
            <name>Set_RT_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Policy_Acknowledgement__c.Signature__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
