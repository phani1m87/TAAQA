<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CBI_Notify_Director_of_CBI_Submission_20K_for_Central_Midwest_and_Pacific</fullName>
        <description>CBI: Notify Director of CBI Submission $20K+ for Central, Midwest, and Pacific</description>
        <protected>false</protected>
        <recipients>
            <recipient>tim.powell@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Solution_Blueprint_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CBI_Notify_Director_of_CBI_Submission_20K_for_Northeast_Southeast_and_Mid_Atlant</fullName>
        <description>CBI: Notify Director of CBI Submission $20K+ for Northeast, Southeast, and Mid-Atlantic Divisions</description>
        <protected>false</protected>
        <recipients>
            <recipient>brian.friedman@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Solution_Blueprint_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CBI_Notify_Outsource_Product_Manager_of_CBI_Submission</fullName>
        <description>CBI: Notify Outsource Product Manager of CBI Submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>mike.gamble@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Solution_Blueprint_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CBI_Notify_SA_and_Manager_of_CBI_Submission</fullName>
        <description>CBI: Notify SA and Manager of CBI Submission</description>
        <protected>false</protected>
        <recipients>
            <field>Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SA_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Solution_Architect__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Solution_Blueprint_Submitted</template>
    </alerts>
    <alerts>
        <fullName>CBI_Notify_Small_Firms_SA_Lead_of_CBI_Submission</fullName>
        <description>CBI: Notify Small Firms SA Lead of CBI Submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>lance.center@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Solution_Blueprint_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>CBI_Populate_Manager_Email</fullName>
        <field>Manager_Email__c</field>
        <formula>Opportunity__r.Owner.Manager.Email</formula>
        <name>CBI: Populate Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CBI_Populate_SA_Manager_Email</fullName>
        <field>SA_Manager_Email__c</field>
        <formula>Solution_Architect__r.Manager.Email</formula>
        <name>CBI: Populate SA Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CBI%3A Notify Director %2425K%2B for Central%2C Midwest%2C and Pacific</fullName>
        <actions>
            <name>CBI_Notify_Director_of_CBI_Submission_20K_for_Central_Midwest_and_Pacific</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CBI_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>25000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Division__c</field>
            <operation>equals</operation>
            <value>Central,Midwest,Pacific</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_High_Level_Division__c</field>
            <operation>equals</operation>
            <value>Strategic &amp; Mid-Market</value>
        </criteriaItems>
        <description>Notifies Director if a Solution Blueprint was created for an Opp over $25K for the for Central, Midwest, and Pacific divisions</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CBI%3A Notify Director %2425K%2Bfor Northeast%2C Southeast%2C and Mid-Atlantic Divisions</fullName>
        <actions>
            <name>CBI_Notify_Director_of_CBI_Submission_20K_for_Northeast_Southeast_and_Mid_Atlant</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CBI_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>25000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Division__c</field>
            <operation>equals</operation>
            <value>Northeast,Southeast,Mid-Atlantic</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_High_Level_Division__c</field>
            <operation>equals</operation>
            <value>Strategic &amp; Mid-Market</value>
        </criteriaItems>
        <description>Notifies Manager if a Solution Blueprint was created for an Opp over $25K for the Northeast, Southeast, and Mid-Atlantic Divisions</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CBI%3A Notify SA and Manager</fullName>
        <actions>
            <name>CBI_Notify_SA_and_Manager_of_CBI_Submission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CBI_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CBI%3A Outsource Product Manager</fullName>
        <actions>
            <name>CBI_Notify_Outsource_Product_Manager_of_CBI_Submission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies Outsource Product Manager that a Solution Blueprint was created for an Opportunity when Outsource is selected as the product.</description>
        <formula>INCLUDES(Products_to_Present__c,&quot;Outsource&quot;)&amp;&amp; OR(ISNEW(),ISCHANGED(Products_to_Present__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CBI%3A Populate Manager Email</fullName>
        <actions>
            <name>CBI_Populate_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Or(ISBLANK(Manager_Email__c),Manager_Email__c&lt;&gt; Opportunity__r.Owner.Manager.Email)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CBI%3A Populate SA Manager Email</fullName>
        <actions>
            <name>CBI_Populate_SA_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CBI_Form__c.SA_Manager_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CBI%3A Small Firms SA Lead</fullName>
        <actions>
            <name>CBI_Notify_Small_Firms_SA_Lead_of_CBI_Submission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CBI_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_High_Level_Division__c</field>
            <operation>equals</operation>
            <value>US Small Firms</value>
        </criteriaItems>
        <description>Notifies Small Firms SA Leadif a Solution Blueprint was created for an Opp</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
