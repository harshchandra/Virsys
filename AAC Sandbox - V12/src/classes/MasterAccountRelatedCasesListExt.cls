public class MasterAccountRelatedCasesListExt {
public List<Case> cases {get;set;}

    public MasterAccountRelatedCasesListExt(ApexPages.StandardController controller) {
        cases = [select id,Account.Name,casenumber,createddate,status,ownerid FROM Case Where Account.Parent_Account__r.Id = :ApexPages.currentPage().getParameters().get('id') AND IsDeleted = false order by createddate desc LIMIT 20];
    }

}