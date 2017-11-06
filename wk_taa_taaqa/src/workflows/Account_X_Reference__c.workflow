<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Engagement_45_Maintenance_False</fullName>
        <field>Engagement_45_Maintenance__c</field>
        <literalValue>0</literalValue>
        <name>Engagement 45% Maintenance False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Knowledge_Coach_Maintenance_flag_false</fullName>
        <field>Knowledge_Coach_45_Maintenance__c</field>
        <literalValue>0</literalValue>
        <name>Knowledge Coach Maintenance flag false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Engagement Maintenance Rate</fullName>
        <actions>
            <name>Engagement_45_Maintenance_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_X_Reference__c.Has_Engagement__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_X_Reference__c.Engagement_45_Maintenance__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Clears the 45% maintenance flag if the Has Engagement flags changes to false.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Knowledge Coach Maintenance</fullName>
        <actions>
            <name>Knowledge_Coach_Maintenance_flag_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_X_Reference__c.Has_Knowledge_Coach__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_X_Reference__c.Knowledge_Coach_45_Maintenance__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates the Knowledge Coach 45% maintenance flag to false when the Has Knowledge Coach flag changes to false</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
