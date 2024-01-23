machine TEMP_IO
{
  var temp_name: string;
  var temp_mon: TEMP_MON;
  var temperature: float;
  start state Init 
  {
    entry(name: string)
    {
        temperature = 40.0;
        temp_name = name;
    }
    on eSubscribe do (name: string, mon: machine)
    {
        temp_mon = mon;
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
        var data = seq[float];
        data += (0, temperature);

        send temp_mon, ePublish, ( name = temp_name, payload = data );
        goto Subscribed;
    }
  }
}