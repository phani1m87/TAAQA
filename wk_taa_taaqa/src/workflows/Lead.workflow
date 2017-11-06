<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Hot_Lead_Assigned</fullName>
        <description>Hot Lead Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Hot_Lead_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Lead_ASR_Lead_Assigned</fullName>
        <description>Lead: ASR Lead Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/ASR_New_Lead_Assigned</template>
    </alerts>
    <fieldUpdates>
        <fullName>First_Day_Lead_Touched</fullName>
        <field>First_Date_Tocuhed__c</field>
        <formula>TODAY()</formula>
        <name>First Day Lead Touched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Owner</fullName>
        <description>Update the Date the Owner Field Changed</description>
        <field>Last_Owner_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>Last Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Alignment_Corp_Direct</fullName>
        <field>Sales_Alignment__c</field>
        <literalValue>RSC - Corp Software Direct</literalValue>
        <name>Sales Alignment - Corp Direct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Alignment_Corp_Indirect</fullName>
        <field>Sales_Alignment__c</field>
        <literalValue>RSC - Corp Software Indirect</literalValue>
        <name>Sales Alignment - Corp Indirect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Alignment_Pro_SW_RSC</fullName>
        <field>Sales_Alignment__c</field>
        <literalValue>RSC - Professional Software</literalValue>
        <name>Sales Alignment - Pro SW RSC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Alignment_R_L_ISC</fullName>
        <field>Sales_Alignment__c</field>
        <literalValue>ISC - Research &amp; Learning</literalValue>
        <name>Sales Alignment - R&amp;L ISC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Alignment_R_L_RSC</fullName>
        <field>Sales_Alignment__c</field>
        <literalValue>RSC - Research &amp; Learning</literalValue>
        <name>Sales Alignment - R&amp;L RSC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Alignment_Software_ISC</fullName>
        <field>Sales_Alignment__c</field>
        <literalValue>ISC - Professional Software</literalValue>
        <name>Sales Alignment - Software ISC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unqualified_Date_Blank</fullName>
        <field>Disposition_Date__c</field>
        <name>Unqualified Date Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unqualified_Date_Today</fullName>
        <field>Disposition_Date__c</field>
        <formula>TODAY()</formula>
        <name>Unqualified Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DTN</fullName>
        <field>DTN_Text__c</field>
        <formula>DTN__c</formula>
        <name>Update DTN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>First Day Lead Touched</fullName>
        <actions>
            <name>First_Day_Lead_Touched</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Date Lead was removed from Not Started</description>
        <formula>ISCHANGED(Status)&amp;&amp;  ISPICKVAL(PRIORVALUE(Status),&quot;Not Started&quot;)&amp;&amp; ISBLANK( First_Date_Tocuhed__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Hot Lead Assigned</fullName>
        <actions>
            <name>Hot_Lead_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(OR( ISPICKVAL( Status , &quot;Not Started&quot;),
        ISPICKVAL( Status , &quot;Gain Access&quot;)),
    OR( AND( ISNEW() = TRUE,
             ISPICKVAL( Rating , &quot;Hot&quot;)),
        AND( ISCHANGED( OwnerId),
             ISPICKVAL( Rating , &quot;Hot&quot;)),
        AND( ISCHANGED( Rating),
             ISPICKVAL( Rating , &quot;Hot&quot;))
))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Hot Lead Assigned Change Owner</fullName>
        <actions>
            <name>Hot_Lead_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(OwnerId) &amp;&amp; ISPICKVAL(Rating,&quot;HOT&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Last Owner Change Date</fullName>
        <actions>
            <name>Last_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically gets populated/updated each time the Lead Owner is changed</description>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Lead Assigned to ASR</fullName>
        <actions>
            <name>Lead_ASR_Lead_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends email to ASR when leads are assigned. Related to CCH e-Sign.</description>
        <formula>Owner:User.Profile.Name = &quot;ASR User&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Alignment - Corp Direct</fullName>
        <actions>
            <name>Sales_Alignment_Corp_Direct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Sales_Alignment_Staging__c</field>
            <operation>equals</operation>
            <value>Software</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Banks and Financial Institutions,Consultants,General Corporate,Hospital and Payers,Insurance Companies,Tax Exempt and Membership Organizations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Alignment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Alignment - Corp Indirect</fullName>
        <actions>
            <name>Sales_Alignment_Corp_Indirect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Sales_Alignment_Staging__c</field>
            <operation>equals</operation>
            <value>Indirect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Alignment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Alignment - ISC Software</fullName>
        <actions>
            <name>Sales_Alignment_Software_ISC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR (3 AND 4) OR 5) AND 6</booleanFilter>
        <criteriaItems>
            <field>Lead.Sales_Alignment_Staging__c</field>
            <operation>equals</operation>
            <value>Software</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Retail Tax Preparers</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Accounting Firms,Financial and Estate Planners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor,2-4 Total Employees,Size TBD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Law Firm 1-3 Attorneys,Law Firms (Size TBD)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Alignment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Alignment - Pro SW RSC</fullName>
        <actions>
            <name>Sales_Alignment_Pro_SW_RSC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR (3 AND 4) OR (5 AND 6)) AND 7</booleanFilter>
        <criteriaItems>
            <field>Lead.Sales_Alignment_Staging__c</field>
            <operation>equals</operation>
            <value>Software</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Schools and Libraries,State and Local Government</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Accounting Firms,Financial and Estate Planners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>5-9 Total Employees,10-19 Total Employees,20-49 Total Employees,50-99 Total Employees,100+ Total Employees,Top 100 Firms</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Legal Professionals</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>notEqual</operation>
            <value>Law Firm 1-3 Attorneys,Law Firms (Size TBD)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Alignment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Alignment - R%26L ISC</fullName>
        <actions>
            <name>Sales_Alignment_R_L_ISC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR (3 AND 4) OR 5) AND 6</booleanFilter>
        <criteriaItems>
            <field>Lead.Sales_Alignment_Staging__c</field>
            <operation>equals</operation>
            <value>R&amp;L</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Retail Tax Preparers</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Accounting Firms,Financial and Estate Planners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Sole Proprietor,2-4 Total Employees,Size TBD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>Law Firm 1-3 Attorneys,Law Firms (Size TBD)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Alignment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Alignment - R%26L RSC</fullName>
        <actions>
            <name>Sales_Alignment_R_L_RSC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR (3 AND 4) OR (5 AND 6)) and 7</booleanFilter>
        <criteriaItems>
            <field>Lead.Sales_Alignment_Staging__c</field>
            <operation>equals</operation>
            <value>R&amp;L</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Banks and Financial Institutions,Consultants,General Corporate,Hospital and Payers,Insurance Companies,Schools and Libraries,State and Local Government,Tax Exempt and Membership Organizations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Accounting Firms,Financial and Estate Planners</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>equals</operation>
            <value>5-9 Total Employees,10-19 Total Employees,20-49 Total Employees,50-99 Total Employees,100+ Total Employees,Top 100 Firms</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Legal Professionals</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Market_Sub_Segment__c</field>
            <operation>notEqual</operation>
            <value>Law Firm 1-3 Attorneys,Law Firms (Size TBD)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Alignment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unqualified Date Blank</fullName>
        <actions>
            <name>Unqualified_Date_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Unqualified</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unqualified Date Updated to Today</fullName>
        <actions>
            <name>Unqualified_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED( Status ) , ISNEW () = TRUE) &amp;&amp; OR(ISPICKVAL(Status , &quot;Not Viable&quot;),ISPICKVAL(Status, &quot;No Current Opportunity&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update DTN</fullName>
        <actions>
            <name>Update_DTN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
