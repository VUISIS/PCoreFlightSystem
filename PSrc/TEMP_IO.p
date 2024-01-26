machine TEMP_IO
{
  var temp_name: string;
  var temp_mon: TEMP_MON;
  var temperature: int;
  var i: int;
  start state Init 
  {
    entry(input: (name: string, temp: int, mon: TEMP_MON))
    {
      temp_mon = input.mon;
      temperature = input.temp;
      temp_name = input.name;
    }
    on eStart goto Publish;
  }

  state Publish
  {
    entry
    {
      var pl: seq[int];
      pl += (0, temperature);

      send temp_mon, ePublish, ( name = temp_name, payload = pl );
    }
    on eSetDelta do (delta: int)
    {
      var pl: seq[int];
      temperature = temperature + delta;

      pl += (0, temperature);

      send temp_mon, ePublish, ( name = temp_name, payload = pl );
    }
  }
}