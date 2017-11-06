<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASR_and_T_C_Welcome_Call</fullName>
        <description>ASR and T&amp;C Welcome Call</description>
        <protected>false</protected>
        <recipients>
            <field>UserId</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/ASR_Welcome_Call</template>
    </alerts>
    <alerts>
        <fullName>KAC_Added_To_Opportunity</fullName>
        <description>KAC Added To Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>KAC - Professional Software</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Alerts/KAC_Added_To_Opportunity</template>
    </alerts>
</Workflow>
