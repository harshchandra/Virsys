/*
This base class enables its implementor to have the below two types of paginators 
1) paginator that gives links "<< First , < Previous, Next > , Last >>" in grid footer.
2) paginator that gives the specific page links like "1 2 3 4 5 6 7 8 ..." with which user can directly navigate to the page he wishes to.
Note: Currently the paginator type 1 referred above is implemented in "Assignment Manager" screens and "Campaign Call Down(Customized)". Paginator type 2 is implemented in "Support Center" pages.
*/
public abstract class TBN_Paginator
{
    public Integer FirstPage        {get; set;} // first row number in the list.
    public Integer PageSize         {get; set;} // number of rows per page. //previously currentPageCount.
    public Integer LastPage         {get; set;} // row index of the first record the in the last page.
    public Integer TotalRows        {get;set;} // total rows in all pages.    
    public Integer currentPageNum   {get;set;} // current page number user viewing.
    public String displayResult     {get;set;} // friendly text displayed in footer/paginator area to let user know the range of rows he is viewing at present.
    
    //navigates to previous page
    public void previousPage()
    {
    	system.debug('=======TotalRows======'+TotalRows);
    	system.debug('======PageSize======='+PageSize);
    	system.debug('======FirstPage======='+FirstPage);
    	
        if(FirstPage - PageSize >= 0)
        {
            FirstPage -= PageSize ;
            displayResult = 'Displaying '+ (FirstPage + 1) + '-' + (FirstPage + PageSize) +' Results';
        }
    }
    
    //navigates to last page
    public void lastPage()
    {
        FirstPage = calcLastPage();
        displayResult = 'Displaying ' + (FirstPage + 1) + ' - ' + TotalRows +' Results';        
    }
    
    //calculates page number of last page
    private Integer calcLastPage()  
    {
        if(TotalRows >= PageSize )
        {            
            return (LastPage-1)* PageSize; 
        }
        else
        {
            return 0;
        }
    } 
    
    //navigates to next page
    public void nextPage()
    {
    	system.debug('=======TotalRows======'+TotalRows);
    	system.debug('======PageSize======='+PageSize);
    	system.debug('======FirstPage======='+FirstPage);
    	
        if(TotalRows== null || PageSize == null) return;
        if(FirstPage + PageSize < TotalRows)
        {
            FirstPage += PageSize ;
            if((FirstPage + PageSize) <= TotalRows)
                displayResult = 'Displaying '+ (FirstPage + 1) + ' - ' + (FirstPage + PageSize) +' Results';
            else
                 displayResult = 'Displaying ' + (FirstPage + 1) + ' - ' + TotalRows +' Results';
        }
        system.debug('%%%%FirstPage%%%'+FirstPage);
    }
    
    //navigates to first page
    public void firstPage()
    {
        FirstPage = 0;
        displayResult = 'Displaying '+ (FirstPage + 1) + ' - ' + (FirstPage + PageSize) +' Results';
    }   
    
    //navigates to specific page
    public void specificPage()
    {
        FirstPage = (currentPageNum -1) * PageSize;
           if((FirstPage + PageSize) <= TotalRows)
                displayResult = 'Displaying '+ (FirstPage + 1) + ' - ' + (FirstPage + PageSize) +' Results';
            else
                 displayResult = 'Displaying ' + (FirstPage + 1) + ' - ' + TotalRows +' Results';
        
    }
}