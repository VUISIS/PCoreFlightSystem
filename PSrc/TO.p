enum tTempType { NOMINAL, HOT, COLD }
enum tTempChange { INCREASING, DECREASING, UNCHANGED }

type tTelemetry = (tempA: float, tempAChange: tTempChange, tempAType: tTempType, 
                   tempB: float, tempBChange: tTempChange, tempBType: tTempType, 
                   tempC: float, tempCChange: tTempChange, tempCType: tTempType);

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