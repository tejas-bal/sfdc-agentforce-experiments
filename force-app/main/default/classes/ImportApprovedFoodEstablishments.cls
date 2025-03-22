public class ImportApprovedFoodEstablishments {
    
    public void importData() {
        // Define the URL of the CSV file
        String url = 'https://fsaopendata.blob.core.windows.net/opendatacatalog/APMSMar25.csv';
        
        // Make the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        // Check the response status
        if (response.getStatusCode() == 200) {
            // Get the CSV content
            String csvContent = response.getBody();
            
            // Parse the CSV content
            List<Approved_Food_Establishments__c> recordsToInsert = new List<Approved_Food_Establishments__c>();
            List<String> csvLines = csvContent.split('\n');
            
            // Skip the header line
            for (Integer i = 1; i < csvLines.size(); i++) {
                String line = csvLines[i];
                List<String> columns = line.split(',');
                
                // Create a new record and set the fields
                Approved_Food_Establishments__c record = new Approved_Food_Establishments__c();
                record.AppNo__c = columns[0];
                record.TradingName__c = columns[1];
                record.Address1__c = columns[2];
                record.Address2__c = columns[3];
                record.Town__c = columns[4];
                record.Postcode__c = columns[5];
                record.Country__c = columns[6];
                record.All_Activities__c = columns[7];
                record.Cold_Store__c = columns[8];
                record.CompetentAuthority__c = columns[9];
                record.GeographicLocalAuthority__c = columns[10];
                
                recordsToInsert.add(record);
            }
            
            // Insert the records
            if (!recordsToInsert.isEmpty()) {
                insert recordsToInsert;
            }
        } else {
            System.debug('Failed to fetch CSV content. Status code: ' + response.getStatusCode());
        }
    }
}