/*
	Author: Sharath Jayaraj (sh.sharath@gmail.com)
	Date: 05-13-2023
	Purpose: this class is used to dynamically control the LWC features of objectSearch
 */
public class ObjectSearchController {
	@AuraEnabled(cacheable=true)
    public static Datatableresp GetDB(String ObjectName,String searchExp){
        //pass the fields & data related to the object name and search expression passed from LWC
        system.debug('searchExp: ' + searchExp);
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
        List<string> lstColumn = new List<string>();
        List<string> lstfieldName = new List<string>();
        List<SObject> lstDataTableData = new List<SObject>();
        
        Data_Search__mdt dsmeta = [SELECT Id,Field_Values__c,Field_Header__c,DeveloperName,Object_Name__c,SOQL__c FROM Data_Search__mdt WHERE DeveloperName=:ObjectName];
        
        if(dsmeta.Field_Header__c != null){
            lstColumn = dsmeta.Field_Header__c.split(',');
        }
        if(dsmeta.Field_Values__c != null){
            lstfieldName = dsmeta.Field_Values__c.split(',');
        }
        for(integer i = 0; i < lstColumn.size(); i++){
            DataTableColumns datacolumns = new DataTableColumns( lstColumn[i].trim() , 
                                                                lstfieldName[i].substringBefore(':').trim(), 
                                                                lstfieldName[i].substringAfter(':').trim());
            lstDataColumns.add(datacolumns);
        }
        //string searchExp='\'Dickenson plcSVP, Operationsa_young@dickenson.com\'';
        //string searchExp='Dickenson plcSVP, Operationsa_young@dickenson.com';
        String refinedquery = dsmeta.SOQL__c+'\''+searchExp+'\'';
        //String refinedquery = 'SELECT '+ dsmeta.Field_Header__c+' FROM '+ ObjectName +' WHERE Search_Expression__c=\'Dickenson plcSVP, Operationsa_young@dickenson.com\'' ;
        system.debug('refinedquery' + refinedquery);
        for(SObject SObjectItem : Database.query(refinedquery))
        {
            lstDataTableData.add(SObjectItem);
        }
        system.debug('lstDataTableData' + lstDataTableData);
        
        Datatableresp finalWrapper = new Datatableresp();
        finalWrapper.Title = dsmeta.Object_Name__c;
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData = lstDataTableData;
        return finalWrapper;
    }
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        
        public DataTableColumns(String label, String fieldName, String type)
        {
            this.label     = label;
            this.fieldName = fieldName;
            this.type      = type;          
        }
    }
    public class Datatableresp {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public String Title {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}
    }
    @AuraEnabled
	public static List<Object_Search__mdt> getFields(string ObjectName){
        //return the fields to be enabled in the search inputs
		return [SELECT Id,No_of_Search_Fields__c,Search_Fields__c,DeveloperName,Object_Name__c FROM Object_Search__mdt WHERE Object_Name__c=:ObjectName order by No_of_Search_Fields__c];
	}
}