enum tCommand { MAIN, AVERAGE }

event eCommand: tCommand;

machine CI
{
  var ci_cmd: tCommand;
  var mods: MODS;
  var mon: TEMP_MON;
  start state Init 
  {
    entry (input: (cmd: tCommand, mod: MODS, monitor: TEMP_MON))
    {
      ci_cmd = input.cmd;
      mods = input.mod;
      mon = input.monitor;
      send mon, eCommand, ci_cmd;
      send mods, eCommand, ci_cmd;
    }
  }
}