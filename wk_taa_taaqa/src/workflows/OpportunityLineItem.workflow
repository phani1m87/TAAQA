<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Exclude_From_reporting</fullName>
        <field>Include_in_Reporting__c</field>
        <literalValue>0</literalValue>
        <name>Exclude From reporting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Include_PAYP_in_opp_amount</fullName>
        <field>Include_in_Reporting__c</field>
        <literalValue>1</literalValue>
        <name>Include PAYP in opp amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Total_Price_to_Net_Price</fullName>
        <field>UnitPrice</field>
        <formula>NetPrice__c</formula>
        <name>Set Total Price to Net Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_Price</fullName>
        <field>UnitPrice</field>
        <formula>0</formula>
        <name>Update Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_iFirm_Monthly</fullName>
        <field>UnitPrice</field>
        <formula>UnitPrice * 12</formula>
        <name>Update iFirm Monthly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Zero_Net_Price</fullName>
        <field>NetPrice__c</field>
        <formula>0</formula>
        <name>Zero Net Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Zero_Total_Price</fullName>
        <field>OptionPrice__c</field>
        <formula>0</formula>
        <name>Zero Total Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update iFirm Monthly</fullName>
        <actions>
            <name>Update_iFirm_Monthly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.iFirm_Monthly__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates the Line Item amount for iFirm monthly products.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Zero Opportunity Amount</fullName>
        <actions>
            <name>Exclude_From_reporting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sales_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Zero_Net_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Zero_Total_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7</booleanFilter>
        <criteriaItems>
            <field>Product2.Zero_Opportunity_Amount__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Description</field>
            <operation>equals</operation>
            <value>Software Shipping/Download</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Description</field>
            <operation>equals</operation>
            <value>SOFTWARE DELIVERY/DOWNLOAD</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Description</field>
            <operation>equals</operation>
            <value>Shipping (within Continental USA only)</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Description</field>
            <operation>equals</operation>
            <value>Tax Delivery/Download</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Description</field>
            <operation>equals</operation>
            <value>WRKPR MGR DELIVERY/DOWNLOAD</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Description</field>
            <operation>contains</operation>
            <value>Delivery/Download</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
