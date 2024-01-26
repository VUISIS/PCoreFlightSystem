event eSpec_Temperature: tTelemetry;

spec System observes eSpec_Temperature
{
  start state Init 
  {
    entry
    {
      goto NominalTemps;
    }
  }

  cold state NominalTemps
  {
    on eSpec_Temperature do (telem: tTelemetry)
    {
      var temps: seq[int];
      temps += (0, telem.tempA);
      temps += (1, telem.tempB);
      temps += (2, telem.tempC);
      print format("Temperature: {0}, {1}, {2}", temps[0], temps[1], temps[2]);

      if(CheckIfNotNominal(temps))
      {
        goto NonNominalTemps;
      }
    }
  }

  hot state NonNominalTemps 
  {
    on eSpec_Temperature do (telem: tTelemetry)
    {
      var temps: seq[int];
      temps += (0, telem.tempA);
      temps += (1, telem.tempB);
      temps += (2, telem.tempC);
      print format("Temperature: {0}, {1}, {2}", temps[0], temps[1], temps[2]);

      if(!CheckIfNotNominal(temps))
      {
        goto NominalTemps;
      }
    }
  }

  fun CheckIfNotNominal(temps: seq[int]): bool
  {
    var t: int;
    foreach(t in temps)
    {
      if(t > 85 || t < 45)
      {
        return true;
      }
    }
    return false;
  }
}
