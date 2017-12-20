<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Customer_Seg_Advanced</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Advanced</literalValue>
        <name>Customer Seg - Advanced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_Blank</fullName>
        <field>Customer_Segmentation__c</field>
        <name>Customer Seg - Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_Commercial</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Commercial</literalValue>
        <name>Customer Seg - Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_Consultant</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Consultant</literalValue>
        <name>Customer Seg - Consultant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_Established</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Established</literalValue>
        <name>Customer Seg - Established</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_FS_Traditionalist</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Full Service Traditionalist</literalValue>
        <name>Customer Seg - FS Traditionalist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_ITS</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Intermediate Tax Shop</literalValue>
        <name>Customer Seg - ITS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_M_P</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Mom and Pop Shop</literalValue>
        <name>Customer Seg - M&amp;P</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_Professionalized</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Professionalized</literalValue>
        <name>Customer Seg - Professionalized</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_Progressive</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Progressive</literalValue>
        <name>Customer Seg - Progressive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_STS1</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Small Tax Shop 1</literalValue>
        <name>Customer Seg - STS1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_STS2</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Small Tax Shop 2+</literalValue>
        <name>Customer Seg - STS2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Seg_Tax_Focused_Traditionalist</fullName>
        <field>Customer_Segmentation__c</field>
        <literalValue>Tax-Focused Traditionalist</literalValue>
        <name>Customer Seg -Tax Focused Traditionalist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Informatica_Field_Update_Time</fullName>
        <field>SFS_Informatica_Field_Update_Time__c</field>
        <formula>NOW()</formula>
        <name>Informatica Field Update Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Point_Clear_Checked_Date</fullName>
        <field>Point_Clear_Marked_Date__c</field>
        <formula>Today()</formula>
        <name>Point Clear Checked Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Named_Account_to_TRUE</fullName>
        <field>Named_Account__c</field>
        <literalValue>1</literalValue>
        <name>Set Named Account to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SF_ID_in_Cust_ID_Field</fullName>
        <description>This field is updated with the SF ID when no CustID exists on Newly Created Prospect Accounts.</description>
        <field>CUSTID__c</field>
        <formula>Id</formula>
        <name>Set SF ID in Cust ID Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SFDC_Acct_Text</fullName>
        <field>SFDC_Account_Text__c</field>
        <formula>SFDC_Account__c</formula>
        <name>Update SFDC Acct Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Customer Seg - Advanced</fullName>
        <actions>
            <name>Customer_Seg_Advanced</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>equals</operation>
            <value>Pioneer,Early Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>30-80 Total Employees,80-200 Total Employees</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Advanced %28blank%29</fullName>
        <actions>
            <name>Customer_Seg_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 or 2 or 3 or 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>notEqual</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>notEqual</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>notEqual</operation>
            <value>Pioneer,Early Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>notEqual</operation>
            <value>30-80 Total Employees,80-200 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>equals</operation>
            <value>Advanced</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Commerical</fullName>
        <actions>
            <name>Customer_Seg_Commercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 or 6)</booleanFilter>
        <criteriaItems>
            <field>Account.Bank_Products__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>150-499,&gt;500</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>notEqual</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Consultant</fullName>
        <actions>
            <name>Customer_Seg_Consultant</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND ((2 AND 3 AND 4) OR (5 AND 6 AND 3 AND 7)) AND 8 AND 9 and (10 or 11)</booleanFilter>
        <criteriaItems>
            <field>Account.Bank_Products__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>150-499</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.FEE_PER_RETURN_AVG_c__c</field>
            <operation>equals</operation>
            <value>$200 or more</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CONSULT_CFO_WORK_PERCENT_GTRTEN_c__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>1-149</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.NON_INDIV_RETURNS_PERCENT_RANGE_c__c</field>
            <operation>equals</operation>
            <value>&gt; 25%</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CONSULT_CFO_WORK_PERCENT_GTRTEN_c__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>notEqual</operation>
            <value>Consultant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Established</fullName>
        <actions>
            <name>Customer_Seg_Established</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&gt; 200 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>notEqual</operation>
            <value>Established</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Established %28blank%29</fullName>
        <actions>
            <name>Customer_Seg_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 or 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>notEqual</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>notEqual</operation>
            <value>&gt; 200 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>equals</operation>
            <value>Established</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - FS Traditionalist</fullName>
        <actions>
            <name>Customer_Seg_FS_Traditionalist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>equals</operation>
            <value>Mainstream Adopter,Late Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>10-29 Total Employees,30-80 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>notEqual</operation>
            <value>Full Service Traditionalist</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - FS Traditionalist %28blank%29</fullName>
        <actions>
            <name>Customer_Seg_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 or 2 or 3 or 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>notEqual</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>notEqual</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>notEqual</operation>
            <value>Mainstream Adopter,Late Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>notEqual</operation>
            <value>10-29 Total Employees,30-80 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>equals</operation>
            <value>Full Service Traditionalist</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - ITS</fullName>
        <actions>
            <name>Customer_Seg_ITS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 and 6</booleanFilter>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>&gt;500</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Bank_Products__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>notEqual</operation>
            <value>Intermediate Tax Shop</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - M%26P</fullName>
        <actions>
            <name>Customer_Seg_M_P</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3) OR (4 AND 2) AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Account.Bank_Products__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>1-149</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.NON_INDIV_RETURNS_PERCENT_RANGE_c__c</field>
            <operation>equals</operation>
            <value>0-24%</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Bank_Products__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Professionalized</fullName>
        <actions>
            <name>Customer_Seg_Professionalized</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>equals</operation>
            <value>Mainstream Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>10-29 Total Employees,30-80 Total Employees,80-200 Total Employees</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Professionalized %28blank%29</fullName>
        <actions>
            <name>Customer_Seg_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 or 2 or 3 or 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>notEqual</operation>
            <value>Full Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>notEqual</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>notEqual</operation>
            <value>Mainstream Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>notEqual</operation>
            <value>10-29 Total Employees,30-80 Total Employees,80-200 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>equals</operation>
            <value>Professionalized</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Progressive</fullName>
        <actions>
            <name>Customer_Seg_Progressive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Tax Focused</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>equals</operation>
            <value>High,Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>equals</operation>
            <value>Pioneer,Early Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>10-29 Total Employees,30-80 Total Employees,80-200 Total Employees,&gt; 200 Total Employees</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Progressive %28%3C10%29</fullName>
        <actions>
            <name>Customer_Seg_Progressive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 and 6</booleanFilter>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Tax Focused</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>equals</operation>
            <value>High,Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>equals</operation>
            <value>Pioneer,Early Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>notEqual</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Progressive %28blank%29</fullName>
        <actions>
            <name>Customer_Seg_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND ((2 and  (3 or 4)) OR (5 and (6 or 7) OR 8))</booleanFilter>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>equals</operation>
            <value>Progressive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>10-29 Total Employees,30-80 Total Employees,80-200 Total Employees,&gt; 200 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>notEqual</operation>
            <value>Pioneer,Early Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>notEqual</operation>
            <value>High,Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - STS1</fullName>
        <actions>
            <name>Customer_Seg_STS1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 9 and 10 and ((2 AND (3 OR (4 AND 5))) OR (6 AND 7  AND 3) OR (6 AND 7 AND 8 AND 5))</booleanFilter>
        <criteriaItems>
            <field>Account.Bank_Products__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>150-499</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.FEE_PER_RETURN_AVG_c__c</field>
            <operation>equals</operation>
            <value>0-$199</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.FEE_PER_RETURN_AVG_c__c</field>
            <operation>equals</operation>
            <value>$200 or more</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CONSULT_CFO_WORK_PERCENT_GTRTEN_c__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>1-149</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.NON_INDIV_RETURNS_PERCENT_RANGE_c__c</field>
            <operation>equals</operation>
            <value>&gt; 25%</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.FEE_PER_RETURN_AVG_c__c</field>
            <operation>equals</operation>
            <value>$200 or more</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - STS2</fullName>
        <actions>
            <name>Customer_Seg_STS2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 9 and 10 and 11 and ((2 AND (3 OR (4 AND 5))) OR (6 AND 7  AND 3) OR (6 AND 7 AND 8 AND 5))</booleanFilter>
        <criteriaItems>
            <field>Account.Bank_Products__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>150-499</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.FEE_PER_RETURN_AVG_c__c</field>
            <operation>equals</operation>
            <value>0-$199</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.FEE_PER_RETURN_AVG_c__c</field>
            <operation>equals</operation>
            <value>$200 or more</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CONSULT_CFO_WORK_PERCENT_GTRTEN_c__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Return_Vol__c</field>
            <operation>equals</operation>
            <value>1-149</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.NON_INDIV_RETURNS_PERCENT_RANGE_c__c</field>
            <operation>equals</operation>
            <value>&gt; 25%</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.FEE_PER_RETURN_AVG_c__c</field>
            <operation>equals</operation>
            <value>$200 or more</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>notEqual</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Tax Focused Traditionalist</fullName>
        <actions>
            <name>Customer_Seg_Tax_Focused_Traditionalist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Tax Focused</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>equals</operation>
            <value>Mainstream Adopter,Late Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>10-29 Total Employees,30-80 Total Employees,80-200 Total Employees,&gt; 200 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>notEqual</operation>
            <value>Tax-Focused Traditionalist</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Tax Focused Traditionalist %28%3C10%29</fullName>
        <actions>
            <name>Customer_Seg_Tax_Focused_Traditionalist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 and 6 and 7</booleanFilter>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>equals</operation>
            <value>Tax Focused</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>equals</operation>
            <value>Mainstream Adopter,Late Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>equals</operation>
            <value>&lt;10 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>notEqual</operation>
            <value>Tax-Focused Traditionalist</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CPA_Led__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Sub_Segment__c</field>
            <operation>notEqual</operation>
            <value>Sole Proprietor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Seg - Tax Focused Traditionalist %28blank%29</fullName>
        <actions>
            <name>Customer_Seg_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 or 2 or 3 or 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Account.Business_Mix__c</field>
            <operation>notEqual</operation>
            <value>Tax Focused</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Growth_Aspiration__c</field>
            <operation>notEqual</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tech_Appetite__c</field>
            <operation>notEqual</operation>
            <value>Mainstream Adopter,Late Adopter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Scale__c</field>
            <operation>notEqual</operation>
            <value>10-29 Total Employees,30-80 Total Employees,80-200 Total Employees,&gt; 200 Total Employees</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Segmentation__c</field>
            <operation>equals</operation>
            <value>Tax-Focused Traditionalist</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Point Clear Marked Date</fullName>
        <actions>
            <name>Point_Clear_Checked_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Account.Point_Clear_Prospect__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Point_Clear_Marked_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFS Informatica Field Update Time</fullName>
        <actions>
            <name>Informatica_Field_Update_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Name)  ||   ISCHANGED(Phone)  ||   ISCHANGED(Market_Segment__c)  ||   ISCHANGED(Market_Sub_Segment__c)  ||   ISCHANGED(SFDC_Account__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set SF ID in Cust ID Field</fullName>
        <actions>
            <name>Set_SF_ID_in_Cust_ID_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CUSTID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set SF ID in Cust ID field when it is a new Prospect Account.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update SFDC Acct %23</fullName>
        <actions>
            <name>Update_SFDC_Acct_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SFDC_Account__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
