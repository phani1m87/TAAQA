/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_AccountTriggerHandler 
{
	// **** Logic to create/update the account team for given accounts
	
	public static void generateAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap)
	{
		// *** invoke delegator method to generate Account Team
		// * trigger newMap 
		// * trigger oldMap 
		// * boolean : decides whether delete all and recreate or just insert / update 
		ATA_AccountTeamHandler.generateAccountTeam(newMap, oldMap, true);
	}
}