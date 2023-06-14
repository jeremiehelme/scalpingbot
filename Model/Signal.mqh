//+------------------------------------------------------------------+
//|                                                       Signal.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include "../Include/Constants.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Signal
  {
private:

public:



   SignalTypeEnum    type;
   double            bid;

                     Signal(SignalTypeEnum _type, double _bid)
     {
      type = _type;
      bid = _bid;

     }
  };
//+------------------------------------------------------------------+
