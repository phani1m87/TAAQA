<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Data_Request_Notification</fullName>
        <description>Account Data Request Closure Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Data_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Account_Data_Request_Submitted</fullName>
        <description>Account Data Request Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Data_Request_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Data_Request_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved - Completed</literalValue>
        <name>Account Data Request Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Data_Request_Recalled</fullName>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Account Data Request Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Data_Request_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Account Data Request Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Data_Request_Scheduled</fullName>
        <field>Status__c</field>
        <literalValue>Approved - Update Scheduled</literalValue>
        <name>Account Data Request-Scheduled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Data_Request_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Account Data Request Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Data_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Account Data Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Data Request Completed</fullName>
        <actions>
            <name>Account_Data_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Data_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved - Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Data Request Scheduled</fullName>
        <actions>
            <name>Account_Data_Request_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Segment/SubSegment Change
Approved - Completed</description>
        <formula>AND( ISPICKVAL( Request_Type__c , &quot;Segment/SubSegment Change&quot;),      ISPICKVAL( Status__c , &quot;Approved - Completed&quot;),      PRIORVALUE(  Status__c  ) = &quot;In Progress&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Data Request Status Update</fullName>
        <actions>
            <name>Account_Data_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Data_Request__c.Assigned_Technician__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates status to in process when technician  is selected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
