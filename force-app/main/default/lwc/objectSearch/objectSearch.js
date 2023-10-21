import { LightningElement , api, track, wire} from 'lwc';
import GetDB from '@salesforce/apex/ObjectSearchController.GetDB';
import getFields from '@salesforce/apex/ObjectSearchController.getFields';

export default class ObjectSearch extends LightningElement {
    /*@api get ObjectName(){
        return this._objectName;
    }
    set ObjectName(value){
        this._objectName = value;
    }*/
    @api objectName;
    @track ResponseWrappper;
    @track fieldWrappper;
    @track finalSObjectDataList;
    @track inpvalue=[];

    //get the input fields to be displayed
    connectedCallback(){
        getFields({ObjectName:this.objectName}).then(result=>{
            this.fieldWrappper = result;
            
        }).catch(error => {
            console.log('Error: ' +error);
        }
        )
    }

    //transform the lookup fields
    fieldTransformation = (fieldValue, finalSobjectRow, fieldName) => 
    {        
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => 
        {
            let finalKey = fieldName + '.'+ key;
            finalSobjectRow[finalKey] = fieldValue[key];
        })
    }

    

    @track searchText;
    searchText1='';
    //called when search button is called. Object name and search expression passed to the apex controller
    SearchData(event){
        //this.searchText=this.template.querySelectorAll('lightning-input').value;
        var input = this.template.querySelectorAll('lightning-input');
        
        input.forEach(function(element){
            this.searchText1=this.searchText1+element.value;
        }, this);
        //console.log('searchText: '+searchText1);
        //this.searchText='Dickenson plcSVP, Operationsa_young@dickenson.com';
        GetDB({ObjectName: this.objectName, searchExp: this.searchText1}).then(result=>{
            if(result){
                let sObjectRelatedFieldListValues = [];
                for (let row of result.lstDataTableData) 
                {
                    const finalSobjectRow = {}
                    let rowIndexes = Object.keys(row); 
                    rowIndexes.forEach((rowIndex) => 
                    {
                        const relatedFieldValue = row[rowIndex];
                        if(relatedFieldValue.constructor === Object)
                        {
                            this.fieldTransformation(relatedFieldValue, finalSobjectRow, rowIndex)        
                        }
                        else
                        {
                            finalSobjectRow[rowIndex] = relatedFieldValue;
                        }
                        
                    });
                    sObjectRelatedFieldListValues.push(finalSobjectRow);
                }
                this.ResponseWrappper = result;
                this.finalSObjectDataList = sObjectRelatedFieldListValues;
                this.searchText1='';
            }
            else if (error) 
            {
                //this.error = error;
                console.error("Error "+error.body.message);//
            }
        }
        ).catch(error=>{
            console.error("Error ");//+error.body.message
        });
        
    }
    //called when reset button is clicked
    ResetSearch(event){
        this.inpvalue=[];
        this.searchText1='';
        this.finalSObjectDataList ='';
    }
}