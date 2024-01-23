machine TEMP_MON 
{
  var telemetry: TO;
  var temp_ioA: float;
  var temp_ioB: float;
  var temp_ioC: float;
  var cur_cmd: tCommand;
  start state Init 
  {
    entry
    {
      temp_ioA = 0.0;
      temp_ioB = 0.0;
      temp_ioC = 0.0;

      goto Monitor;
    }
  }

  state Monitor
  {
    on eCommand do (cmd: tCommand)
    {
      cur_cmd = cmd;
    }
    on eSubscribe do (name: string, mod: machine)
    {
      if(name == "TO")
      {
        telemetry = mod;
      }
    }
    on ePublish do (name: string, payload: seq[float])
    {
      var telem: tTelemetry;
      telem.temp = temp;
      if(name == "A")
      {
        temp_ioA = temp;
      }
      else if (name == "B")
      {
        temp_ioB = temp;
      }
      else if (name == "C")
      {
        temp_ioC = temp;
      }

      send telemetry, eTelemetry, telem;
    }
  }
}