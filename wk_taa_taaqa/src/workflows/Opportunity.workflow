<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AMS_Analyst_Corrected_Billing</fullName>
        <description>AMS Analyst Corrected - Billing</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Billing_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Analyst_Processor_Corrected</template>
    </alerts>
    <alerts>
        <fullName>AMS_Analyst_Corrected_Processing</fullName>
        <description>AMS Analyst Corrected - Processing</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Order_Processor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Analyst_Processor_Corrected</template>
    </alerts>
    <alerts>
        <fullName>AMS_Order_Analysis</fullName>
        <description>AMS Order Analysis</description>
        <protected>false</protected>
        <recipients>
            <recipient>AMS_Order_Validation</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Order_Validation_Stage</template>
    </alerts>
    <alerts>
        <fullName>AMS_Order_Processing</fullName>
        <ccEmails>tc-orders@wolterskluwer.com</ccEmails>
        <ccEmails>taaordermanagement@wolterskluwer.com</ccEmails>
        <description>AMS Order Processing</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Order_Processing_Stage</template>
    </alerts>
    <alerts>
        <fullName>AMS_Order_Return</fullName>
        <description>AMS Order Return</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Order_Return</template>
    </alerts>
    <alerts>
        <fullName>AMS_Processor_Corrected_Analysis</fullName>
        <description>AMS Processor Corrected - Analysis</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Billing_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Analyst_Processor_Corrected</template>
    </alerts>
    <alerts>
        <fullName>AMS_Processor_Corrected_Billing</fullName>
        <description>AMS Processor Corrected - Billing</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Billing_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Analyst_Processor_Corrected</template>
    </alerts>
    <alerts>
        <fullName>AMS_Ready_for_Billing</fullName>
        <description>AMS Ready for Billing</description>
        <protected>false</protected>
        <recipients>
            <recipient>AMS_Billing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Order_Billing_Stage</template>
    </alerts>
    <alerts>
        <fullName>AMS_Rep_Corrected_Analysis</fullName>
        <description>AMS Rep Corrected Analysis</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Order_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Rep_Corrected</template>
    </alerts>
    <alerts>
        <fullName>AMS_Rep_Corrected_Billing</fullName>
        <description>AMS Rep Corrected Billing</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Billing_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Rep_Corrected</template>
    </alerts>
    <alerts>
        <fullName>AMS_Rep_Corrected_Processing</fullName>
        <description>AMS Rep Corrected Processing</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Order_Processor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Rep_Corrected</template>
    </alerts>
    <alerts>
        <fullName>AMS_Return_to_Order_Analysis</fullName>
        <description>AMS Return to Order Analysis</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Order_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Return_To_Order_Analysis_Stage</template>
    </alerts>
    <alerts>
        <fullName>AMS_Return_to_Order_Processing</fullName>
        <description>AMSReturn to Order Processing</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Order_Processor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/AMS_Return_To_Order_Processing_Stage</template>
    </alerts>
    <alerts>
        <fullName>National_Order_Complete</fullName>
        <description>National Order Complete</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/National_Order_Complete</template>
    </alerts>
    <alerts>
        <fullName>National_T_C_Consultant_Notofication</fullName>
        <description>National T&amp;C Consultant Notofication</description>
        <protected>false</protected>
        <recipients>
            <field>T_C_Consultant__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/National_T_C_Instructions</template>
    </alerts>
    <alerts>
        <fullName>National_T_C_Managers_Notification</fullName>
        <description>National T&amp;C Managers Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>National_T_C_managers_notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/National_T_C_Instructions</template>
    </alerts>
    <alerts>
        <fullName>New_Product_Sold_for_National_or_SAM_Account</fullName>
        <description>New Product Sold for National or SAM Account</description>
        <protected>false</protected>
        <recipients>
            <recipient>damon.russel@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Research_Learning/ARM_Free_Trial</template>
    </alerts>
    <alerts>
        <fullName>Thank_You_For_Renewing_Contact_Email</fullName>
        <description>Thank You For Renewing Contact Email</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Renewal_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Professional_Software/PROSWD_Thank_you_for_Renewing_TAX</template>
    </alerts>
    <alerts>
        <fullName>Thank_You_For_Renewing_Contact_Email_Corp</fullName>
        <description>Thank You For Renewing Contact Email Corp</description>
        <protected>false</protected>
        <recipients>
            <field>AMS_Renewal_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Corporate_Software_Direct/CORPSWD_Thank_you_for_Renewing_PFX_TAX</template>
    </alerts>
    <alerts>
        <fullName>Thank_You_For_Renewing_PFX_Email</fullName>
        <description>Thank You For Renewing PFX Email</description>
        <protected>false</protected>
        <recipients>
            <field>PFX_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Professional_Software/PROSWD_Thank_you_for_Renewing_TAX</template>
    </alerts>
    <alerts>
        <fullName>Thank_You_For_Renewing_PFX_Email_Corp</fullName>
        <description>Thank You For Renewing PFX Email Corp</description>
        <protected>false</protected>
        <recipients>
            <field>PFX_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Corporate_Software_Direct/CORPSWD_Thank_you_for_Renewing_PFX_TAX</template>
    </alerts>
    <fieldUpdates>
        <fullName>AMS_Order_Complete</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Order Complete</literalValue>
        <name>AMS Order Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Ready_for_Order_Processing</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Submitted to Order Processing</literalValue>
        <name>AMS Ready for Order Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Stage_Order_Complete</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Order Complete</literalValue>
        <name>AMS Stage Order Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Stage_Ready_for_Order_Processing</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Submitted to Order Processing</literalValue>
        <name>AMS Stage Ready for Order Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Stage_Returned_to_Order_Processing</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Submitted to Order Processing</literalValue>
        <name>AMS Stage Returned to Order Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Stage_to_Draft</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>AMS Stage to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Stage_to_Ready_for_Order_Analysis</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Submitted to Order Analysis</literalValue>
        <name>AMS Stage to Ready for Order Analysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Stage_to_Returned_to_Order_Analysis</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Submitted to Order Analysis</literalValue>
        <name>AMS Stage to Returned to Order Analysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMS_Submitted_to_Billing</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Submitted to Billing</literalValue>
        <name>AMS Submitted to Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Ready_for_Billing</fullName>
        <field>AMS_Ready_for_Billing__c</field>
        <literalValue>0</literalValue>
        <name>Clear Ready for Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Ready_for_Order_Analysis</fullName>
        <field>AMS_Ready_for_Order_Analysis__c</field>
        <literalValue>0</literalValue>
        <name>Clear Ready for Order Analysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Ready_for_Order_Processing</fullName>
        <field>AMS_Ready_for_Order_Processing__c</field>
        <literalValue>0</literalValue>
        <name>Clear Ready for Order Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Date</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Lost_Populate_Date_Closed</fullName>
        <field>Date_Opportunity_Closed__c</field>
        <formula>CloseDate</formula>
        <name>Closed Lost - Populate Date Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Won_Populate_Date_Closed</fullName>
        <field>Date_Opportunity_Closed__c</field>
        <formula>CloseDate</formula>
        <name>Closed Won - Populate Date Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Convert_to_Customer_Account</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Customer_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Convert to Customer Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>In_Review</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>In review</literalValue>
        <name>In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>National_Order_Flag</fullName>
        <field>National_Order__c</field>
        <literalValue>1</literalValue>
        <name>National Order Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Push_Counter</fullName>
        <field>Push_Counter__c</field>
        <formula>IF( IsNull(Push_Counter__c),1,
    Push_Counter__c + 1)</formula>
        <name>Opportunity Push Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Order_Processing_Stage_to_Draft</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>Order Processing Stage to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Close_Date</fullName>
        <field>Renewal_Close_Date__c</field>
        <formula>IF(  Renewal_Close_Date__c  &gt; TODAY(),TODAY(), Renewal_Close_Date__c)</formula>
        <name>Populate Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Close_Date_1</fullName>
        <field>Renewal_Close_Date__c</field>
        <formula>TODAY()</formula>
        <name>Populate Close Date 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Contact_Email</fullName>
        <field>Primary_Contact_Email__c</field>
        <formula>Primary_Contact_for_Proposal__r.Email</formula>
        <name>Primary Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Contact_Phone</fullName>
        <field>Primary_Contact_Phone__c</field>
        <formula>Primary_Contact_for_Proposal__r.Phone</formula>
        <name>Primary Contact Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rep_Closed_Won</fullName>
        <field>Rep_Closed_Won_Opportunity__c</field>
        <formula>LastModifiedBy.FirstName +&quot; &quot;+ LastModifiedBy.LastName</formula>
        <name>Rep Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_National_Order_true</fullName>
        <field>National_Order__c</field>
        <literalValue>1</literalValue>
        <name>Set National Order true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SteelBrick_field_update</fullName>
        <field>CPQ_Quote__c</field>
        <literalValue>Steelbrick</literalValue>
        <name>SteelBrick field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_to_Billing_Date</fullName>
        <field>Submitted_to_Billing_Date__c</field>
        <formula>if(not(isblank( Submitted_to_Billing_Date__c )),Submitted_to_Billing_Date__c,Today())</formula>
        <name>Submitted to Billing Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_to_Order_Analysis_Date</fullName>
        <field>Submitted_to_Order_Analysis_Date__c</field>
        <formula>if(not(isblank( Submitted_to_Order_Analysis_Date__c )),Submitted_to_Order_Analysis_Date__c,Today())</formula>
        <name>Submitted to Order Analysis Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_to_Order_Porcessing_Date</fullName>
        <field>Submitted_to_Order_Processing_Date__c</field>
        <formula>if(not(isblank( Submitted_to_Order_Processing_Date__c )),Submitted_to_Order_Processing_Date__c,Today())</formula>
        <name>Submitted to Order Porcessing Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_to_Order_Processing</fullName>
        <field>AMS_Order_Processing_Stage__c</field>
        <literalValue>Submitted to Order Processing</literalValue>
        <name>Submitted to Order Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Field_Lost</fullName>
        <field>Renewal_Close_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Field Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Renewal_Close_Date</fullName>
        <description>Update Close Date - Only Populated for Renewal Opportunities</description>
        <field>Renewal_Close_Date__c</field>
        <formula>IF( Renewal_Close_Date__c &gt; TODAY(),TODAY(),Renewal_Close_Date__c)</formula>
        <name>Update Renewal Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Type_on_Account</fullName>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Update Type on Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_close_date_to_prior_value</fullName>
        <field>CloseDate</field>
        <formula>PRIORVALUE(CloseDate)</formula>
        <name>update close date to prior value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AMS Billing Complete</fullName>
        <actions>
            <name>National_Order_Complete</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AMS_Stage_Order_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>PRIORVALUE( AMS_Billing_Complete__c ) &lt;&gt; true &amp;&amp; AMS_Billing_Complete__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMS Ready for Order Analysis</fullName>
        <actions>
            <name>AMS_Order_Analysis</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AMS_Stage_to_Ready_for_Order_Analysis</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Submitted_to_Order_Analysis_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>priorvalue(AMS_Ready_for_Order_Analysis__c)&lt;&gt; true &amp;&amp;
