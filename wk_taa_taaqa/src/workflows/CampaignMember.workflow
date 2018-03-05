<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Campaign_Member_Added_to_Lead</fullName>
        <description>New Campaign Member Added to Lead</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/New_Campaign_Member_Added</template>
    </alerts>
    <fieldUpdates>
        <fullName>Comment_Updates</fullName>
        <field>Comments__c</field>
        <formula>CurrCampaign_Comment__c</formula>
        <name>Comment Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign Member Comments Update</fullName>
        <actions>
            <name>Comment_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CampaignMember.CreatedById</field>
            <operation>equals</operation>
            <value>hubspot integrationuser,Pardot Pardot Connector</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Campaign Member Added</fullName>
        <actions>
            <name>New_Campaign_Member_Added_to_Lead</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
