public class TBN_Select_DOS_ChargesTest
{
   public List<WrapperSelectDOSCharges> lstWrapper;
   public List<Dates_of_Service__c> lstTempViewLatest;
   public List<WrapperSelectDOSCharges> lstWrapperToView;
   public boolean isError {get;set;}
   public String contextItem{get;set;}
   List<WrapperSelectDOSCharges> lstWrapperTemp;
   private Set<Id> selectedDosIds;
   String tempStrQuery='Select Id ,';
   
   	public boolean isCalledFromClass	{get; set;}
   	public List<WrapperSelectDOSCharges> lstwrapperToShowOnPage	{get;set;}
    // State for Pagination
    public Integer 					PageSize {get; set;} 						// number of rows per page. 
    public Integer 					page	{get; set;}							// current page
    public Integer 					LastPage{get; set;}							// Index to last page
    private Integer 				TotalRows; 									// total rows in all pages.
    private Integer 				StartIndex ;
	private Integer 				EndIndex ;
   
   public TBN_Select_DOS_ChargesTest()
   {
   		lstwrapperToShowOnPage = new List<WrapperSelectDOSCharges>();
        lstWrapper = new List<WrapperSelectDOSCharges>();
        this.selectedDosIds= new Set<Id>();
        String strQuery='Select Id ,';
        lstWrapperTemp = new List<WrapperSelectDOSCharges>();
        lstTempViewLatest =new List<Dates_of_Service__c>(); 
        List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet('FieldsView', 'Dates_of_Service__c');  for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        {
          system.debug('API Name ====>' + fieldSetMemberObj.getFieldPath()); //API Name
          strQuery += fieldSetMemberObj.getFieldPath()+ ', ';
          tempStrQuery+= fieldSetMemberObj.getFieldPath()+ ', ';
          
        }
        
        strQuery = strQuery.removeEnd(', ');
        tempStrQuery=tempStrQuery.removeEnd(', ');
        StrQuery=StrQuery+' '+'from Dates_of_Service__c where Status__c = null AND Start_Date__c <= Today   order by  Facility__c Nulls Last limit 10000';
        tempStrQuery=tempStrQuery+' '+'from Dates_of_Service__c where Status__c = \'Selected\' AND Start_Date__c <= Today   order by  Facility__c Nulls Last  limit 900';
        
        if(Apexpages.currentPage().getParameters().get('Source') != 'Select' && String.valueOf(Apexpages.currentPage()).contains('TBN_View_Selected_DOS_charges'))
	        lstTempViewLatest = Database.query(tempStrQuery);
	    else
	        lstTempViewLatest = Database.query(StrQuery);
	        
       docWrapperrecords();
       initPagination(lstWrapper);
   }
   
    
    public void docWrapperrecords()
    {
        lstWrapper = new List<WrapperSelectDOSCharges>();
        
        if(lstTempViewLatest != null)
        {
            
            for(Dates_of_Service__c objectDos : lstTempViewLatest)
            {
                WrapperSelectDOSCharges objWrapperSelectDOSCharges = new WrapperSelectDOSCharges(objectDos, false);
                
                if(this.selectedDosIds.contains(objectDos.Id))
                 {
                        objWrapperSelectDOSCharges.isSelect=true;
                 }
                else
                {
                    
                    objWrapperSelectDOSCharges.isSelect=false;
                }
                
                lstWrapper.add(objWrapperSelectDOSCharges);
                
                }
        }
         system.debug('%%%%lstWrapper.size()%%%%%%%%% : '+lstWrapper.size());
    }
    
     public class WrapperSelectDOSCharges
     {
         
         public Dates_of_Service__c objDatesOfService {get;set;}
         public Boolean isSelect{get;set;}
         
         public WrapperSelectDOSCharges(Dates_of_Service__c obj,boolean isSelect)
         {
             objDatesOfService=new Dates_of_Service__c();
             isSelect=false;
             
             objDatesOfService=obj;
             this.isSelect = isSelect;
         }
     }
     
     public void updateStatusOfDOS()
     {
        Set<Id> setId=new Set<Id>();
        List<Dates_of_Service__c> lstDOStoUpdate = new List<Dates_of_Service__c>();
        lstWrapperToView= new List<WrapperSelectDOSCharges>();
        lstWrapperTemp.addAll(lstWrapper);
        lstWrapper.clear();
        
        if(!lstWrapperTemp.isEmpty())
        {
            for(WrapperSelectDOSCharges objwrapper : lstWrapperTemp)
            {
                if(objwrapper.isSelect)
                {   
                    system.debug('--------objwrapper--'+objwrapper.objDatesOfService.Id);
                    
                    if(!setId.Contains(objwrapper.objDatesOfService.Id))
                    {
                        objwrapper.objDatesOfService.Status__c = 'Selected';
                        objwrapper.objDatesOfService.Selected_DateTime__c = DateTime.Now();
                        lstDOStoUpdate.add(objwrapper.objDatesOfService);
                        lstWrapper.add(objwrapper);
                        setId.add(objwrapper.objDatesOfService.Id);
                    }
                }
            }
            system.debug('=====================> ' +lstWrapper);
        }
        else
        {
            isError = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select atleast one record for Save operation'));
        }
        
        if(!lstDOStoUpdate.isEmpty())
            system.debug('lstDOStoUpdate==============================>>>' +lstDOStoUpdate);
            update lstDOStoUpdate;
          
       
        
     }
     
