public class ImportApprovedFoodEstablishments {
    
    public void importData() {
        String url = 'https://fsaopendata.blob.core.windows.net/opendatacatalog/APMSMar25.csv';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            String csvContent = response.getBody();
            processCSV(csvContent);
        } else {
            System.debug('Failed to fetch CSV content. Status code: ' + response.getStatusCode());
        }
    }
    
    private static void processCSV(String csvContent) {
        List<Approved_Food_Establishments__c> recordsToInsert = new List<Approved_Food_Establishments__c>();
        Integer s = 0;
        Integer e = csvContent.indexOf('\n');
        Integer count = 0;
        while (e != -1) {
            if(count < 2) { // skip first 2 lines
                count++;
                s = e + 1;
                e = csvContent.indexOf('\n', s);
                continue;
            }
            String line = csvContent.substring(s, e);
            Approved_Food_Establishments__c record = processCSVLine(line);
            recordsToInsert.add(record);
            s = e + 1;
            e = csvContent.indexOf('\n', s);
        }
        if (!recordsToInsert.isEmpty()) {
            insert recordsToInsert;
        }
    }
    
    private static Approved_Food_Establishments__c processCSVLine(String line) {
        List<String> columns = line.split(',');
        Approved_Food_Establishments__c record = new Approved_Food_Establishments__c();
        record.AppNo__c = columns[0];
        record.TradingName__c = columns[1];
        record.Address1__c = columns[2];
        record.Address2__c = columns[3];
        record.Town__c = columns[4];
        record.Postcode__c = columns[5];
        record.Country__c = columns[6];
        record.All_Activities__c = columns[7];
        record.Cold_Store__c = columns[39];
        record.CompetentAuthority__c = columns[63];
        record.GeographicLocalAuthority__c = columns[64];
        return record;
    }
}
