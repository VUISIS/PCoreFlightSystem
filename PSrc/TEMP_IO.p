machine TEMP_IO
{
  var temp_name: string;
  var temp_mon: machine;
  var temperature: float;
  start state Init 
  {
    entry(name: string)
    {
        temperature = 40.0;
        temp_name = name;
    }
    on eSubscribe do (input: (name: string, mod: machine))
    {
        temp_mon = input.mod;
        goto Subscribed;
    }
  }

  state Subscribed
  {
    entry
    {
        goto Publish;
    }
  }

  state Publish
  {
    entry
    {
        var pl: seq[float];
        pl += (0, temperature);

        send temp_mon, ePublish, ( name = temp_name, payload = pl );
        goto Subscribed;
    }
  }
}