AMS_Ready_for_Order_Analysis__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMS Ready for Order Processing</fullName>
        <actions>
            <name>AMS_Order_Processing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Submitted_to_Order_Processing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>not(ispickval(AMS_Order_Processing_Stage__c,&quot;Submitted to Order processing&quot;)) &amp;&amp;  AMS_Ready_for_Order_Processing__c  = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMS Return Order</fullName>
        <actions>
            <name>AMS_Order_Return</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Order_Processing_Stage_to_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets opportunity order processing stage back to Draft</description>
        <formula>PRIORVALUE( AMS_Return_Order_to_Rep__c ) &lt;&gt; true &amp;&amp; AMS_Return_Order_to_Rep__c =true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMS Return to Order Analysis</fullName>
        <actions>
            <name>AMS_Return_to_Order_Analysis</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AMS_Stage_to_Returned_to_Order_Analysis</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Ready_for_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Ready_for_Order_Processing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(Priorvalue(AMS_Return_to_Order_Analysis__c)=true),AMS_Return_to_Order_Analysis__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMS Return to Order Processing</fullName>
        <actions>
            <name>AMS_Return_to_Order_Processing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AMS_Stage_Returned_to_Order_Processing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Ready_for_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Ready_for_Order_Analysis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(Priorvalue(AMS_Return_to_Order_Processing__c)=true), AMS_Return_to_Order_Processing__c=true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMS Submitted to Billing</fullName>
        <actions>
            <name>AMS_Ready_for_Billing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AMS_Submitted_to_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Submitted_to_Billing_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>PRIORVALUE( AMS_Ready_for_Billing__c )&lt;&gt; true &amp;&amp;  AMS_Ready_for_Billing__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMS Submitted to Order processing Alert</fullName>
        <actions>
            <name>AMS_Order_Processing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Submitted_to_Order_Porcessing_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(TEXT(PRIORVALUE(AMS_Order_Processing_Stage__c)) =&quot;Submitted to Order Processing&quot;) &amp;&amp; ISPICKVAL(AMS_Order_Processing_Stage__c,&quot;Submitted to Order Processing&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASR%2FTC Welcome Call</fullName>
        <actions>
            <name>Step_1_Welcome_Call</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_2_Cancellation_Risk</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_3_Full_Adoption</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_4_Engage_Account_Review</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_5_Renewal_Call</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Training_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 OR 6) and 7 and 8 and 9</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>New to New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Category__c</field>
            <operation>equals</operation>
            <value>Research &amp; Learning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>8000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Has_TC_Opportunity_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Has_ASR_Opportunity_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Sub_Category__c</field>
            <operation>notEqual</operation>
            <value>Learning Tax,Books</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Closed_Reason__c</field>
            <operation>notEqual</operation>
            <value>Add-on Sale</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Division__c</field>
            <operation>notEqual</operation>
            <value>Corp National,National Accounts</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASR%2FTC Welcome Call - Service Source</fullName>
        <actions>
            <name>Step_1_Welcome_Call_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_2_Cancellation_Risk_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_3_Full_Adoption_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_4_Engage_Account_Review_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_5_Renewal_Call_SS</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 and 6 and 7 and 8</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>New to New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Category__c</field>
            <operation>equals</operation>
            <value>Research &amp; Learning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>8000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Has_ASR_Opportunity_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Sub_Category__c</field>
            <operation>notEqual</operation>
            <value>Learning Tax,Books</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Closed_Reason__c</field>
            <operation>notEqual</operation>
            <value>Add-on Sale</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Division__c</field>
            <operation>notEqual</operation>
            <value>Corp National,National Accounts</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Date When Won</fullName>
        <actions>
            <name>Populate_Close_Date_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <description>Close Date When Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Lost - Populate Date Closed</fullName>
        <actions>
            <name>Closed_Lost_Populate_Date_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7. Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Renewal Opportunity</value>
        </criteriaItems>
        <description>When Opportunity is moved to Closed Lost, stamps the date in Date Opportunity Closed field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Lost - Populate Date Closed - Renewal</fullName>
        <actions>
            <name>Populate_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Renewal Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal Opportunity</value>
        </criteriaItems>
        <description>When Opportunity is moved to Closed Lost, stamps the date in Date Opportunity Closed field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Won - Populate Date Closed</fullName>
        <actions>
            <name>Closed_Won_Populate_Date_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Renewal Opportunity</value>
        </criteriaItems>
        <description>When Opportunity is moved to Closed Won, stamps the date in Date Opportunity Closed field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Won - Populate Date Closed - Renewal</fullName>
        <actions>
            <name>Update_Renewal_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal Opportunity</value>
        </criteriaItems>
        <description>When Opportunity is moved to Closed Won, stamps the date in Date Opportunity Closed field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Convert Prospect to Customer</fullName>
        <actions>
            <name>Convert_to_Customer_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Type_on_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect Account</value>
        </criteriaItems>
        <description>A prospect account is converted to a customer account when it has an associated opportunity that has closed won.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Create Welcome Call Task</fullName>
        <actions>
            <name>Welcome_Call</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Request_Welcome_Call__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Expansion Call - RL</fullName>
        <actions>
            <name>Step_1_Expansion_Call</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_1_Expansion_Training_Call</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_2_Cancellation_Risk</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_3_Full_Adoption</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_4_Engage_Account_Review</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_5_Renewal_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 OR 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>New to Existing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Category__c</field>
            <operation>equals</operation>
            <value>Research &amp; Learning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Named_Account_Type__c</field>
            <operation>notEqual</operation>
            <value>Service Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Has_TC_Opportunity_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Has_ASR_Opportunity_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Sub_Category__c</field>
            <operation>notEqual</operation>
            <value>Books</value>
        </criteriaItems>
        <description>Creates tasks for the opportunity team on N2E sales, if an RC and TC rep are assigned.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Expansion Call - SS</fullName>
        <actions>
            <name>Step_1_Expansion_Call_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_2_Cancellation_Risk_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_3_Full_Adoption_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_4_Engage_Account_Review_SS</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Step_5_Renewal_Call_SS</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6. Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>New to Existing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Category__c</field>
            <operation>equals</operation>
            <value>Research &amp; Learning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Named_Account_Type__c</field>
            <operation>equals</operation>
            <value>Service Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Has_ASR_Opportunity_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Sub_Category__c</field>
            <operation>notEqual</operation>
            <value>Books</value>
        </criteriaItems>
        <description>Creates tasks for the opportunity team on N2E sales, if a SS RC is assigned.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>National Opportunity</fullName>
        <actions>
            <name>National_Order_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>priorvalue(National_Order__c ) &lt;&gt; true &amp;&amp;   (Owner.Profile_Name__c =&quot;National CCH Axcess - Sales Manager&quot; || Owner.Profile_Name__c =&quot;National CCH Axcess - Sales Representative&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>National T%26C Consultant Notification</fullName>
        <actions>
            <name>National_T_C_Consultant_Notofication</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>text(priorvalue(AMS_Order_Processing_Stage__c)) &lt;&gt;&quot;Submitted to Order Processing&quot; &amp;&amp; ispickval(AMS_Order_Processing_Stage__c,&quot;Submitted to Order Processing&quot;) &amp;&amp; not(isblank( T_C_Consultant__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>National T%26C Managers notification</fullName>
        <actions>
            <name>National_T_C_Managers_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>text(priorvalue(AMS_Order_Processing_Stage__c)) &lt;&gt; &quot;Submitted to Order Processing&quot; &amp;&amp; ispickval(AMS_Order_Processing_Stage__c,&quot;Submitted to Order Processing&quot;) &amp;&amp; NOT(Isblank(National_T_C_Instructions__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Push Counter</fullName>
        <actions>
            <name>Opportunity_Push_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(CloseDate &gt; PriorValue(CloseDate),     IF(Month (CloseDate) &lt;&gt; Month (PriorValue(CloseDate)),         True , False),      False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A SteelBrick field update</fullName>
        <actions>
            <name>SteelBrick_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update CPQ Type Field to steelbrick if steelbrick quote field is populated</description>
        <formula>IsChanged( SteelBrick_Quote__c )&amp;&amp; Not(ispickval(CPQ_Quote__c ,&quot;Steelbrick&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate today%27 date</fullName>
        <actions>
            <name>Update_Field_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7. Closed Lost</value>
        </criteriaItems>
        <description>Populate today&apos; date if stage is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Primary Contact Data</fullName>
        <actions>
            <name>Primary_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Primary_Contact_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Primary_Contact_for_Proposal__c &lt;&gt;&apos;&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewal Won</fullName>
        <actions>
            <name>Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL(PRIORVALUE( StageName ),&quot;Renewal Won&quot;)), ISPICKVAL(StageName ,&quot;Renewal Won&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rep Closed Won Territory Opp</fullName>
        <actions>
            <name>Rep_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( IsWon),
    IsWon = TRUE,
     CONTAINS( Owner.FirstName , &quot;Territory&quot;) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Thank you for Renewing Contact Email</fullName>
        <actions>
            <name>Thank_You_For_Renewing_Contact_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(PRIORVALUE(StageName)) &lt;&gt;&quot;Renewal Won&quot;, ISPICKVAL(StageName , &quot;Renewal Won&quot;),  Is_AMS_Renewal__c = true,  ISBLANK(AMS_Renewal_Email__c) &lt;&gt; true,  Account.Professional_Segment__c =true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Thank you for Renewing Contact Email Corp</fullName>
        <actions>
            <name>Thank_You_For_Renewing_Contact_Email_Corp</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(PRIORVALUE(StageName)) &lt;&gt;&quot;Renewal Won&quot;, ISPICKVAL(StageName , &quot;Renewal Won&quot;),  Is_AMS_Renewal__c = true,  ISBLANK(AMS_Renewal_Email__c) &lt;&gt; true,Account.Corporate_Segment__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Thank you for Renewing PFX Email</fullName>
        <actions>
            <name>Thank_You_For_Renewing_PFX_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(PRIORVALUE(StageName)) &lt;&gt;&quot;Renewal Won&quot;, ISPICKVAL(StageName , &quot;Renewal Won&quot;),  Is_AMS_Renewal__c = true,  AND(ISBLANK( PFX_Email_Address__c ) &lt;&gt; true, ISBLANK( AMS_Renewal_Email__c)=true), Account.Professional_Segment__c =true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Thank you for Renewing PFX Email Corp</fullName>
        <actions>
            <name>Thank_You_For_Renewing_PFX_Email_Corp</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(PRIORVALUE(StageName)) &lt;&gt;&quot;Renewal Won&quot;, ISPICKVAL(StageName , &quot;Renewal Won&quot;),  Is_AMS_Renewal__c = true,  AND(ISBLANK( PFX_Email_Address__c ) &lt;&gt; true, ISBLANK(  AMS_Renewal_Email__c )=true), Account.Corporate_Segment__c=true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>closed date update</fullName>
        <actions>
            <name>update_close_date_to_prior_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Closed_Reason__c</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Is_AMS_Renewal__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Step_1_Expansion_Call</fullName>
        <assignedTo>RC - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Verify the products added to the account.

For IntelliConnect: determine what training is needed / verify IDs, go over basics, etc.
For Learning Center: ensure client has access
For Accounting Research Manager: verify IDs / basics, offer MTS training</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 1 - Expansion Call</subject>
    </tasks>
    <tasks>
        <fullName>Step_1_Expansion_Call_SS</fullName>
        <assignedTo>RC - R&amp;L ServiceSource</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Verify the products added to the account. 

For IntelliConnect: Verify IDs, go over basics, sign up for MTS, etc. 
For Learning Center: ensure client has access 
For Accounting Research Manager: verify IDs / basics, offer MTS traini</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 1 - Expansion Call - SS</subject>
    </tasks>
    <tasks>
        <fullName>Step_1_Expansion_Training_Call</fullName>
        <assignedTo>T&amp;C - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Contact RSC and RC to determine what training is needed for the client. This is for an expansion (new-to-existing sale) into an existing R&amp;L client.</description>
        <dueDateOffset>15</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 1 - Expansion Training Call</subject>
    </tasks>
    <tasks>
        <fullName>Step_1_Welcome_Call</fullName>
        <assignedTo>RC - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Verify ID&apos;s. Review basic IC functions: Trackers, A-Z, Install IntelliForms ‘15 &amp; ‘14 (forms &lt;/=2012). Set next appt. Email Support Doc.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 1 - Welcome Call</subject>
    </tasks>
    <tasks>
        <fullName>Step_1_Welcome_Call_SS</fullName>
        <assignedTo>RC - R&amp;L ServiceSource</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Verify ID&apos;s. Review basic IC functions: Trackers, A-Z, Install IntelliForms ‘15 &amp; ‘14 (forms &lt;/=2012). Set next appt. Email Support Doc.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 1 - Welcome Call - SS</subject>
    </tasks>
    <tasks>
        <fullName>Step_2_Cancellation_Risk</fullName>
        <assignedTo>RC - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Review usage.  Verify Training Attendance.   Review integration usage, favorites, SmartCharts, etc.</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 2 - Cancellation Risk</subject>
    </tasks>
    <tasks>
        <fullName>Step_2_Cancellation_Risk_SS</fullName>
        <assignedTo>RC - R&amp;L ServiceSource</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Review usage.  Verify Training Attendance.   Review integration usage, favorites, SmartCharts, etc.</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 2 - Cancellation Risk - SS</subject>
    </tasks>
    <tasks>
        <fullName>Step_3_Full_Adoption</fullName>
        <assignedTo>RC - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Verify continued usage.  Gather problem areas.   Review latest enhancements.  Set new users up for training.  Content gaps/upsell.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 3 - Full Adoption</subject>
    </tasks>
    <tasks>
        <fullName>Step_3_Full_Adoption_SS</fullName>
        <assignedTo>RC - R&amp;L ServiceSource</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Verify continued usage.  Gather problem areas.   Review latest enhancements.  Set new users up for training.  Content gaps/upsell.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 3 - Full Adoption - SS</subject>
    </tasks>
    <tasks>
        <fullName>Step_4_Engage_Account_Review</fullName>
        <assignedTo>RC - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Cover system enhancements.   Review usage.  Set stage for early renewal.  Identify new users and set up for training.  Discuss any changes in business.</description>
        <dueDateOffset>180</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 4 - Engage/Account Review</subject>
    </tasks>
    <tasks>
        <fullName>Step_4_Engage_Account_Review_SS</fullName>
        <assignedTo>RC - R&amp;L ServiceSource</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Cover system enhancements.   Review usage.  Set stage for early renewal.  Identify new users and set up for training.  Discuss any changes in business.</description>
        <dueDateOffset>180</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 4 - Engage/Account Review - SS</subject>
    </tasks>
    <tasks>
        <fullName>Step_5_Renewal_Call</fullName>
        <assignedTo>RC - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Get renewal.  Cover training needs.  Gaps/Upsell.</description>
        <dueDateOffset>270</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 5 - Renewal Call</subject>
    </tasks>
    <tasks>
        <fullName>Step_5_Renewal_Call_SS</fullName>
        <assignedTo>RC - R&amp;L ServiceSource</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Get renewal.  Cover training needs.  Gaps/Upsell.</description>
        <dueDateOffset>270</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Step 5 - Renewal Call - SS</subject>
    </tasks>
    <tasks>
        <fullName>Training_Call</fullName>
        <assignedTo>T&amp;C - Research and Learning</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Schedule Intro to IC Class.   Learn about business, set-up onsite visit if applicable.</description>
        <dueDateOffset>15</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Training Call</subject>
    </tasks>
    <tasks>
        <fullName>Welcome_Call</fullName>
        <assignedTo>mark.lovullo@wolterskluwer.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please make a Welcome Call to this customer!</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Welcome Call</subject>
    </tasks>
</Workflow>
