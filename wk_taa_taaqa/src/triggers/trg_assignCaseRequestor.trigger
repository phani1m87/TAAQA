trigger trg_assignCaseRequestor on Case (before insert,before update) 
{
 
    set<string> set_str = new set<string>();
    set<id> set_id = new set<id>();
    Map<String,id> map_emailwithUserid = new Map<String,id>();
    Map<id,Case> map_case = new map<id,case>();
    for(Case c:Trigger.New)
    {
       
            set_str.add(c.SuppliedEmail);
            set_id.add(c.id);
            map_case.put(c.id,c);
        
    }
    for(User u:[select id,email from User where email in:set_str])
    {
        map_emailwithUserid.put(u.email,u.id);
    }
    for(Case c:Trigger.New)
    {
        
        system.debug('Owner Name'+c.owner.name);
        if(c.ownerId=='00G3100000461nz')
        {
            String u_id=map_emailwithUserid.get(c.SuppliedEmail);
            Case objCase=map_case.get(c.id);
            system.debug('UserId'+u_id);
            if(!String.isBlank(u_id))
            {
            
                system.debug('inside If');
                objCase.Requestor__c=u_id;
                
            }
        }
    }
    
}