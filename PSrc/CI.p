enum tCommand = { MAIN };

event eCommand: tCommand;

machine CI
{
  start state Init 
  {
    on eSubscribe do (name: string, mod: machine)
    {
        send mod, eCommand, MAIN;
    }
  }
}