/*
 Author : Venkata Sabbella
 Last Modified: 12/29/2014
*/

public with sharing class OpportunityLineItemHelper {
    
    public static map<string,boolean> opportunityLineItemTriggerMap= new map<string,boolean>{'beforeinsert'=>false 
                                                                                   };
                                                                                   
    public void adjustOppyLineItemPrices(list<OpportunityLineItem> newList)
    {
     // get the line items for which the option price should be zeroed out  
     //list<OpportunityLineItem> reportingList=includeInReporting(newList);
     /*for(OpportunityLineItem oppyLineItem: newList)
     {
      oppyLineItem.TotalPrice= (oppyLineItem.TotalPrice!=null)?(oppyLineItem.TotalPrice/oppyLineItem.SellingTerm__c):0;
     }*/
     System.debug('i was here');
     //list<OpportunityLineItem> annaulisedSellingTermList=annualizeST( newList);
     list<OpportunityLineItem> filteredList=filterOppyLineItems(newList); 
     for(OpportunityLineItem oppyLineItem: filteredList)
     {
        //oppyLineItem.addError('-->'+filteredList.size());
      // get the filed on the OppyLineItem to zero out
       //oppyLineItem.NetPrice__c=0;
       //oppyLineItem.Dev_Comments__c='BI fired 1';
      // oppyLineItem.ExtendedPrice__c=0;
       //oppyLineItem.AdjustedPrice__c=0;
       //oppyLineItem.BasePrice__c=0;
       
       //Abi - 01/11/2017 Bypass Steelbrick Quote Oppty Product  
       if(!oppyLineItem.Steelbrick_Quote__c) {
       		oppyLineItem.TotalPrice=0; 
       		oppyLineItem.Include_in_Reporting__c=false;
       }
     }
     for(OpportunityLineItem oppyLineItem: newList)
     {
      // oppyLineItem.TotalPrice= (oppyLineItem.TotalPrice!=null && oppyLineItem.SellingTerm__c!=null)?(oppyLineItem.TotalPrice/oppyLineItem.SellingTerm__c):0;
      //Abi - 01/11/2017 Bypass Steelbrick Quote Oppty Product
      if(!oppyLineItem.Steelbrick_Quote__c) {
      		if(oppyLineItem.SellingTerm__c!=0 && oppyLineItem.SellingTerm__c!=null)
          		oppyLineItem.TotalPrice= (oppyLineItem.TotalPrice!=null)?(oppyLineItem.TotalPrice/oppyLineItem.SellingTerm__c):0;
      		else 
          		oppyLineItem.TotalPrice= (oppyLineItem.TotalPrice!=null)?oppyLineItem.TotalPrice:0;
      }
     }
    }
    
    public  list<OpportunityLineItem> filterOppyLineItems(list<OpportunityLineItem> newList)
    {
        // Specify the criteria for which the price should be zero
        list<OpportunityLineItem> filterlist=new list<OpportunityLineItem>();
        for(OpportunityLineItem oppyLineItem:newList)
        {
         //oppylineItem.addError('test');
         //check if the product config type is equal to option.
         //oppyLineItem.NetPrice__c=0;
         //Update the criteria.
         string s;
         system.debug('LineType:'+oppyLineItem.LineType__c);
          system.debug('ProductLine'+oppyLineItem.APTPS_Product_Line__c+'Product ConfigType:'+oppyLineItem.Product_Config_Type__c);
          if(oppyLineItem.APTPS_Product_Line__c!=null && oppyLineItem.Product_Config_Type__c!=null && oppyLineItem.LineType__c!=null)
          {
                //oppylineItem.addError('test'+oppyLineItem);
                /*
                  Changes: 
                  Zero out no matter what the year is
                */
               system.debug('LineType:'+oppyLineItem.LineType__c);
               if(oppyLineItem.LineType__c.equals('Product/Service'))
                {   
                     if(oppyLineItem.Product_Config_Type__c!=null && oppyLineItem.Product_Config_Type__c.equals('Standalone'))
                     {
                     oppyLineItem.TotalPrice= oppyLineItem.NetPrice__c;
                     }
                     else{
                         if(oppyLineItem.APTPS_Product_Line__c.equals('Research & Learning')
                             || oppyLineItem.APTPS_Product_Line__c.equals('Books')
                            )
                         continue;                     
                         else
                         filterlist.add(oppyLineItem);
                        } 
                  
                }
                
                else if(oppyLineItem.LineType__c.equals('Option')){
                            if(oppyLineItem.APTPS_Product_Line__c.equals('Software')
                                || oppyLineItem.APTPS_Product_Line__c.equals('Corporate Indirect Software (STG)')
                               )
                               continue;
                               else
                               filterlist.add(oppyLineItem); 
                               
                }                  
             }//End of if
          }//END of for
        return filterlist; 
         
        }   //END of Method
        
        
     
    }