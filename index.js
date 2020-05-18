var key = '';
var baseKey = '';

var app = require('express')();
var Airtable = require('airtable');
Airtable.configure({
    endpointUrl: 'https://api.airtable.com',
    apiKey: key
});
var base = Airtable.base(baseKey);

app.get('/', (req, res) => {
    base('Table 1').select({
        view: 'Grid view'
    }).firstPage(function(err, records) {
        if (err) { console.error(err); return res.json({}); }
        records.forEach(function(record) {
            console.log('Retrieved', record.get('Name'));
        });
        return res.json(records);
    });
    
});

app.listen(3000,() => { console.log("3000"); });
