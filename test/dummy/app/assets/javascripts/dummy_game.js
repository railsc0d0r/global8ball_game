function loadGame(config) {
  var current_viewer_select = document.getElementById('current_viewer');
  var current_viewer = JSON.parse(current_viewer_select.options[current_viewer_select.selectedIndex].value);
  config.current_viewer = current_viewer;

  var current_stage_select = document.getElementById('current_stage');
  window.current_stage = current_stage_select.options[current_stage_select.selectedIndex].value;

  document.getElementById('menu_top').style.display = 'none';
  document.getElementById('menu_right').style.display = 'inline';

  window.game = window.initGlobal8Ball(config);

  window.game.events.onGetState.add(parseGetCurrentState);
}
function parseCurrentStage() {
  var current_stage_select = document.getElementById('current_stage');
  var current_stage = current_stage_select.options[current_stage_select.selectedIndex].value;

  if (current_stage == 'PlayForVictory') {
    document.getElementById('breaker').style.display = '';
  } else {
    document.getElementById('breaker').style.display = 'none';
  }
}
