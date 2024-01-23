type tTelemetry = (tempA: float, tempB: float, tempC: float);

event eTelemetry: tTelemetry;

machine TO
{
  start state Init 
  {
    on eTelemetry do (telem: tTelemetry)
    {

    }
  }
}