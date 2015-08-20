<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>OEE dashboard</title>
  <link rel="stylesheet" type="text/css"  href="http://wmatvmlr401/lr4/jsLib/SemanticUi/2.0.7/semantic.css">
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
          </div>
        </div>
      </div>
        <div class="column" v-repeat="bu">
          <!-- <pre>{{$data|json}}</pre> -->
          <h1 class="ui center aligned header"><a href="http://wmatvmlr401/lr4/oee-monitor/index.php/bu/{{$key}}">{{$key}}</a></h1>
          <table class="ui yellow table">
            <tr v-repeat="$data">
              <td><h2>{{$key}}</h2></td>
              <td>
                <div class="ui {{$data.avail | color}} small statistic">
                  <div class="value">
                    {{$data.avail | perc}}%
                  </div>
                  <div class="label">
                    Disponibilidad
                  </div>
                </div>
              </td>
              <td>
                <div class="ui {{$data.perf | color}} small statistic">
                  <div class="value">
                    {{$data.perf | perc}}%
                  </div>
                  <div class="label">
                    Desempe&ntilde;o
                  </div>
                </div>
              </td>
              <td>
                <div class="ui {{$data.yiel | color}} small statistic">
                  <div class="value">
                    {{$data.yiel | perc}}%
                  </div>
                  <div class="label">
                    Calidad
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



    </template>
  </div>
  <script src="http://wmatvmlr401/lr4/jsLib/underscore/1.8.3/underscore.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue/0.12.9/vue.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue-resource/0.1.11/vue-resource.js"></script>
  <script src="http://wmatvmlr401/lr4/oee-monitor/js/all.js"></script>
</body>
</html>