machine TEMP_MON 
{
  var telemetry: TO;
  var mods: MODS;
  var temp_ioA: int;
  var temp_ioB: int;
  var temp_ioC: int;
  var temp_ioAType: tTempType;
  var temp_ioBType: tTempType;
  var temp_ioCType: tTempType;
  var temp_ioAChange: tTempChange;
  var temp_ioBChange: tTempChange;
  var temp_ioCChange: tTempChange;
  var cur_cmd: tCommand;
  start state Init 
  {
    entry (input: (m: MODS, t: TO))
    {
      telemetry = input.t;
      mods = input.m;
      temp_ioA = -999;
      temp_ioB = -999;
      temp_ioC = -999;

      goto Monitor;
    }
    on eCommand do (cmd: tCommand)
    {
      cur_cmd = cmd;
    }
  }

  state Monitor
  {
    on eCommand do (cmd: tCommand)
    {
      cur_cmd = cmd;
    }
    on ePublish do (input: (name: string, payload: seq[int]))
    {
      var telem: tTelemetry;
      var tempChange: tTempChange;
      var tempType: tTempType; 
      tempType = TemperatureType(input.payload[0]);
      if(input.name == "A")
      {
        tempChange = TemperatureChange("A", input.payload[0]);
        temp_ioA = input.payload[0];
        temp_ioAChange = tempChange;
        temp_ioAType = tempType;
      }
      else if (input.name == "B")
      {
        tempChange = TemperatureChange("B", input.payload[0]);
        temp_ioB = input.payload[0];
        temp_ioBChange = tempChange;
        temp_ioBType = tempType;
      }
      else if (input.name == "C")
      {
        tempChange = TemperatureChange("C", input.payload[0]);
        temp_ioC = input.payload[0];
        temp_ioCChange = tempChange;
        temp_ioCType = tempType;
      }
      else
      {
        assert input.name == "A" || input.name == "B" || input.name == "C", "Input name does not match temp names.";
      }

      telem.tempA = temp_ioA;
      telem.tempB = temp_ioB;
      telem.tempC = temp_ioC;
      telem.tempAChange = temp_ioAChange;
      telem.tempBChange = temp_ioBChange;
      telem.tempCChange = temp_ioCChange;
      telem.tempAType = temp_ioAType;
      telem.tempBType = temp_ioBType;
      telem.tempCType = temp_ioCType;

      if(cur_cmd == AVERAGE)
      {
        send mods, eTelemetry, telem;
      }
      announce eSpec_Temperature, telem;
      send telemetry, eTelemetry, telem;
    }
  }

  fun TemperatureChange(name: string, temp: int): tTempChange
  {
    if (name == "A")
    {
      if (temp_ioA > temp)
      {
        return INCREASING;
      }
      else if (temp_ioA < temp)
      {
        return DECREASING;
      }
      return UNCHANGED;
    }
    else if (name == "B")
    {
      if (temp_ioB > temp)
      {
        return INCREASING;
      }
      else if (temp_ioB < temp)
      {
        return DECREASING;
      }
      return UNCHANGED;
    }
    else if (name == "C")
    {
      if (temp_ioC > temp)
      {
        return INCREASING;
      }
      else if (temp_ioC < temp)
      {
        return DECREASING;
      }
      return UNCHANGED;
    }
    return UNCHANGED;
  }

  fun TemperatureType(temp: int): tTempType
  {
    if (temp > 85)
    {
      return HOT;
    }
    else if (temp < 45)
    {
      return COLD;
    }
    return NOMINAL;
  }
}