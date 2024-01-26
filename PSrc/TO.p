enum tTempType { NOMINAL, HOT, COLD }
enum tTempChange { INCREASING, DECREASING, UNCHANGED }

type tTelemetry = (tempA: int, tempAChange: tTempChange, tempAType: tTempType, 
                   tempB: int, tempBChange: tTempChange, tempBType: tTempType, 
                   tempC: int, tempCChange: tTempChange, tempCType: tTempType);

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