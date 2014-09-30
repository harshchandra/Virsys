public class MyTest
{
    
   public string newLine{get{return '\n';}}
   public boolean displayPopup {get; set;}
   public List<WrapperSelectDOSCharges> lstPopUpView {get;set;}  /* stores wrappers to be shown in pop up */
   public List<WrapperSelectDOSCharges> lstWrapper{get;set;}		/* stores wrapper class instances */
   public boolean isError {get;set;}
   Public Integer noOfRecords{get; set;}
   Public Integer size{get;set;} /* stores the page size */
   public String contextItem{get;set;}
   List<WrapperSelectDOSCharges> lstWrapperTemp;
   private Set<Id> selectedDosIds;/* Stores Id of checked single checked record*/
   private ApexPages.StandardSetController setCon;
   List<Dates_of_Service__c> lstDOStoUpdate ;
   public Boolean isAllSelected{get;set;}
   public String strFacilityName;
  
   List<id> lstAllSelectedId;
   
   String tempStrQuery='Select Id ,';
   Boolean isTrue =false;
   String strQuery='Select Id ,';
   Set<id> setDeselected;
   private String sortDirection = 'ASC';
   private String sortExp ;
   private String strSortQuery;
   List<Bill_Amounts__c> lstBillAmount;
   Map<String,Decimal> maplocAmount;
   
   /* constructor */
   
   public MyTest()
   {
   	
   	   lstBillAmount=new List<Bill_Amounts__c>();
   	   maplocAmount=new Map<String,Decimal>(); /* stores Loc and Amount value of facility */
   	   selectedDosIds= new Set<Id>();
       isAllSelected=false;
       setDeselected=new set<Id>();
       lstWrapper = new List<WrapperSelectDOSCharges>();
       lstWrapperTemp = new List<WrapperSelectDOSCharges>();
       lstPopUpView = new List<WrapperSelectDOSCharges>();
       List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet('FieldsView', 'Dates_of_Service__c'); 
       
       for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
       {
         
          strQuery += fieldSetMemberObj.getFieldPath()+ ', ';
          tempStrQuery+= fieldSetMemberObj.getFieldPath()+ ', ';
          
        }
        
        strQuery = strQuery.removeEnd(', ');
        tempStrQuery=tempStrQuery.removeEnd(', ');
        String currentURL = URL.getCurrentRequestUrl().toExternalForm();
    	
    	/*getting the selected Facility name from URL*/
    	
        if(currentURL.contains('facility'))
    	{
    		strFacilityName = ApexPages.currentPage().getParameters().get('facility');
    	}
    	
    	strFacilityName='Forterus';
    	
        strSortQuery=strQuery+' '+'from Dates_of_Service__c where Status__c = null AND Start_Date__c <= Today AND Facility__c=\''+strFacilityName+'\'';
        StrQuery=StrQuery+' '+'from Dates_of_Service__c where Status__c = null AND Start_Date__c <= Today AND Facility__c=\''+strFacilityName+'\''+' '+'order by Start_Date__c Nulls Last  limit 10000';
        tempStrQuery=tempStrQuery+' '+'from Dates_of_Service__c where Status__c = \'Selected\' AND Start_Date__c <= Today  AND Facility__c=\''+strFacilityName+'\''+' '+ ' order by  Facility__c Nulls Last  limit 900';
       
        //Query on Bill Amount and storing Loc and its corresponding Amount to map
        
        lstBillAmount=[Select Amount__c,Level_of_Care__c,Facility__c from Bill_Amounts__c  where Facility__r.Name=:strFacilityName];
        
        if(lstBillAmount!=null)
        {
			for(Bill_Amounts__c objBa:lstBillAmount)
			{
				
					maplocAmount.put(objBa.Level_of_Care__c,objBa.Amount__c);
				
			}        
        }
        
       
        if(this.setCon == null){
        
            size = 40;
            if(Apexpages.currentPage().getParameters().get('Source') != 'Select' && String.valueOf(Apexpages.currentPage()).contains('TBN_View_Selected_DOS_charges'))
                this.setCon = new ApexPages.StandardSetController(Database.getQueryLocator(tempStrQuery));
            else
                this.setCon = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery));
            this.setCon.setPageSize(size);
            noOfRecords = this.setCon.getResultSize();
        
        }
   }
  	
  	/*This method is for assigning value to Inner class  */
  	
    public List<WrapperSelectDOSCharges> getDocWrapper()
    {
        lstWrapper = new List<WrapperSelectDOSCharges>();
        Decimal amount;
        System.debug('------setCon---------'+this.setCon.getRecords());
        if(setCon != null)
        {

            for(sObject objectDos:this.setCon.getRecords())
            {
                Dates_of_Service__c objDos=(Dates_of_Service__c)objectDos;
               
                
	             if(maplocAmount.containsKey(objDos.Level_of_Care__c))
					amount=maplocAmount.get(objDos.Level_of_Care__c);
				else
					amount=null;
					
					
				
               WrapperSelectDOSCharges objWrapperSelectDOSCharges=new WrapperSelectDOSCharges(objDos, false,amount);
                
                if(selectedDosIds.contains(objDos.Id))
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
        
      if(this.setCon.getRecords().isEmpty())
	  {
	  	isError = true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No records to display'));
        
	  }
	  
	 else 
	 	isError=false;
	  
        
        
      
        return lstWrapper;
        
    }
    
    /*Wrapper class */
    
     public class WrapperSelectDOSCharges
     {
         
         public Dates_of_Service__c objDatesOfService {get;set;}
         public Boolean isSelect{get;set;}
         public Decimal decAmout{get;set;}
         
         public WrapperSelectDOSCharges(Dates_of_Service__c obj,boolean isSelect,Decimal amount)
         {
             objDatesOfService=new Dates_of_Service__c();
             isSelect=false;
            
             
             objDatesOfService=obj;
             this.isSelect = isSelect;
             this.decAmout=amount;
         }
     }
     /* This method  update records matches the condition */
     
     public void updateStatusOfDOS()
     {
        Set<Id> setId=new Set<Id>();
        lstWrapperTemp.addAll(lstWrapper);
        lstWrapper.clear();
        
        if(!lstWrapperTemp.isEmpty())
        {
            for(WrapperSelectDOSCharges objwrapper : lstWrapperTemp)
            {
                if(objwrapper.isSelect)
                {   
                    if(!setId.Contains(objwrapper.objDatesOfService.Id))
                    {	
                        lstWrapper.add(objwrapper);
                        setId.add(objwrapper.objDatesOfService.Id);
                    }
                }
                
            }
            
        }
        
       		isTrue=true;
         	
     }
     
     /* logic to show selected records on popup */
     
     public void renderToViewSelectedDOScharges()
     {	
     	lstDOStoUpdate = new List<Dates_of_Service__c>();
 		lstPopUpView= new List<WrapperSelectDOSCharges>();
 		displayPopup = true;
        updateStatusOfDOS();
        List<WrapperSelectDOSCharges> lstpopupTemp=new List<WrapperSelectDOSCharges>();
        lstPopUpView.addAll(lstWrapper);
        
        If(!isAllSelected)
        {
		 	for(WrapperSelectDOSCharges objwrapper:lstPopUpView)
		 	{
			 	if(selectedDosIds.contains(objwrapper.objDatesOfService.Id) )
			 	{	
			 		lstpopupTemp.add(objwrapper);
			 		Dates_of_Service__c objDos=new Dates_of_Service__c(Id=objwrapper.objDatesOfService.Id);
			        objDos.Status__c = 'Selected';
			        objDos.Selected_DateTime__c = DateTime.Now();
			        lstDOStoUpdate.add(objDos);
			 		
			 	}
		 	}
        }
        else
        
        for(WrapperSelectDOSCharges objwrapper:lstPopUpView)
		{
			 		 if(objwrapper.isSelect && !setDeselected.contains(objwrapper.objDatesOfService.Id))
			 		 {
				 		lstpopupTemp.add(objwrapper);
				 		Dates_of_Service__c objDos=new Dates_of_Service__c(Id=objwrapper.objDatesOfService.Id);
				        objDos.Status__c = 'Selected';
				        objDos.Selected_DateTime__c = DateTime.Now();
				        lstDOStoUpdate.add(objDos);
			 		 }
			 		
			 	
		}
		
	
	 	
	  lstPopUpView.clear();
	  lstPopUpView.addAll(lstpopupTemp);
	 
	     
     }
     
     /* update records to Database */
     
     public Void Save()
     {
     	if(!lstDOStoUpdate.isEmpty())
            {
	            update lstDOStoUpdate;
	            lstDOStoUpdate.clear();
	            
            }
          
     	
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
    *   advance to next page
    */
    public void doNext(){
        
        If(isTrue==true)
        {	
        	this.setCon = new ApexPages.StandardSetController(Database.getQueryLocator(StrQuery));
        	this.setCon.setPageSize(size);
        	
        }
        lstWrapperTemp.addAll(lstWrapper);
        if(this.setCon.getHasNext())
            this.setCon.next();
            
 		isTrue=false;
    }
 
    /*
    *   advance to previous page
    */
    public void doPrevious(){
    	
 		If(isTrue==true)
        {	
        	this.setCon = new ApexPages.StandardSetController(Database.getQueryLocator(StrQuery));
        	this.setCon.setPageSize(size);
        	
        }
 		lstWrapperTemp.addAll(lstWrapper);
 		
        if(this.setCon.getHasPrevious())
            this.setCon.previous();
            lstWrapperTemp.addAll(lstWrapper);
            
            isTrue=false;
 
    }
    
    /*
    *   handle item selected 
    */
   public void doSelectItem(){ 
 	
        this.selectedDosIds.add(this.contextItem);
        if(setDeSelected.contains(this.contextItem))
        	setDeSelected.remove(this.contextItem);
        
 
    } 
 
    /*
    *   handle item deselected
    */ 
    public void doDeselectItem(){
  
        this.selectedDosIds.remove(this.contextItem);
        setDeSelected.add(this.contextItem);
 
    }
 
 	/*
    *   handle all item selected
    */ 
    /*
    public void doAllSelectItem()
    {
     for(sObject objectDos:this.setCon.getRecords())
        {
            Dates_of_Service__c objDos=(Dates_of_Service__c)objectDos;
    		this.selectedDosIds.add(objDos.Id);
        }
    }
    
    */
    /*
    *   return count of selected items
    */
    public Integer getSelectedCount(){
 
        return selectedDosIds.size();
 
    }
    
    Public Integer getTotalPages(){
 
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize(); 
 
        Decimal pages = totalSize/pageSize;
 
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
 
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  /*
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
  
    public void previous() {
        setCon.previous();
    }
  
    public void next() {
        setCon.next();
    }
     
 
 
    public void showPopup() {
        displayPopup = true;
    }
    
    */ 
    
    public void closePopup() {
        displayPopup = false;
    }
    public void selectAll()
    {	
    
       setDeselected=new set<Id>();
       lstWrapperTemp.addAll(lstWrapper);
    	system.debug('-------test-----'+lstWrapper.size());
    	
    	
    	
    }
    
    /* sorting logic starts here */
    
     public String sortExpression
   	 {
	     get
	     {
	        return sortExp;
	     }
	     set
	     {
	       //if the column is clicked on then switch between Ascending and Descending modes
	       if (value == sortExp)
	         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
	       else
	         sortDirection = 'ASC';
	       sortExp = value;
	     }
   		}
  	
	  public String getSortDirection()
	  {
	    //if not column is selected 
	    if (sortExpression == null || sortExpression == '')
	      return 'ASC';
	    else
	     return sortDirection;
	 }

	 public void setSortDirection(String value)
	 {  
	   sortDirection = value;
	 }
    
    
    public void sort()
    {
  		String strquery=strSortQuery;
    	String sortFullExp = ' '+'order by'+' '+sortExpression  + ' ' + sortDirection;
      	strquery=strSortQuery+' '+ sortFullExp+' '+'Nulls Last  limit 10000';
      	
       //query the database based on the sort expression
        this.setCon = new ApexPages.StandardSetController(Database.getQueryLocator(strquery));
        this.setCon.setPageSize(size);
        
       
   	}
    
 }