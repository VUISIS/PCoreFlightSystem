machine TEMP_MON 
{
  var telemetry: machine;
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
    on eSubscribe do (input: (name: string, mod: machine))
    {
      if(input.name == "TO")
      {
        telemetry = input.mod;
      }
    }
    on ePublish do (input: (name: string, payload: seq[float]))
    {
      var telem: tTelemetry;
      var tempChange: tTempChange;
      var tempType: tTempType; 
      tempType = TemperatureType(input.payload[0]);
      if(input.name == "A")
      {
        tempChange = TemperatureChange("A", input.payload[0]);
        temp_ioA = input.payload[0];
        telem.tempA = input.payload[0];
        telem.tempAChange = tempChange;
        telem.tempAType = tempType;
      }
      else if (input.name == "B")
      {
        tempChange = TemperatureChange("B", input.payload[0]);
        temp_ioB = input.payload[0];
        telem.tempB = input.payload[0];
        telem.tempBChange = tempChange;
        telem.tempBType = tempType;
      }
      else if (input.name == "C")
      {
        tempChange = TemperatureChange("C", input.payload[0]);
        temp_ioC = input.payload[0];
        telem.tempC = input.payload[0];
        telem.tempCChange = tempChange;
        telem.tempCType = tempType;
      }
      else
      {
        assert input.name == "A" || input.name == "B" || input.name == "C", "Input name does not match temp names.";
      }

      send telemetry, eTelemetry, telem;
    }
  }

  fun TemperatureChange(name: string, temp: float): tTempChange
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

  fun TemperatureType(temp: float): tTempType
  {
    if (temp > 85.0)
    {
      return HOT;
    }
    else if (temp < 45.0)
    {
      return COLD;
    }
    return NOMINAL;
  }
}