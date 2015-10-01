(function() {
  var _, analize, databaseName, db, saveLocally, sqlite3;

  sqlite3 = require('sqlite3');

  databaseName = 'oee.db';

  _ = require('underscore');

  db = new sqlite3.Database('oee.db');

  saveLocally = function(object) {
    return db.serialize(function() {
      var stmt;
      db.run("create table if not exists oee ( id text, s_start_dt text, s_end_dt text, bu_id text, depto text, product text, process text, system_id text, sample_span_time text, build_qty text, avg_ct text, avail text, perf text, yield text, oee )");
      stmt = db.prepare("insert into oee (ID, S_START_DT, S_END_DT, BU_ID, DEPTO, PRODUCT, PROCESS, SYSTEM_ID, SAMPLE_SPAN_TIME, BUILD_QTY, AVG_CT, AVAIL, PERF, YIELD, oee) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
      console.log(_.values(_.keys(object)));
      return stmt.finalize();
    });
  };

  analize = function(data) {
    var i, j, k, k2, len, results, v, v2;
    console.log(data);
    results = [];
    for (j = 0, len = data.length; j < len; j++) {
      i = data[j];
      results.push((function() {
        var results1;
        results1 = [];
        for (k in i) {
          v = i[k];
          results1.push((function() {
            var results2;
            results2 = [];
            for (k2 in v) {
              v2 = v[k2];
              results2.push(saveLocally(v2));
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };

  module.exports = {
    analize: analize
  };

}).call(this);
