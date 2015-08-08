<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>OEE dashboard</title>
  <link rel="stylesheet" type="text/css"  href="http://wmatvmlr401/lr4/jsLib/SemanticUi/2.0.7/semantic.css">
</head>
<body>
  <div class="ui one column grid container" id="container">
    <template id="template">
      <div class="one column row">
        <div class="column">
          <div class="ui menu">
            <a class="active item" href="http://wmatvmlr401/lr4/">
              Avago
            </a>
            <a class="item">
              <i class="database icon"></i> OEE Dashboard
            </a>
          </div>
        </div>
      </div>
        <div class="column" v-repeat="b in bu">
          <h2 class="ui center aligned header">{{b.name}}</h2>
          <table class="ui orange table">
            <tr v-repeat="area in b.data">
              <td>{{area.name}}</td>
              <td>
                <div class="ui red  statistic">
                  <div class="value">
                    {{area.avail}}%
                  </div>
                  <div class="label">
                    Disponibilidad
                  </div>
                </div>
              </td>
              <td>
                <div class="ui yellow  statistic">
                  <div class="value">
                    {{area.perf}}%
                  </div>
                  <div class="label">
                    Desempe&ntilde;o
                  </div>
                </div>
              </td>
              <td>
                <div class="ui green  statistic">
                  <div class="value">
                    {{area.yiel}}%
                  </div>
                  <div class="label">
                    Calidad
                  </div>
                </div>
              </td>
              <td>
                <div class="ui green huge statistic">
                  <div class="value">
                    {{area.oee}}%
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
  <!-- // <script src="../jsLib/jquery/2.1.3/jquery.js"></script> -->
  <script scr='http://wmatvmlr401/htdocs/lr4/jsLib/underscore/1.8.3/underscore.min.js'></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue/0.12.9/vue.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue-resource/0.1.11/vue-resource.js"></script>
  <script type="text/javascript" src="http://wmatvmlr401/lr4/oee-monitor/js/single.js"></script>
</body>
</html>