<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>APTS_Update_IPP12_Addendum</fullName>
        <field>Generate_IPP12_Payment_Term_Verbiage__c</field>
        <literalValue>1</literalValue>
        <name>Update IPP 12 Addendum</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_IPP_12_Addendum</fullName>
        <field>Generate_IPP12_Payment_Term_Verbiage__c</field>
        <literalValue>1</literalValue>
        <name>Update IPP 12 Addendum</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_IPP_4_Addendum</fullName>
        <description>Update IPP4 Addendum flag on quote header when record exist for term detail</description>
        <field>Generate_IPP4_Payment_Term_Addendum__c</field>
        <literalValue>1</literalValue>
        <name>Update IPP 4 Addendum</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_IPP_6_Addendum</fullName>
        <field>Generate_IPP6_Payment_Term_Addendum__c</field>
        <literalValue>1</literalValue>
        <name>Update IPP 6 Addendum</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Initial_Deposit</fullName>
        <field>APTS_Initial_Deposit__c</field>
        <formula>APTS_Payment_Term_Total__c * 0.05 + APTS_Payment_Term_Total__c / 4</formula>
        <name>Update Initial Deposit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Quote_Flex_Pay_Addendum</fullName>
        <field>Generate_Payment_Term_Addendum_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Quote Flex Pay Addendum</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_deposit_amount_to_payment_term</fullName>
        <field>APTS_Initial_Deposit__c</field>
        <formula>Minimum_Deposit_Amount__c</formula>
        <name>Add deposit amount to payment term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FlexPay_Payment_Term</fullName>
        <field>Generate_Payment_Term_Addendum_Flag__c</field>
        <literalValue>1</literalValue>
        <name>FlexPay Payment Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FlexPay_Payment_Term2</fullName>
        <field>Generate_Payment_Term_Addendum_Flag__c</field>
        <literalValue>0</literalValue>
        <name>FlexPay Payment Term2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPP12_Payment_Term</fullName>
        <field>Generate_IPP12_Payment_Term_Verbiage__c</field>
        <literalValue>1</literalValue>
        <name>IPP12 Payment Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPP12_Payment_Term2</fullName>
        <field>Generate_IPP12_Payment_Term_Verbiage__c</field>
        <literalValue>0</literalValue>
        <name>IPP12 Payment Term2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPP4_Payment_Term</fullName>
        <field>Generate_IPP4_Payment_Term_Addendum__c</field>
        <literalValue>1</literalValue>
        <name>IPP4 Payment Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPP4_Payment_Term2</fullName>
        <field>Generate_IPP4_Payment_Term_Addendum__c</field>
        <literalValue>0</literalValue>
        <name>IPP4 Payment Term2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPP6_Payment_Term</fullName>
        <field>Generate_IPP6_Payment_Term_Addendum__c</field>
        <literalValue>1</literalValue>
        <name>IPP6 Payment Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPP6_Payment_Term2</fullName>
        <field>Generate_IPP6_Payment_Term_Addendum__c</field>
        <literalValue>0</literalValue>
        <name>IPP6 Payment Term2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>APTS_Quote_Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Deposit</fullName>
        <field>APTS_Initial_Deposit__c</field>
        <formula>Minimum_Deposit_Amount__c</formula>
        <name>Initial Deposit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Deposit_Date</fullName>
        <field>APTS_Initial_Deposit_Date__c</field>
        <formula>Today()</formula>
        <name>Initial Deposit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Final_Installment</fullName>
        <field>Final_Installment_Amount_2__c</field>
        <formula>IF(  ISPICKVAL(APTS_Quote_Proposal__r.Order_Type__c, &apos;AMS&apos;) ,  IF( OR( ISPICKVAL(APTS_Payment_Term__c, &apos;Flex Pay&apos;) , ISPICKVAL(APTS_Payment_Term__c, &apos;IPP 4&apos;) ),  IF((APTS_Instalment_Amount__c*3) &gt; APTS_Pending_Amount__c, APTS_Pending_Amount__c*2 - APTS_Instalment_Amount__c*5, null) , null) , null)</formula>
        <name>Update Final Installment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Initial_Deposit_Date</fullName>
        <field>APTS_Initial_Deposit_Date__c</field>
        <formula>APTS_Quote_Proposal__r.Order_Creation_Date__c</formula>
        <name>Update Initial Deposit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Initial_Deposit_Date1</fullName>
        <field>APTS_Initial_Deposit_Date__c</field>
        <formula>APTS_Quote_Proposal__r.Annual_Start_Date__c</formula>
        <name>Update Initial Deposit Date1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Final Installment Amount</fullName>
        <actions>
            <name>Update_Final_Installment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>AMS</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Flex Pay Addendum</fullName>
        <actions>
            <name>APTS_Update_Quote_Flex_Pay_Addendum</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Flex Pay Addendum when record exist in Payment Term Detail</description>
        <formula>/* and(ISCHANGED(APTS_Initial_Deposit__c), ISPICKVAL(APTS_Payment_Term__c, &apos;Flex Pay&apos;),  ISPICKVAL(APTS_Quote_Proposal__r.Order_Type__c, &apos;AMS&apos;) ) */ and(ISPICKVAL(APTS_Payment_Term__c, &apos;Flex Pay&apos;),  ISPICKVAL(APTS_Quote_Proposal__r.Order_Type__c, &apos;AMS&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPP 12 Addendum</fullName>
        <actions>
            <name>APTS_Update_IPP12_Addendum</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set IPP 12 Addendum when record exist in Payment Term Detail</description>
        <formula>and(ISPICKVAL(APTS_Payment_Term__c, &apos;IPP 12&apos;),  ISPICKVAL(APTS_Quote_Proposal__r.Order_Type__c, &apos;AMS&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPP 4 Addendum</fullName>
        <actions>
            <name>APTS_Update_IPP_4_Addendum</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set IPP 4 Addendum when record exist in Payment Term Detail</description>
        <formula>and(ISPICKVAL(APTS_Payment_Term__c, &apos;IPP 4&apos;),  ISPICKVAL(APTS_Quote_Proposal__r.Order_Type__c, &apos;AMS&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPP 6 Addendum</fullName>
        <actions>
            <name>APTS_Update_IPP_6_Addendum</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set IPP 6 Addendum when record exist in Payment Term Detail</description>
        <formula>and(ISPICKVAL(APTS_Payment_Term__c, &apos;IPP 6&apos;),  ISPICKVAL(APTS_Quote_Proposal__r.Order_Type__c, &apos;AMS&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Initial Deposit</fullName>
        <actions>
            <name>Initial_Deposit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Initial_Deposit_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>APTS_Payment_Term_Detail__c.APTS_Initial_Deposit__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>APTS_Payment_Term_Detail__c.APTS_Payment_Term__c</field>
            <operation>equals</operation>
            <value>Flex Pay</value>
        </criteriaItems>
        <criteriaItems>
            <field>APTS_Payment_Term_Detail__c.APTS_Payment_Term__c</field>
            <operation>equals</operation>
            <value>IPP 4</value>
        </criteriaItems>
        <criteriaItems>
            <field>APTS_Payment_Term_Detail__c.APTS_Payment_Term__c</field>
            <operation>equals</operation>
            <value>IPP 6</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Initial Deposit Date - AMS</fullName>
        <actions>
            <name>Update_Initial_Deposit_Date1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISBLANK(PRIORVALUE( APTS_Initial_Deposit_Date__c )), APTS_Quote_Proposal__r.RecordType.Name =&quot;AMS Proposal&quot;,OR( ISPICKVAL(APTS_Payment_Term__c ,&quot;Flex Pay&quot;),ISPICKVAL(APTS_Payment_Term__c,&quot;IPP 6&quot;),ISPICKVAL(APTS_Payment_Term__c,&quot;IPP 4&quot;),ISPICKVAL(APTS_Payment_Term__c,&quot;IPP 12&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set default deposit amount</fullName>
        <actions>
            <name>Add_deposit_amount_to_payment_term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>APTS_Payment_Term_Detail__c.APTS_Payment_Term__c</field>
            <operation>equals</operation>
            <value>Flex Pay,Net 30,IPP 4,IPP 6,IPP 12</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
