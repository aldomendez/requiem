<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>OEE dashboard</title>
  <link rel="stylesheet" type="text/css"  href="http://wmatvmlr401/lr4/jsLib/SemanticUi/2.0.7/semantic.css">
  <style>
    .ui.statistics .statistic > .label, .ui.statistic > .label {
      font-size: .8em;
    }
  </style>
</head>
<body>
  <div class="ui two column grid container" id="container">
    <template id="template">
      <div class="one column row">
        <div class="column">
          <div class="ui menu">
            <a class="active item" href="http://wmatvmlr401/lr4/">
              Avago
            </a>
            <a class="item" href="http://wmatvmlr401/lr4/oee-monitor/index.php">
              <i class="database icon"></i> OEE Dashboard
            </a>
              <div class="right menu">
                <a class="item" href="http://wmatvmlr401/lr4/oee-monitor/index.php/manualUpdate">
                  <i class="write icon"></i>
                </a>
              </div>
          </div>
        </div>
      </div>
        <div class="column" v-repeat="bu" v-show="show === 'all'">
          <h1 class="ui center aligned header"><a href="http://wmatvmlr401/lr4/oee-monitor/index.php/bu/{{$key}}">{{$key}}</a></h1>
          <table class="ui table">
            <tr v-repeat="$data">
              <td><h2><a href="#" v-on="click:showDetail($key,$data)">{{$key}}</a></h2></td>
              <td>
                <div class="ui {{$data.avail | color}} tiny statistic">
                  <div class="value">
                    {{$data.avail | perc}}%
                  </div>
                  <div class="label">
                    Availability
                  </div>
                </div>
              </td>
              <td>
                <div class="ui {{$data.perf | color}} tiny statistic">
                  <div class="value">
                    {{$data.perf | perc}}%
                  </div>
                  <div class="label">
                    Performance
                  </div>
                </div>
              </td>
              <td>
                <div class="ui {{$data.yiel | color}} tiny statistic">
                  <div class="value">
                    {{$data.yiel | perc}}%
                  </div>
                  <div class="label">
                    Quality
                  </div>
                </div>
              </td>
              <td>
                <div class="ui {{$data.oee | color}} statistic">
                  <div class="value">
                    {{$data.oee | perc}}%
                  </div>
                  <div class="label">
                    OEE
                  </div>
                </div>
              </td>
            </tr>
          </table>
        </div>
        <div class="one column row">
          <div class="column"  v-show="show === 'specific'">
            <button class="ui labeled icon button" v-on="click:returnToMasterTable">
              <i class="left arrow icon"></i>
              return
            </button>
            <table class="ui celled large compact selectable table">
              <thead>
                <tr>
                  <th>Start</th>
                  <th>End</th>
                  <th>Depto</th>
                  <th>Product</th>
                  <th>Process</th>
                  <th>Machine</th>
                  <th>AvailableTime</th>
                  <th>BuildQty</th>
                  <th>Aval</th>
                  <th>Perf</th>
                  <th>Yield</th>
                  <th>OEE</th>
                </tr>
              </thead>
              <tbody>
                <tr v-repeat='specific'>
                  <td>{{S_START_DT}}</td>
                  <td>{{S_END_DT}}</td>
                  <td>{{DEPTO}}</td>
                  <td>{{PRODUCT}}</td>
                  <td>{{PROCESS}}</td>
                  <td>{{SYSTEM_ID}}</td>
                  <td>{{TOTAL_PRODUCTION_TIME}}min</td>
                  <td>{{BUILD_QTY}}</td>
                  <td class="{{AVAILABILITY | color |tableColor}}">{{AVAILABILITY |perc}}%</td>
                  <td class="{{PERFORMANCE | color |tableColor}}">{{PERFORMANCE |perc}}%</td>
                  <td class="{{YIELD | color |tableColor}}">{{YIELD |perc}}%</td>
                  <td class="{{OEE | color |tableColor}}">{{OEE |perc}}%</td>
                </tr>
              </body>
            </table>
          </div>
        </div>
        

<!-- <pre>{{specific|json}}</pre> -->


    </template>
  </div>
  <script src="http://wmatvmlr401/lr4/jsLib/underscore/1.8.3/underscore.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue/0.12.9/vue.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue-resource/0.1.11/vue-resource.js"></script>
  <script src="http://wmatvmlr401/lr4/oee-monitor/js/all.js"></script>
</body>
</html>