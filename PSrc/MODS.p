event eSetDelta: int;

machine MODS
{
  var tempA: TEMP_IO;
  var tempB: TEMP_IO;
  var tempC: TEMP_IO;
  var command: tCommand;
  start state Init 
  {
    ignore eTelemetry;
    on eCommand do (cmd: tCommand)
    {
      command = cmd;
    }
    on eSubscribeTemp do (input: (name: string, io: TEMP_IO))
    {
      if(input.name == "A")
      {
        tempA = input.io;
      }
      else if(input.name == "B")
      {
        tempB = input.io;
      }
      else if(input.name == "C")
      {
        tempC = input.io;
      }
    }
    on eStart do 
    {
      if(command == MAIN)
      {
        goto MAIN;
      }
      else if(command == AVERAGE)
      {
        goto AVERAGE;
      }
    }
  }

  state MAIN
  {
    ignore eTelemetry;
    on eCommand do (cmd: tCommand)
    {
      command = cmd;
      if(command == MAIN)
      {
        goto MAIN;
      }
      else if(command == AVERAGE)
      {
        goto AVERAGE;
      }
    }

  }

  state AVERAGE
  {
    on eCommand do (cmd: tCommand)
    {
      command = cmd;
      if(command == MAIN)
      {
        goto MAIN;
      }
      else if(command == AVERAGE)
      {
        goto AVERAGE;
      }
    }
    on eTelemetry do (telem: tTelemetry)
    {
      var delta: (string, int);
      if(telem.tempA != -999 &&
         telem.tempB != -999 && 
         telem.tempC != -999)
      {
        delta = CalculateDelta(telem.tempA, telem.tempB, telem.tempC);
        if(delta.0 == "A")
        {
          send tempA, eSetDelta, delta.1;
        }
        else if(delta.0 == "B")
        {
          send tempB, eSetDelta, delta.1;
        }
        else if(delta.0 == "C")
        {
          send tempC, eSetDelta, delta.1;
        }
      }
    }
  }

  fun CalculateDelta(tempA: int, tempB: int, tempC: int): (string, int)
  {
    var delta: seq[int];
    var min: int;
    var d: int;
    var s: int;
    var avg: int;
    min = 1000;
    delta += (0, tempA - tempB);
    delta += (1, tempA - tempC);
    delta += (2, tempB - tempC);

    foreach(d in delta)
    {
      if(d < 0)
      {
        d = -1*d;
      }
      
      if (d < min)
      {
        min = d;
      } 
    }

    if(min == delta[0])
    {
      avg = (tempA + tempB)/ 2;
      s = avg - tempC;
      return ("C", CapDelta(s));
    }
    else if(min == delta[1])
    {
      avg = (tempA + tempC)/ 2;
      s = avg - tempB;
      return ("B", CapDelta(s));
    }
    else if(min == delta[2])
    {
      avg = (tempB + tempC)/ 2;
      s = avg - tempA;
      return ("A", CapDelta(s));
    }
    return ("A", 0);
  }

  fun CapDelta(d: int): int
  {
    if(d > 5)
    {
      return 5;
    }
    else if (d < -5)
    {
      return -5;
    }
    return d;
  }
}