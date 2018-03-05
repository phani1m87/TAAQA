<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>User_Has_Hire_Date_in_the_Future</fullName>
        <description>User Has Hire Date in the Future</description>
        <protected>false</protected>
        <recipients>
            <recipient>alex.cardona@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/User_Hire_Date_Incorrect</template>
    </alerts>
    <fieldUpdates>
        <fullName>First_Quota_Month_Overridden</fullName>
        <field>First_Month_Quota_Override_Change__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName + &quot;: &quot; + TEXT(TODAY())</formula>
        <name>First Quota Month Overridden</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>First Quota Month overridden</fullName>
        <actions>
            <name>First_Quota_Month_Overridden</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>captures the person changing the first month a rep is on quota</description>
        <formula>ISCHANGED( First_Month_of_Quota_Override__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User given Hire Date in future</fullName>
        <actions>
            <name>User_Has_Hire_Date_in_the_Future</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>The user was given a hire date in the future</description>
        <formula>OR(ISNEW() = TRUE &amp;&amp; Tenure__c = &quot;Check the Date!&quot;,
   ISCHANGED(Tenure__c) &amp;&amp; Tenure__c= &quot;Check the Date!&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
