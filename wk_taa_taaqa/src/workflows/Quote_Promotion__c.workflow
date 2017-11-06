<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Attribute_Match_Update</fullName>
        <field>Account_Attribute_Match__c</field>
        <literalValue>1</literalValue>
        <name>Account Attribute Match Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Get_Description_from_Promo</fullName>
        <field>Description__c</field>
        <formula>Promotion__r.Description__c</formula>
        <name>Get Description from Promo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Todays_Date</fullName>
        <field>Today__c</field>
        <formula>TODAY ()</formula>
        <name>Set Todays Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Promo Description</fullName>
        <actions>
            <name>Get_Description_from_Promo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Promotion_Code__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Todays Date</fullName>
        <actions>
            <name>Set_Todays_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
