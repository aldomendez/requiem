<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>OEE Manual input [update] </title>
  <link rel="stylesheet" type="text/css"  href="http://wmatvmlr401/lr4/jsLib/SemanticUi/2.0.7/semantic.css">
  <style>
.input{
  padding: -10px !important;
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
            <a class="item" href="http://wmatvmlr401/lr4/oee-monitor/index.php" alt="Return to main site">
              <i class="database icon"></i> OEE Manual input
            </a>
          </div>
        </div>
      </div>
        <div class="one column row">
          <div class="column">
            <button class="ui labeled icon button" v-on="click:returnToReferer('<?php echo $_SERVER['HTTP_REFERER']; ?>')">
              <i class="left arrow icon"></i>
              return
            </button>
            <table class="ui celled large compact selectable table">
              <thead>
                <tr>
                  <th>Intervalo</th>
                  <th>Total de piezas procesadas</th>
                  <th>Cantidad de piezas buenas</th>
                  <th class="collapsing"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-repeat='intervals'>
                  <td v-text="$value|range start finish"></td>
                  <td>
                    <div class="ui input fluid">
                      <input type="text" placeholder="" v-model="total">
                    </div>
                  </td>
                  <td>
                    <div class="ui input fluid">
                      <input type="text" placeholder="" v-model="buenas">
                    </div>
                  </td>
                  <td><a href="#" v-on="click:saveIntervalContents($index)">Guardar</a></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        

<pre>{{intervals|json}}</pre>


    </template>
  </div>
  <script src="http://wmatvmlr401/lr4/jsLib/underscore/1.8.3/underscore.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/moment/2.10.6/moment.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue/0.12.9/vue.js"></script>
  <script src="http://wmatvmlr401/lr4/jsLib/vue-resource/0.1.11/vue-resource.js"></script>
  <script src="http://wmatvmlr401/lr4/oee-monitor/js/manual_update.js"></script>
</body>
</html>