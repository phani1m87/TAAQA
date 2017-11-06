<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Cancellation_Notification_to_New_Case_Owner</fullName>
        <description>Cancellation Notification to New Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Cancellation_Process</template>
    </alerts>
    <alerts>
        <fullName>Sales411_Case_Changed_PCS</fullName>
        <ccEmails>TAA-PCS411@wolterskluwer.com</ccEmails>
        <description>Sales411 Case Changed - PCS</description>
        <protected>false</protected>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_PCS_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sales411_Case_Closure_Notification</fullName>
        <description>Sales411 Case Closure Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Sales411_Case_Picked_Up</fullName>
        <description>Sales411 Case Picked Up</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Picked_Up</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Corporate_Indirect_STG</fullName>
        <description>Sales411 New Case Creation - Corporate Indirect (STG)</description>
        <protected>false</protected>
        <recipients>
            <recipient>nick.blama@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Implementation_System_Requirements_Service_Recommenda</fullName>
        <description>Sales411 New Case Creation - Implementation, System Requirements, Service Recommendations</description>
        <protected>false</protected>
        <recipients>
            <recipient>aaron.seeman@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jon.detwiler@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Order_Validation_and_Scheduling</fullName>
        <description>Sales411 New Case Creation - Order Validation and Scheduling</description>
        <protected>false</protected>
        <recipients>
            <recipient>liz.catalanotti@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_PCS</fullName>
        <ccEmails>TAA-PCS411@wolterskluwer.com</ccEmails>
        <description>Sales411 New Case Creation - PCS</description>
        <protected>false</protected>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_ProServ_Conversions</fullName>
        <description>Sales411 New Case Creation - ProServ Conversions</description>
        <protected>false</protected>
        <recipients>
            <recipient>john.conway@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kevin.curry@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Professional_Service_Calculator_Statements_of_Work</fullName>
        <description>Sales411 New Case Creation - Professional Service Calculator, Statements of Work</description>
        <protected>false</protected>
        <recipients>
            <recipient>aaron.seeman@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john.conway@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jon.detwiler@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kevin.curry@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_R_L</fullName>
        <description>Sales411 New Case Creation - R&amp;L</description>
        <protected>false</protected>
        <recipients>
            <recipient>nick.blama@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_SFS</fullName>
        <description>Sales411 New Case Creation - SFS</description>
        <protected>false</protected>
        <recipients>
            <recipient>kimberly.rich@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Small_Firm_Services</fullName>
        <description>Sales411 New Case Creation - Small Firm Services</description>
        <protected>false</protected>
        <recipients>
            <recipient>kimberly.rich@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Software_Corporate_Software_CPA</fullName>
        <description>Sales411 New Case Creation - Software (Corporate) &amp; Software (CPA)</description>
        <protected>false</protected>
        <recipients>
            <recipient>adam.chauvin@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>guillermo.rodriguez@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kara.hedrick@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mark.collins@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ray.schwarz@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Tax</fullName>
        <description>Sales411 New Case Creation - Tax</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.kallman@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.kokes@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Tax_Conversions</fullName>
        <description>Sales411 New Case Creation - Tax Conversions</description>
        <protected>false</protected>
        <recipients>
            <recipient>jan.freer@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kevin.coon@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Case_Creation_Workflow</fullName>
        <description>Sales411 New Case Creation - Workflow</description>
        <protected>false</protected>
        <recipients>
            <recipient>cristina.dudley@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john.kingsley@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Sales411_New_Email_Received</fullName>
        <description>Sales411 New Email Received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sales411responses@wolterskluwer.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Email_Alerts/Sales411_New_email_received</template>
    </alerts>
    <alerts>
        <fullName>Sales_Support_Assigned_to_Support_Rep</fullName>
        <description>Sales Support - Assigned to Support Rep</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Sales_Support_Assigned_to_Support_Rep</template>
    </alerts>
    <alerts>
        <fullName>Sales_Support_Case_Closed</fullName>
        <description>Sales Support: Case Closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Sales_Support_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Sales_Support_Case_Creation</fullName>
        <description>Sales Support Case Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrea.coca@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cyndi.morris@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nathan.sultemeier@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peter.cherr@wolterskluwer.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tony.truong@wolterskluwer.com.taaprod</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Sales_Support_New_Case</template>
    </alerts>
    <alerts>
        <fullName>Sales_Support_Case_Creation_Rep_Notification</fullName>
        <description>Sales Support Case Creation - Rep Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Sales_Support_Case_Created_Rep_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sales_Support_Case_Picked_Up</fullName>
        <description>Sales Support: Case Picked Up</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/Sales_Support_Case_Picked_Up</template>
    </alerts>
    <fieldUpdates>
        <fullName>Cancellation_Case_Received</fullName>
        <field>Status</field>
        <literalValue>Submitted For Approval</literalValue>
        <name>Cancellation Case Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cancellation_Request_Opp_Creation</fullName>
        <field>Cancellation_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Cancellation Request Opp Creation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cancellation_Status_Submitted</fullName>
        <field>Status</field>
        <literalValue>Submitted For Approval</literalValue>
        <name>Cancellation Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cancellation_Status_Working</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Cancellation Status Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Closed</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Case Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Has_Been_Escalated</fullName>
        <field>Has_Been_Escalated__c</field>
        <literalValue>1</literalValue>
        <name>Case Has Been Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales411_Hours_until_picked_up</fullName>
        <field>Time_Picked_Up__c</field>
        <formula>NOW()</formula>
        <name>Sales411 - Hours until picked up</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales411_Status_Received</fullName>
        <field>Status</field>
        <literalValue>Received</literalValue>
        <name>Sales411 - Status = Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Submitted_Approved</fullName>
        <field>Time_Submitted_Approved__c</field>
        <formula>NOW()</formula>
        <name>Time Submitted/Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Cancellation Notification</fullName>
        <actions>
            <name>Cancellation_Notification_to_New_Case_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED( OwnerId ),  RecordType.Id = &quot;01231000001IeLr&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Has Been Escalated</fullName>
        <actions>
            <name>Case_Has_Been_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( IsEscalated ) 
