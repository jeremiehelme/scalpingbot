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
class TradeSignal
  {
private:

public:



   TradeSignalTypeEnum    type;
   double            bid;

                     TradeSignal(TradeSignalTypeEnum _type, double _bid)
     {
      type = _type;
      bid = _bid;
     }
  };
//+------------------------------------------------------------------+
