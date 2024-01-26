event ePublish: (name: string, payload: seq[int]);
event eSubscribeTemp: (name: string, io: TEMP_IO);
event eStart;

machine CFSMainTest
{
  var commandInterface: CI;
  var temp_mon: TEMP_MON;
  var mods: MODS;
  var telem: TO;
  var tempA: TEMP_IO;
  var tempB: TEMP_IO;
  var tempC: TEMP_IO;
  start state Init 
  {
    entry 
    {  
      telem = new TO();
      mods = new MODS();

      temp_mon = new TEMP_MON((m = mods, t = telem));

      tempA = new TEMP_IO((name = "A", temp = 30, mon = temp_mon));
      tempB = new TEMP_IO((name = "B", temp = 75, mon = temp_mon));
      tempC = new TEMP_IO((name = "C", temp = 70, mon = temp_mon));

      commandInterface = new CI((cmd = MAIN, mod = mods, monitor = temp_mon));

      send mods, eSubscribeTemp, (name = "A", io = tempA);
      send mods, eSubscribeTemp, (name = "B", io = tempB);
      send mods, eSubscribeTemp, (name = "C", io = tempC);

      send tempA, eStart;
      send tempB, eStart;
      send tempC, eStart;

      send mods, eStart;
    }
  }
}

machine CFSAvgTest
{
  var commandInterface: CI;
  var temp_mon: TEMP_MON;
  var mods: MODS;
  var telem: TO;
  var tempA: TEMP_IO;
  var tempB: TEMP_IO;
  var tempC: TEMP_IO;
  start state Init 
  {
    entry 
    {  
      telem = new TO();
      mods = new MODS();

      temp_mon = new TEMP_MON((m = mods, t = telem));

      tempA = new TEMP_IO((name = "A", temp = 30, mon = temp_mon));
      tempB = new TEMP_IO((name = "B", temp = 75, mon = temp_mon));
      tempC = new TEMP_IO((name = "C", temp = 70, mon = temp_mon));

      commandInterface = new CI((cmd = AVERAGE, mod = mods, monitor = temp_mon));

      send mods, eSubscribeTemp, (name = "A", io = tempA);
      send mods, eSubscribeTemp, (name = "B", io = tempB);
      send mods, eSubscribeTemp, (name = "C", io = tempC);

      send tempA, eStart;
      send tempB, eStart;
      send tempC, eStart;

      send mods, eStart;
    }
  }
}