&amp;&amp; PRIORVALUE( IsEscalated ) = FALSE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Support - Case Assigned</fullName>
        <actions>
            <name>Sales_Support_Case_Picked_Up</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status)  &amp;&amp; ISPICKVAL(Status, &quot;Working&quot;)  &amp;&amp; RecordType.Id = &quot;0120Z000001NZcy&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Support - Case Closed</fullName>
        <actions>
            <name>Sales_Support_Case_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status)  &amp;&amp; IsClosed = TRUE &amp;&amp; RecordType.Id = &quot;0120Z000001NZcy&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Support - New Case</fullName>
        <actions>
            <name>Sales_Support_Case_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales Support - New Case Rep Notification</fullName>
        <actions>
            <name>Sales_Support_Case_Creation_Rep_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales Support - Support Rep Assigned</fullName>
        <actions>
            <name>Sales_Support_Assigned_to_Support_Rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( OwnerId ), RecordType.Id = &quot;0120Z000001NZcy&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales411 - Hours until picked up</fullName>
        <actions>
            <name>Sales411_Hours_until_picked_up</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK( Time_Picked_Up__c ) &amp;&amp;  
ISCHANGED( Status ) &amp;&amp;
RecordTypeId = &quot;01231000001IeLq&quot; &amp;&amp; 
NOT( ISPICKVAL(Status, &quot;Escalated&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales411 Case Closed Notification</fullName>
        <actions>
            <name>Sales411_Case_Closure_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( ISCHANGED( IsClosed ) ,  
     RecordType.Id = &quot;01231000001IeLq&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales411 Case Picked Up</fullName>
        <actions>
            <name>Sales411_Case_Picked_Up</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED( OwnerId ) ,  
     RecordType.Id = &quot;01231000001IeLq&quot;,
     IsClosed = FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales411 New Case Notification - R%26L</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales411</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Business_Segment__c</field>
            <operation>equals</operation>
            <value>R&amp;L</value>
        </criteriaItems>
        <description>Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales411 Notification on new email received</fullName>
        <actions>
            <name>Sales411_New_Email_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Emails_Received_Count__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
