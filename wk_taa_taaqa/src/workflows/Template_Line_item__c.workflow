<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AMS_Product_Category</fullName>
        <field>AMS_Product_Category__c</field>
        <formula>IF(Proposal_Line_Item__c  &lt;&gt; &apos;&apos; , IF( Line_Type__c = &apos;Option&apos;, TEXT(  Proposal_Line_Item__r.Apttus_QPConfig__OptionId__r.AMS_Product_Category__c  ),&apos;aaa&apos;), &apos;&apos;)</formula>
        <name>AMS Product Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Template Line Type</fullName>
        <actions>
            <name>AMS_Product_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Template_Line_item__c.Option_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
