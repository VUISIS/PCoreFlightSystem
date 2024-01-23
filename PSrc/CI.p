enum tCommand { MAIN }

event eCommand: tCommand;

machine CI
{
  start state Init 
  {
    on eSubscribe do (input: (name: string, mod: machine))
    {
        send input.mod, eCommand, MAIN;
    }
  }
}