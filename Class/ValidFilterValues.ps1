
class ValidFilterValues : System.Management.Automation.IValidateSetValuesGenerator { 
    [string[]] GetValidValues() { 
        $Result = terraform state list 
        return $Result
    }
}