     public Pagereference renderToViewSelectedDOScharges()
     {
        
        updateStatusOfDOS();
        system.debug('==========selectedDosIdsr===========> ' +selectedDosIds);
        Pagereference objPagereference = new Pagereference('/apex/TBN_View_Selected_DOS_charges?Source=Select');
        objPagereference.setRedirect(false);
        system.debug('==========lstWrapperlstWrapperlstWrapperlstWrapperlstWrapperlstWrapper===========> ' +objPagereference);
        return objPagereference; 
     }
     
     public Pagereference ExportPdf() 
     {
        Pagereference objPagereference = new Pagereference('/apex/TBN_ExportToCsv');
        objPagereference.setRedirect(false);
        return objPagereference; 
     }
     
     public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
      
        return fieldSetObj.getFields(); 
    } 
    
    /*
    *   handle item selected
    */
    public void doSelectItem()
    {
        this.selectedDosIds.add(this.contextItem);
    }
 
    /*
    *   handle item deselected
    */
    public void doDeselectItem()
    {
        this.selectedDosIds.remove(this.contextItem);
    }
 
 
 	/* Pagination logic started */
 	private void initPagination(List<WrapperSelectDOSCharges> lstWrapper) {
	
	    page=1; 																								//initally page is 1. 
	    PageSize = 20;																							// no. of rows you want to show per page
	   	TotalRows = lstWrapper.size();																			// total rows to be spanned across pages
	    
	    LastPage = Math.mod(TotalRows, PageSize) == 0 ? TotalRows / PageSize : TotalRows / PageSize + 1;		// calculate the index of last page
	    
	    StartIndex = 0;
        EndIndex = StartIndex + PageSize;
        
        fetchRecords(lstWrapper);																	// PROVIDE VALUES TO DISPLAY IN RECORDS
	}
	
	 /* get values to display on page */
    public void fetchRecords(List<WrapperSelectDOSCharges> lstWrapper)
    {
		system.debug('=====================> ' +lstWrapper.size());
		
		system.debug('StartIndex========================> ' +StartIndex);
		
		system.debug('EndIndex=========================> ' +EndIndex);
		
		
		lstwrapperToShowOnPage.clear();
		
		for(Integer index = StartIndex; index < EndIndex && index < lstWrapper.size(); index++)
		{
			lstwrapperToShowOnPage.add(lstWrapper[index]);
		}
		
		system.debug('lstwrapperToShowOnPage.size()================>>> ' +lstwrapperToShowOnPage.size());
		
    }
    
	
	//navigates to first page
    public void firstPage() { 
        
        page=1;
        StartIndex = 0;
        EndIndex = StartIndex + PageSize;
        
        fetchRecords(lstWrapper);
        
        isCalledFromClass = true;
    }
	
	 //navigates to next page
    public void nextPage() {
        
        if(TotalRows== 0) return;
        
        if(StartIndex + PageSize <= TotalRows && page < lastPage) {
        
        	StartIndex += PageSize;
        	EndIndex = StartIndex + PageSize;
        	
        	fetchRecords(lstWrapper);
        	
        	page++;
        }
        else if(page >= lastPage) {
        	
        	lastPage();
        }
        
        isCalledFromClass = true;
    }
	
	//navigates to previous page
    public void previousPage() {
        
        if(StartIndex - PageSize >= 0 && page > 1 && page <= lastPage) {
            
            StartIndex -= PageSize ;
            EndIndex = StartIndex + PageSize;
            
            fetchRecords(lstWrapper);
            
           	page--;
        }
        else {
        	
        	firstPage();
        }
        
        isCalledFromClass = true;
    }
 	
    //navigates to last page
    public void lastPage() {    
        
	    // calculate the index of last page
	    page = LastPage ;
	    
	    StartIndex = (LastPage - 1) * PageSize;
        EndIndex = TotalRows;
        
        fetchRecords(lstWrapper);
        
        isCalledFromClass = true;
    }
    
  	public void goToPage() {
		
     	if(page > LastPage) {
			
			page = LastPage;
			
			StartIndex = (page - 1) * PageSize;
			EndIndex = TotalRows;
			
		} 
      	else if(page <= 0){
      		 
      		 page=1;
      		 StartIndex = 0; 
      		 EndIndex = StartIndex + PageSize;	
      	}	 	
      	else{
      		
      		StartIndex = ((page-1) * PageSize);
      		EndIndex = StartIndex + PageSize;
      	}
      	
      	isCalledFromClass = true;
	}

}