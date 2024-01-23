event eSubscribe: (name: string, mod: machine);
event ePublish: (name: string, payload: seq[float]);

machine CFSTest
{
  start state Init 
  {
    var commandInterface: CI;
    var temp_mon: TEMP_MON;
    var mods: MODS;
    var telem: TO;
    var tempA: TEMP_IO;
    var tempB: TEMP_IO;
    var tempC: TEMP_IO;
    entry 
    {  
      tempA = new TEMP_IO("A");
      tempB = new TEMP_IO("B");
      tempC = new TEMP_IO("C");

      telem = new TO();

      temp_mon = new TEMP_MON();
      mods = new MODS();
      commandInterface = new CI();

      send commandInterface, eSubscribe, (name = "TEMP_MON", mod = temp_mon);
      send commandInterface, eSubscribe, (name = "MODS", mod = mods);

      send temp_mon, eSubscribe,  (name = "TO", mod = telem);
      
      send tempA, eSubscribe, (name = "TEMP_MON", mod = temp_mon);
      send tempB, eSubscribe, (name = "TEMP_MON", mod = temp_mon);
      send tempC, eSubscribe, (name = "TEMP_MON", mod = temp_mon);

      send mods, eSubscribe, (name = "TEMP_IOA", mod = tempA);
      send mods, eSubscribe, (name = "TEMP_IOB", mod = tempB);
      send mods, eSubscribe, (name = "TEMP_IOC", mod = tempC);
    }
  }
}